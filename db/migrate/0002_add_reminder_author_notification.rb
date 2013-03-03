class AddReminderAuthorNotification < ActiveRecord::Migration

  def self.up
    add_column(:users, "reminder_author_notification", :boolean)
  end

  def self.down
    remove_column(:users, "reminder_author_notification")
  end
end
