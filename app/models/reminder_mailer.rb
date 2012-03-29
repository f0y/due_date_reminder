class ReminderMailer < Mailer

  def self.send_notifications

  end

  def self.eval_mail_data
    [
        {
            :user => 'admin',
            :projects => [
                {
                    :project => 2,
                    :issues => [1, 2, 3]
                },
                {
                    :project => 3,
                    :issues => [5, 6, 7]
                }

            ]
        }
    ]
  end

end