namespace :redmine do
  namespace :reminder_plugin do
    task :send_notifications => :environment do
      ReminderMailer.send_due_date_notifications
    end
  end
end

