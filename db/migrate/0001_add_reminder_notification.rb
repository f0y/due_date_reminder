class AddReminderNotification < ActiveRecord::Migration

  def self.up
    add_column(:users, "reminder_notification", :string)
  end

  def self.down
    remove_column(:users, "reminder_notification")
  end
end
