
class ReminderMailer < Mailer

  def self.send_notifications

  end

  def self.eval_mail_data
    s = ARCondition.new ["#{IssueStatus.table_name}.is_closed = ?", false]
    s << "#{Issue.table_name}.due_date IS NOT NULL"
    s << "#{User.table_name}.status = #{User::STATUS_ACTIVE}"
    s << "#{Issue.table_name}.assigned_to_id IS NOT NULL"
    s << "#{Project.table_name}.status = #{Project::STATUS_ACTIVE}"
    s << "#{Issue.table_name}.project_id IS NOT NULL"

    issues = Issue.find(:all, :include => [:status, :assigned_to, :project, :tracker], :conditions => s.conditions)
    remind_data = {}
    overdue_data = {}
    issues.each do |issue|
      if self.remind? issue
        self.insert_issue remind_data, issue
      elsif issue.overdue?
        self.insert_issue overdue_data, issue
      end
    end
    self.sort_by_due_date(remind_data)
    self.sort_by_due_date(overdue_data)
  end

  def self.insert_issue(data, issue)
    data[issue.assigned_to] ||= {}
    data[issue.assigned_to][issue.project] ||= []
    data[issue.assigned_to][issue.project] << issue
  end

  def self.sort_by_due_date(data)
    data.each do |user, project|
      data[user][project].sort! { |first, second| first.due_date <=> second.due_date }
    end
  end

  def self.remind? (issue)
    if !issue.assigned_to.nil? and
        issue.assigned_to.reminder_notification_array.include?(issue.days_before_due_date)
      return true
    end
    false
  end


end