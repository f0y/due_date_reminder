module Reminder
  module SettingPatch

    @@option_name = :reminder_notification
    @@base_class = nil

    def self.default_reminder_notification=(value)
      @@base_class.class_eval <<-"END_SRC", __FILE__, __LINE__
            class_variable_get(:@@available_settings)['#{@@option_name}']['default'] = '#{value}'
      END_SRC
    end

    def self.included(base)
      @@base_class = base
      base.class_eval <<-"END_SRC", __FILE__, __LINE__

        unloadable # Send unloadable so it will not be unloaded in development.

        class_variable_get(:@@available_settings)['#{@@option_name}'] = {}

        def self.#{@@option_name}
            self[:#{@@option_name}]
        end

        def self.#{@@option_name}=(value)
            self[:#{@@option_name}] = value
        end

        def self.#{@@option_name}?
            self[:#{@@option_name}].to_i > 0
        end

      END_SRC

    end
  end
end