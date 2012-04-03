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
  end
end