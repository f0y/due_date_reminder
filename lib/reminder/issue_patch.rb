module Reminder
  module IssuePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
  end

  module InstanceMethods
    def days_before_due_date
      (due_date - Date.today).to_i
    end

    def remind?
      if assigned_to.present?
        if category.present? && category.reminder_notification_array.any?
          return category.reminder_notification_array.include?(days_before_due_date)
        else
          return assigned_to.reminder_notification_array.include?(days_before_due_date)
        end
      end
      false
    end
  end
end