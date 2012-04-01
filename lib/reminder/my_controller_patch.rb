module Reminder
  module MyControllerPatch

    def self.included(base)
      base.class_eval do
        # Same as typing in the class.
        unloadable # Send unloadable so it will not be unloaded in development.
        before_filter :check_reminder_input, :only => :account

        def check_reminder_input
          if request.post? and !User.valid_reminder_notification?(params[:user][:reminder_notification])
            flash[:error] = l(:error_reminder_notification_input)
            return redirect_to :action => 'account'
          end
        end
      end
    end
  end
end