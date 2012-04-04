require 'redmine'
require 'reminder/user_patch'
require 'reminder/issue_patch'
require 'reminder/my_controller_patch'
require 'reminder/settings_controller_patch'
require 'reminder/view_hook'
require 'dispatcher'

Dispatcher.to_prepare :redmine_private_wiki do
  unless User.included_modules.include? Reminder::UserPatch
    User.send(:include, Reminder::UserPatch)
  end

  unless Issue.included_modules.include? Reminder::IssuePatch
    Issue.send(:include, Reminder::IssuePatch)
  end

  unless SettingsController.included_modules.include? Reminder::SettingsControllerPatch
    SettingsController.send(:include, Reminder::SettingsControllerPatch)
  end

  unless MyController.included_modules.include? Reminder::MyControllerPatch
    MyController.send(:include, Reminder::MyControllerPatch)
  end
end

Redmine::Plugin.register :redmine_reminder do
  name 'Redmine Reminder plugin'
  author 'Oleg Kandaurov'
  description 'Sends notifications about due date'
  version '0.0.1'
  url 'https://github.com/f0y/redmine_reminder'
  author_url 'http://okandaurov.info'
  settings :default => {'reminder_notification' => '1,3,5'}, :partial => 'reminder/settings'
end
