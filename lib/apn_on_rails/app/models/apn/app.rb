# encoding: utf-8
class APN::App < APN::Base

  has_many :groups, :class_name => 'APN::Group', :dependent => :destroy
  has_many :devices, :class_name => 'APN::Device', :dependent => :destroy
  has_many :notifications, :through => :devices, :dependent => :destroy
  has_many :unsent_notifications, :through => :devices
  has_many :group_notifications, :through => :groups
  has_many :unsent_group_notifications, :through => :groups

  def cert
    (::Rails.env.production? ? apn_prod_cert : apn_dev_cert)
  end

  # Opens a connection to the Apple APN server and attempts to batch deliver
  # an Array of group notifications.
  #
  #
  # As each APN::GroupNotification is sent the <tt>sent_at</tt> column will be timestamped,
  # so as to not be sent again.
  #
  def send_notifications
    if self.cert.nil?
      raise APN::Errors::MissingCertificateError.new
      return
    end
    APN::App.send_notifications_for_cert(self.cert, self.id)
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

  def self.send_notifications_for_cert(the_cert, app_id)
    # unless self.unsent_notifications.nil? || self.unsent_notifications.empty?
    if (app_id == nil)
      conditions = "app_id is null"
    else
      conditions = ["app_id = ?", app_id]
    end
    last_device_id = 0
    last_noty_id   = 0
    catch :done do
      while true do
        catch :retry do
          conn = APN::Connection.open_for_delivery({cert: the_cert})
          APN::Device.where('id >= ? AND app_id = ?', last_device_id, app_id).order(:id).each do |device|
            last_device_id = device.id
            buffer = String.new
            bin = APN::BinaryNotification.new
            bin.device_token = device.token
            notification_ids = []
            device.unsent_notifications.where('id > ?', last_noty_id).order(:id).each do |noty|
              notification_ids << noty.id
              bin.payload         = noty.to_apple_json
              bin.identifier      = noty.id
              bin.expiration_date = 1.hour.from_now
              bin.priority        = APN::BinaryNotification::PRIORITY_HIGH
              buffer << bin.data
            end
            next if buffer.length < 1
            conn.write(buffer)
            # if we get a response from APNS the current connection is toast
            # so we have to [skip bad devices/notifications if needed and ]reconnect/resume sending
            rconns, = IO.select([conn], nil, nil, 0.1)
            if rconns and rconns[0].is_a?(conn.class)
              result   = rconns[0].read(APN::APNSResponse::RESPONSE_LENGTH)
              response = APN::APNSResponse.new(result)
              case response.status
              when APN::APNSResponse::STATUS_INVALID_TOKEN_SIZE, APN::APNSResponse::STATUS_INVALID_TOKEN, APN::APNSResponse::STATUS_MISSING_DEVICE_TOKEN
                # shitty device, skip (delete from db?)
                last_device_id = last_device_id + 1
                last_noty_id   = 0
              when APN::APNSResponse::STATUS_INVALID_PAYLOAD_SIZE, APN::APNSResponse::STATUS_MISSING_PAYLOAD
                # shitty notif, skip (delete from db?)
                # get next valid noty id (if there are gaps in IDs, to avoid infinite loops we can't just do id + 1)
                if (valid_index = notification_ids.index(response.notification_identifier)).nil?
                  # whooops... not sure what to do here...
                elsif notification_ids.size - valid_index > 1 # if not last noty
                  last_noty_id = notification_ids[valid_index + 1]
                else # that was the last noty for this device, skip device
                  last_device_id = last_device_id + 1
                  last_noty_id   = 0
                end
              else # resume from last successful noty
                last_noty_id = response.notification_identifier
              end
              # cleanup connections before retrying
              APN::Connection.close
              throw :retry
            else # no response from APNS for current device => tits! we can flag sent notifications and move on
              last_noty_id = 0
              device.unsent_notifications.update_all({sent_at: Time.now})
            end
          end # all done
          throw :done
        end
      end
    end
    ensure
      APN::Connection.close
  end

  def send_group_notifications
    if self.cert.nil?
      raise APN::Errors::MissingCertificateError.new
      return
    end
    unless self.unsent_group_notifications.nil? || self.unsent_group_notifications.empty?
      unsent_group_notifications.each do |gnoty|
        failed = 0
        devices_to_send = gnoty.devices.count
        gnoty.devices.find_in_batches(:batch_size => 100) do |devices|
          APN::Connection.open_for_delivery({:cert => self.cert}) do |conn, sock|
            devices.each do |device|
              begin
                conn.write(gnoty.message_for_sending(device))
              rescue Exception => e
                puts e.message
                failed += 1
              end
            end
          end
        end
        puts "Sent to: #{devices_to_send - failed}/#{devices_to_send} "
        gnoty.sent_at = Time.now
        gnoty.save
      end
    end
  end

  def send_group_notification(gnoty)
    if self.cert.nil?
      raise APN::Errors::MissingCertificateError.new
      return
    end
    unless gnoty.nil?
      APN::Connection.open_for_delivery({:cert => self.cert}) do |conn, sock|
        gnoty.devices.find_each do |device|
          conn.write(gnoty.message_for_sending(device))
        end
        gnoty.sent_at = Time.now
        gnoty.save
      end
    end
  end

  def self.send_group_notifications
    apps = APN::App.all
    apps.each do |app|
      app.send_group_notifications
    end
  end

  # Retrieves a list of APN::Device instnces from Apple using
  # the <tt>devices</tt> method. It then checks to see if the
  # <tt>last_registered_at</tt> date of each APN::Device is
  # before the date that Apple says the device is no longer
  # accepting notifications then the device is deleted. Otherwise
  # it is assumed that the application has been re-installed
  # and is available for notifications.
  #
  # This can be run from the following Rake task:
  #   $ rake apn:feedback:process
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
    if !configatron.apn.cert.blank?
      global_cert = File.read(configatron.apn.cert)
      APN::App.process_devices_for_cert(global_cert)
    end
  end

  def self.process_devices_for_cert(the_cert)
    puts "in APN::App.process_devices_for_cert"
    APN::Feedback.devices(the_cert).each do |device|
      if device.last_registered_at < device.feedback_at
        puts "device #{device.id} -> #{device.last_registered_at} < #{device.feedback_at}"
        device.destroy
      else
        puts "device #{device.id} -> #{device.last_registered_at} not < #{device.feedback_at}"
      end
    end
  end

  protected

  def self.log_connection_exception(ex)
    STDERR.puts ex.message
    raise ex
  end

end
