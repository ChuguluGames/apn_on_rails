# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{apn_on_rails}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["markbates", "Rebecca Nesson"]
  s.date = %q{2011-08-26}
  s.description = %q{APN on Rails is a Ruby on Rails gem that allows you to
easily add Apple Push Notification (iPhone) support to your Rails application.
}
  s.email = %q{tech-team@prx.org}
  s.extra_rdoc_files = [
    "LICENSE",
    "README",
    "README.textile"
  ]
  s.files = [
    ".rspec",
    ".specification",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README",
    "README.textile",
    "Rakefile",
    "VERSION",
    "apn_on_rails.gemspec",
    "autotest/discover.rb",
    "lib/apn_on_rails.rb",
    "lib/apn_on_rails/apn_on_rails.rb",
    "lib/apn_on_rails/app/models/apn/app.rb",
    "lib/apn_on_rails/app/models/apn/base.rb",
    "lib/apn_on_rails/app/models/apn/device.rb",
    "lib/apn_on_rails/app/models/apn/device_grouping.rb",
    "lib/apn_on_rails/app/models/apn/group.rb",
    "lib/apn_on_rails/app/models/apn/group_notification.rb",
    "lib/apn_on_rails/app/models/apn/notification.rb",
    "lib/apn_on_rails/app/models/apn/pull_notification.rb",
    "lib/apn_on_rails/libs/connection.rb",
    "lib/apn_on_rails/libs/feedback.rb",
    "lib/apn_on_rails/tasks/apn.rake",
    "lib/apn_on_rails/tasks/db.rake",
    "lib/apn_on_rails_tasks.rb",
    "lib/generators/apn_migrations_generator.rb",
    "lib/generators/templates/001_create_apn_devices.rb",
    "lib/generators/templates/002_create_apn_notifications.rb",
    "lib/generators/templates/003_alter_apn_devices.rb",
    "lib/generators/templates/004_create_apn_apps.rb",
    "lib/generators/templates/005_create_groups.rb",
    "lib/generators/templates/006_alter_apn_groups.rb",
    "lib/generators/templates/007_create_device_groups.rb",
    "lib/generators/templates/008_create_apn_group_notifications.rb",
    "lib/generators/templates/009_create_pull_notifications.rb",
    "lib/generators/templates/010_alter_apn_notifications.rb",
    "lib/generators/templates/011_make_device_token_index_nonunique.rb",
    "lib/generators/templates/012_add_launch_notification_to_apn_pull_notifications.rb",
    "spec/active_record/setup_ar.rb",
    "spec/apn_on_rails/app/models/apn/app_spec.rb",
    "spec/apn_on_rails/app/models/apn/device_spec.rb",
    "spec/apn_on_rails/app/models/apn/group_notification_spec.rb",
    "spec/apn_on_rails/app/models/apn/notification_spec.rb",
    "spec/apn_on_rails/app/models/apn/pull_notification_spec.rb",
    "spec/apn_on_rails/libs/connection_spec.rb",
    "spec/apn_on_rails/libs/feedback_spec.rb",
    "spec/extensions/string.rb",
    "spec/factories/app_factory.rb",
    "spec/factories/device_factory.rb",
    "spec/factories/device_grouping_factory.rb",
    "spec/factories/group_factory.rb",
    "spec/factories/group_notification_factory.rb",
    "spec/factories/notification_factory.rb",
    "spec/factories/pull_notification_factory.rb",
    "spec/fixtures/hexa.bin",
    "spec/fixtures/message_for_sending.bin",
    "spec/rails_root/config/apple_push_notification_development.pem",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/PRX/apn_on_rails}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Apple Push Notifications on Rails}
  s.test_files = [
    "spec/active_record/setup_ar.rb",
    "spec/apn_on_rails/app/models/apn/app_spec.rb",
    "spec/apn_on_rails/app/models/apn/device_spec.rb",
    "spec/apn_on_rails/app/models/apn/group_notification_spec.rb",
    "spec/apn_on_rails/app/models/apn/notification_spec.rb",
    "spec/apn_on_rails/app/models/apn/pull_notification_spec.rb",
    "spec/apn_on_rails/libs/connection_spec.rb",
    "spec/apn_on_rails/libs/feedback_spec.rb",
    "spec/extensions/string.rb",
    "spec/factories/app_factory.rb",
    "spec/factories/device_factory.rb",
    "spec/factories/device_grouping_factory.rb",
    "spec/factories/group_factory.rb",
    "spec/factories/group_notification_factory.rb",
    "spec/factories/notification_factory.rb",
    "spec/factories/pull_notification_factory.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<configatron>, [">= 0"])
      s.add_development_dependency(%q<autotest>, [">= 0"])
      s.add_development_dependency(%q<sqlite3-ruby>, ["= 1.3.3"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<actionpack>, ["~> 2.3.0"])
      s.add_development_dependency(%q<activerecord>, ["~> 2.3.0"])
    else
      s.add_dependency(%q<configatron>, [">= 0"])
      s.add_dependency(%q<autotest>, [">= 0"])
      s.add_dependency(%q<sqlite3-ruby>, ["= 1.3.3"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<actionpack>, ["~> 2.3.0"])
      s.add_dependency(%q<activerecord>, ["~> 2.3.0"])
    end
  else
    s.add_dependency(%q<configatron>, [">= 0"])
    s.add_dependency(%q<autotest>, [">= 0"])
    s.add_dependency(%q<sqlite3-ruby>, ["= 1.3.3"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<actionpack>, ["~> 2.3.0"])
    s.add_dependency(%q<activerecord>, ["~> 2.3.0"])
  end
end

