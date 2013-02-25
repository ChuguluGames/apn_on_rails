namespace :apn do

  namespace :notifications do

    desc "Deliver all unsent APN notifications."
    task :deliver => [:environment] do
      APN::App.send_notifications
    end

  end # notifications

  namespace :group_notifications do

    desc "Deliver all unsent APN Group notifications."
    task :deliver, [:app_id, :group_notification_id, :from_device_id] => [:environment] do |t, args|
      puts 'Deliver group notifications'
      puts "Delivering group #{args.group_notification_id}"
      begin
        if args.group_notification_id and args.app_id
          app = APN::App.find_by_id(args.app_id)
          if app
            gnoty = APN::GroupNotification.find_by_id(args.group_notification_id)
            puts "gnoty #{gnoty.inspect}"
            app.send_group_notification(gnoty, args.from_device_id)
          else
            puts "unknown app_id and/or missing group_id"
          end
        else
          APN::App.send_group_notifications
        end
      rescue Exception => e
        puts "Exception raised :"
        puts "==> Exception : #{e.to_s} \n\n#{e.backtrace.join("\n").to_s}"
      end
    end

  end # group_notifications

  namespace :feedback do

    desc "Process all devices that have feedback from APN."
    task :process => [:environment] do
      APN::App.process_devices
    end

  end

end # apn
