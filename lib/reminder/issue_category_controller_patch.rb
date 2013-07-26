module Reminder
  module IssueControllerPatch

    def self.included(base)
      base.class_eval do
        unloadable
        before_filter :check_reminder_input, :only => :update

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