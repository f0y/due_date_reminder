module Reminder
  module IssueCategoryPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        safe_attributes 'reminder_notification'
        validates_format_of :reminder_notification, :with => /^(\A(\d+[\s,]*)+\z)|(\s)$/, :on => :update

      end
    end

    module InstanceMethods
      def reminder_notification_array
        unless reminder_notification.blank?
          return reminder_notification.split(%r{[\s,]}).collect(&:to_i).uniq.select { |n| n >= 0 }.sort
        end
        []
      end
    end
  end
end