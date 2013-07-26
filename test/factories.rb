FactoryGirl.define do

  factory :project do
    sequence(:name) {|i| "Name #{i} "}
    sequence(:identifier) {|i| "ident#{i}"}
  end


  factory :user do
    sequence(:login) {|i| "login#{i}"}
    sequence(:firstname) {|i| "firstname#{i}"}
    sequence(:lastname) {|i| "lastname#{i}"}
    sequence(:mail) {|i| "login#{i}@example.net"}
    status User::STATUS_ACTIVE
  end

  factory :issue do
    tracker_id 1
    association :status, factory: :issue_status
    association :priority, factory: :issue_priority
    association :author, factory: :user
    project_id 1
    subject "subject"
  end

  factory :issue_status do
    sequence(:id) {|i| "#{i}"}
    sequence(:name) {|i| "status#{i}"}
  end

  factory :issue_priority do
    sequence(:id) {|i| "#{i}"}
    sequence(:name) {|i| "priority#{i}"}
  end

end