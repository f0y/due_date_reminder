namespace :redmine do
  namespace :reminder_plugin do
    task :send_notifications => :environment do
      Mailer.with_synched_deliveries do
        ReminderMailer.due_date_notifications
      end
    end
  end
end

