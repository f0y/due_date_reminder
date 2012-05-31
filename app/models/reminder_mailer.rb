class NoMailConfiguration < RuntimeError;
end

class ReminderMailer < Mailer
  include Redmine::I18n

  def self.send_due_date_notifications
    unless Mailer.perform_deliveries
      raise NoMailConfiguration.new(l(:text_email_delivery_not_configured))
    end
    data = {}
    issues = self.find_issues
    issues.each { |issue| self.insert(data, issue) }
    data.each do |user, projects|
      deliver_due_date_notification(user, projects)
    end
  end

  def due_date_notification(user, projects)
    set_language_if_valid user.language
    recipients user.mail
    subject l(:reminder_mail_subject)
    body :projects => projects,
         :issues_url => url_for(:controller => 'issues', :action => 'index',
                                :set_filter => 1, :assigned_to_id => user.id,
                                :sort => 'due_date:asc')
    render_multipart('due_date_notification', body)
  end


  def self.find_issues
    scope = Issue.open.scoped(:conditions => ["#{Issue.table_name}.assigned_to_id IS NOT NULL" +
                                                  " AND #{Project.table_name}.status = #{Project::STATUS_ACTIVE}" +
                                                  " AND #{Issue.table_name}.due_date IS NOT NULL" +
                                                  " AND #{User.table_name}.status = #{User::STATUS_ACTIVE}"]
    )
    issues = scope.all(:include => [:status, :assigned_to, :project, :tracker])
    issues.reject! { |issue| not (issue.remind? or issue.overdue?) }
    issues.sort! { |first, second| first.due_date <=> second.due_date }
  end

  private

  def self.insert(data, issue)
    data[issue.assigned_to] ||= {}
    data[issue.assigned_to][issue.project] ||= []
    data[issue.assigned_to][issue.project] << issue
  end

end