module Reminder
  class ReminderViewHook < Redmine::Hook::ViewListener
    def view_layouts_base_body_bottom(context={})
      if context[:controller] && (context[:controller].is_a?(MyController))
        <<-SRC
        <script type='text/javascript'>
          $('#no_self_notified').parent().parent().append($('#reminder_notification'));
        </script>
        SRC
      end
    end

    def view_my_account(context={})
      <<-SRC
      <p id='reminder_notification'>
        #{context[:form].text_field :reminder_notification, :required => true, :size => 10,
                                    :value => context[:user].reminder_notification}
        <br/>
        <em>#{label_tag 'text_comma_separated', l(:text_comma_separated)}</em>
      </p>
      SRC
    end
  end
end