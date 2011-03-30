namespace :apn do
  
  namespace :notifications do
    
    desc "Deliver all unsent APN notifications."
    task :deliver => [:environment] do
      APN::App.send_notifications
    end

  end # notifications

  namespace :group_notifications do 

    desc "Deliver all unsent APN Group notifications."
    task :deliver, :app_id, :group_notification_id, :from_device_id, :needs => [:environment] do |t, args|
      if args.group_notification_id and args.app_id
        app = APN::App.find_by_id(args.app_id)
        if app
          gnoty = APN::GroupNotification.find_by_id(args.group_notification_id)
          app.send_group_notification(gnoty, args.from_device_id)
        else
          puts "unknown app_id and/or missing group_id"
        end
      else   
        APN::App.send_group_notifications
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
