class AddCategoryReminderNotification < ActiveRecord::Migration

  def self.up
    add_column(:issue_categories, "reminder_notification", :string)
  end

  def self.down
    remove_column(:issue_categories, "reminder_notification")
  end
end
