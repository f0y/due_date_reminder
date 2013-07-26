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
      if !assigned_to.nil? 
        if assigned_to.present? and category.present? && category.reminder_notification_array.any?
          return category.reminder_notification_array.include?(days_before_due_date)
        elsif assigned_to.is_a?(User) and ((assigned_to.reminder_notification_array.include?(days_before_due_date) or overdue?)) or
                (author.reminder_notification? and
                 (author.reminder_notification_array.include?(days_before_due_date) or overdue?))

        else
           return false
        end
      end
    end
  end
end