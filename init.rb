require 'redmine'
require 'reminder/user_patch'
require 'dispatcher'

Dispatcher.to_prepare :redmine_private_wiki do
  unless User.included_modules.include? Reminder::UserPatch
    User.send(:include, Reminder::UserPatch)
  end
end

Redmine::Plugin.register :redmine_reminder do
  name 'Redmine Reminder plugin'
  author 'Oleg Kandaurov'
  description 'Sends notifications about due date'
  version '0.0.1'
  url 'https://github.com/f0y/redmine_reminder'
  author_url 'http://okandaurov.info'
end
