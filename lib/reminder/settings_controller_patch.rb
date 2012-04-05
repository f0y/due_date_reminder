module Reminder
  module SettingsControllerPatch
    def self.included(base)
      base.class_eval do
        # Same as typing in the class.
        unloadable # Send unloadable so it will not be unloaded in development.
        before_filter :check_reminder_input, :only => :plugin

        def check_reminder_input
          if request.post? and params[:id] == 'due_date_reminder' and
              !User.valid_reminder_notification?(params[:settings][:reminder_notification])
            flash[:error] = l(:error_reminder_notification_input)
            return redirect_to :action => 'plugin', :id => 'due_date_reminder'
          end
        end
      end
    end
  end
end