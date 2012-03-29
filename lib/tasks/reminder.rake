task :default => 'redmine:reminder_plugin:send_notifications'

namespace :redmine do
  namespace :reminder_plugin do
    task :send_notifications => :environment do
      ReminderMailer.send_notifications
    end
  end
end

