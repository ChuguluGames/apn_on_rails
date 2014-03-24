# -*- encoding: utf-8 -*-
# stub: apn_on_rails 0.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "apn_on_rails"
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["markbates", "Rebecca Nesson"]
  s.date = "2014-03-20"
  s.description = "APN on Rails is a Ruby on Rails gem that allows you to\n  easily add Apple Push Notification (iPhone) support to your Rails application.\n  "
  s.email = "tech-team@prx.org"
  s.files = [".gitignore", ".rspec", ".specification", "Gemfile", "Gemfile.lock", "LICENSE", "README", "README.textile", "Rakefile", "apn_on_rails.gemspec", "autotest/discover.rb", "generators/apn_migrations_generator.rb", "generators/templates/apn_migrations/001_create_apn_devices.rb", "generators/templates/apn_migrations/002_create_apn_notifications.rb", "generators/templates/apn_migrations/003_alter_apn_devices.rb", "generators/templates/apn_migrations/004_create_apn_apps.rb", "generators/templates/apn_migrations/005_create_groups.rb", "generators/templates/apn_migrations/006_alter_apn_groups.rb", "generators/templates/apn_migrations/007_create_device_groups.rb", "generators/templates/apn_migrations/008_create_apn_group_notifications.rb", "generators/templates/apn_migrations/009_create_pull_notifications.rb", "generators/templates/apn_migrations/010_alter_apn_notifications.rb", "generators/templates/apn_migrations/011_make_device_token_index_nonunique.rb", "generators/templates/apn_migrations/012_add_launch_notification_to_apn_pull_notifications.rb", "lib/apn_on_rails.rb", "lib/apn_on_rails/apn_on_rails.rb", "lib/apn_on_rails/app/models/apn/app.rb", "lib/apn_on_rails/app/models/apn/base.rb", "lib/apn_on_rails/app/models/apn/device.rb", "lib/apn_on_rails/app/models/apn/device_grouping.rb", "lib/apn_on_rails/app/models/apn/group.rb", "lib/apn_on_rails/app/models/apn/group_notification.rb", "lib/apn_on_rails/app/models/apn/notification.rb", "lib/apn_on_rails/app/models/apn/pull_notification.rb", "lib/apn_on_rails/libs/connection.rb", "lib/apn_on_rails/libs/feedback.rb", "lib/apn_on_rails/rails/railtie.rb", "lib/apn_on_rails/tasks/apn.rake", "lib/apn_on_rails/tasks/db.rake", "lib/apn_on_rails/version.rb", "lib/apn_on_rails_tasks.rb", "lib/generators/apn_on_rails/install/USAGE", "lib/generators/apn_on_rails/install/install_generator.rb", "lib/generators/apn_on_rails/install/templates/001_create_apn_devices.rb", "lib/generators/apn_on_rails/install/templates/002_create_apn_notifications.rb", "lib/generators/apn_on_rails/install/templates/003_alter_apn_devices.rb", "lib/generators/apn_on_rails/install/templates/004_create_apn_apps.rb", "lib/generators/apn_on_rails/install/templates/005_create_groups.rb", "lib/generators/apn_on_rails/install/templates/006_alter_apn_groups.rb", "lib/generators/apn_on_rails/install/templates/007_create_device_groups.rb", "lib/generators/apn_on_rails/install/templates/008_create_apn_group_notifications.rb", "lib/generators/apn_on_rails/install/templates/009_create_pull_notifications.rb", "lib/generators/apn_on_rails/install/templates/010_alter_apn_notifications.rb", "lib/generators/apn_on_rails/install/templates/011_make_device_token_index_nonunique.rb", "lib/generators/apn_on_rails/install/templates/012_add_launch_notification_to_apn_pull_notifications.rb", "spec/active_record/setup_ar.rb", "spec/apn_on_rails/app/models/apn/app_spec.rb", "spec/apn_on_rails/app/models/apn/device_spec.rb", "spec/apn_on_rails/app/models/apn/group_notification_spec.rb", "spec/apn_on_rails/app/models/apn/notification_spec.rb", "spec/apn_on_rails/app/models/apn/pull_notification_spec.rb", "spec/apn_on_rails/libs/connection_spec.rb", "spec/apn_on_rails/libs/feedback_spec.rb", "spec/extensions/string.rb", "spec/factories/app_factory.rb", "spec/factories/device_factory.rb", "spec/factories/device_grouping_factory.rb", "spec/factories/group_factory.rb", "spec/factories/group_notification_factory.rb", "spec/factories/notification_factory.rb", "spec/factories/pull_notification_factory.rb", "spec/fixtures/hexa.bin", "spec/fixtures/message_for_sending.bin", "spec/rails_root/config/apple_push_notification_development.pem", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/PRX/apn_on_rails"
  s.rubygems_version = "2.2.2"
  s.summary = "Apple Push Notifications on Rails"
  s.test_files = ["spec/active_record/setup_ar.rb", "spec/apn_on_rails/app/models/apn/app_spec.rb", "spec/apn_on_rails/app/models/apn/device_spec.rb", "spec/apn_on_rails/app/models/apn/group_notification_spec.rb", "spec/apn_on_rails/app/models/apn/notification_spec.rb", "spec/apn_on_rails/app/models/apn/pull_notification_spec.rb", "spec/apn_on_rails/libs/connection_spec.rb", "spec/apn_on_rails/libs/feedback_spec.rb", "spec/extensions/string.rb", "spec/factories/app_factory.rb", "spec/factories/device_factory.rb", "spec/factories/device_grouping_factory.rb", "spec/factories/group_factory.rb", "spec/factories/group_notification_factory.rb", "spec/factories/notification_factory.rb", "spec/factories/pull_notification_factory.rb", "spec/fixtures/hexa.bin", "spec/fixtures/message_for_sending.bin", "spec/rails_root/config/apple_push_notification_development.pem", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<configatron>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<actionpack>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<autotest>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<configatron>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<actionpack>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<autotest>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<configatron>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<actionpack>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<autotest>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end
