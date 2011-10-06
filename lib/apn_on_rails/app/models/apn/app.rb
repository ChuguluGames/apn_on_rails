class APN::App < APN::Base

  has_many :groups, :class_name => 'APN::Group', :dependent => :destroy
  has_many :devices, :class_name => 'APN::Device', :dependent => :destroy
  has_many :notifications, :through => :devices, :dependent => :destroy
  has_many :unsent_notifications, :through => :devices
  has_many :group_notifications, :through => :groups
  has_many :unsent_group_notifications, :through => :groups

  def cert
    (RAILS_ENV == 'production' ? apn_prod_cert : apn_dev_cert)
  end

  # Opens a connection to the Apple APN server and attempts to batch deliver an Array of group notifications.
  # As each APN::GroupNotification is sent the <tt>sent_at</tt> column will be timestamped, so as to not be sent again.
  def send_notifications
    if self.cert.nil?
      raise APN::Errors::MissingCertificateError.new
      return
    end
     nb_notifs = APN::Notification.count(:conditions => 'sent_at is NULL')
      puts "#{nb_notifs.to_s} notifs to be send"
      nb_cur_notif = 0
      if APN::Notification.count(:conditions => 'sent_at is NULL') > 0
        APN::Notification.find_in_batches(:conditions => 'sent_at is NULL', :batch_size => 300) do |notifs|
          APN::Connection.open_for_delivery({:cert => self.cert}) do |conn, sock|
            notifs.each do |noty|
              nb_cur_notif += 1
              begin
                conn.write(noty.message_for_sending)
              rescue Exception => e
                puts "Exception raised :"
                puts "==> Device : #{noty.inspect}"
                puts "==> Exception : #{e.to_s}"
              end
              noty.sent_at = Time.now
              noty.save
              puts "#{nb_cur_notif}/#{nb_notifs}"
            end
          end
        end
      end
  end

  def self.send_notifications
    apps = APN::App.all
    apps.each do |app|
      app.send_notifications
    end
    if !configatron.apn.cert.blank?
      global_cert = File.read(configatron.apn.cert)
      send_notifications_for_cert(global_cert, nil)
    end
  end

  #Added method to test certifications
  def test_cert!
    puts "test_cert"
    if self.cert.nil?
      puts "no certif"
      raise APN::Errors::MissingCertificateError.new
      return false
    end
    return true
  end

  def self.send_notifications_for_cert(the_cert, app_id)
    # unless self.unsent_notifications.nil? || self.unsent_notifications.empty?
      if (app_id == nil)
        conditions = "app_id is null"
      else
        conditions = ["app_id = ?", app_id]
      end
      begin
        APN::Connection.open_for_delivery({:cert => the_cert}) do |conn, sock|
          APN::Device.find_each(:conditions => conditions) do |dev|
            dev.unsent_notifications.each do |noty|
              conn.write(noty.message_for_sending)
              noty.sent_at = Time.now
              noty.save
            end
          end
        end
      rescue Exception => e
        log_connection_exception(e)
      end
    # end
  end

  #modified to use test_cert
  def send_group_notifications
    return if !self.test_cert!
    unless self.unsent_group_notifications.nil? or self.unsent_group_notifications.empty?
      APN::Connection.open_for_delivery({:cert => self.cert}) do |conn, sock|
        unsent_group_notifications.each do |gnoty|
          self.send_gnoty(gnoty, conn)
        end
      end
    end
  end

  # Modified method to restart sending from a specific device
  def send_group_notification(gnoty, from_device_id = nil)
    return if !self.test_cert!
    unless gnoty.nil?
      self.send_gnoty(gnoty, nil, from_device_id)
    end
  end

  def self.send_group_notifications
    apps = APN::App.all
    apps.each do |app|
      app.send_group_notifications
    end
  end

  # New send notification handles bad devices
  def send_gnoty(gnoty, connection, from_id = nil)
    puts "#{gnoty.devices.count} device(s) to notify"
    puts "Building message using enhanced format specifications"
    nb_cur_device = 0
    try_number = 0
    bad_devices = []
    if from_id
      @retry_from_device_id = from_id.to_i
      puts "==> Resuming from id # " + from_id.to_s
    end
    begin
      APN::Connection.open_for_delivery({:cert => self.cert}) do |conn, sock|
        devices = @retry_from_device_id.blank? ? gnoty.devices : gnoty.devices.collect{ |d| (d.id > @retry_from_device_id) ? d : nil}.uniq!
        devices.each do |device|
          next if device.blank?
          @current_device = device
          puts "Sending #{device.inspect}"
          conn.write(gnoty.message_for_sending(device))
          puts "Entering select"
          read_from = IO.select([conn, sock], nil, nil, 2)
          if read_from
            read_buffer = read_from.read(6)
            puts "CMD: #{read_buffer[0].ord}"
            puts "ERR: #{read_buffer[1].ord}"
            puts "DEV: #{read_buffer[2..5]}"
          else
            puts "Timeout!"
          end
          puts "#{nb_cur_device += 1}/#{gnoty.devices.size} sended"
          try_number = 0
        end
      end
    rescue Exception => e
      try_number += 1
      puts "Exception raised :"
      if @current_device and @current_device.id
        puts "==> Device : #{@current_device.id}"
      else
        puts "==> No current device !!"
      end
      puts "==> Exception and backtrace : #{e.to_s} \n\n#{e.backtrace.join("\n").to_s}"
      # Specific to playboy error reproting
      # ==> Exception : undefined method `log' for #<APN::App:0x00000100f65058>
      # log 'ApplicationError', {name: e.class.to_s, user_id: nil, backtrace: "#{e.to_s} \n\n Device : #{@current_device.inspect} \n\n #{e.backtrace.join("\n").to_s}", :url => "IphonePush/send_group_notifications"}
      logger.info 'ApplicationError', {name: e.class.to_s, user_id: nil, backtrace: "#{e.to_s} \n\n Device : #{@current_device.inspect} \n\n #{e.backtrace.join("\n").to_s}", :url => "IphonePush/send_group_notifications"}
      if @current_device and @current_device.id
        skip_device = (@retry_from_device_id == @current_device.id ? true : false)
        @retry_from_device_id = @current_device.id
        @retry_from_device_id += 1 if skip_device
        bad_devices << @current_device.id
      end

      if try_number != 3
        retry
      end

    end
    puts "==> Bad devices : " + bad_devices.inspect

    gnoty.sent_at = Time.now
    gnoty.save
    puts "Notification sent to #{nb_cur_device}/#{gnoty.devices.size} device(s)"
  end

  # Retrieves a list of APN::Device instnces from Apple using the <tt>devices</tt> method. It then checks to see if the
  # <tt>last_registered_at</tt> date of each APN::Device is before the date that Apple says the device is no longer
  # accepting notifications then the device is deleted. Otherwise it is assumed that the application has been re-installed
  # and is available for notifications.
  #
  # This can be run from the following Rake task: $ rake apn:feedback:process
  def process_devices
    if self.cert.nil?
      raise APN::Errors::MissingCertificateError.new
      return
    end
    APN::App.process_devices_for_cert(self.cert)
  end # process_devices

  def self.process_devices
    apps = APN::App.all
    apps.each do |app|
      app.process_devices
    end
  end

  def self.process_devices_for_cert(the_cert)

    APN::Feedback.devices(the_cert).each do |device|
      puts "Processing device #{device.id}..."
      if device.last_registered_at < device.feedback_at
        puts "    -> #{device.last_registered_at} < #{device.feedback_at} : Destroying !"
        device.destroy
      end
    end
  end

  protected
  def log_connection_exception(ex)
    puts ex.message
  end

end