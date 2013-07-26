class NoMailConfiguration < RuntimeError;
end


class ReminderMailer < Mailer
  include Redmine::I18n

  def self.issue_attrs
    {:assigned_to => "reminder_assigned_to",
     :author => "reminder_author"}
  end

  prepend_view_path "#{Redmine::Plugin.find("due_date_reminder").directory}/app/views"

  def self.due_date_notifications
    unless ActionMailer::Base.perform_deliveries
      raise NoMailConfiguration.new(l(:text_email_delivery_not_configured))
    end

    self.build_issues.each do |user, projects|
      due_date_notification(user, projects).deliver
    end
  end

  def due_date_notification(user, projects)
    set_language_if_valid user.language
    puts "User: #{user.name}. Setting for notification: #{user.reminder_notification}"
    puts "Issues:"
    projects.each { |project, issues| puts "Project: #{project.name}"; puts "Issues: #{issues.map(&:id)}"}
    @projects = projects
    @issues_url = url_for(:controller => 'issues', :action => 'index',
                          :set_filter => 1, :assigned_to_id => user.id,
                          :sort => 'due_date:asc')
    mail :to => user.mail, :subject => l(:reminder_mail_subject)
  end


  def self.build_issues
    data = {}
    Issue.open.scoped(
        :conditions => ["#{Project.table_name}.status = #{Project::STATUS_ACTIVE}" +
                        " AND #{Issue.table_name}.due_date IS NOT NULL"]).
        all(:include => [:status, :project, :tracker]).
        reject { |issue| not issue.remind? }.
        sort { |first, second| first.due_date <=> second.due_date }.
        each { |issue| self.append_issue(data, issue)}
    data
  end

  private

  def self.append_issue(data, issue)
    self.issue_attrs.keys.each { |attr|
      user = issue.send(attr)
      next if user.nil? or not user.active?
      data[user] ||= {}
      data[user][issue.project] ||= {}
      data[user][issue.project][attr] ||= []
      data[user][issue.project][attr] << issue
      return
    }
  end

end