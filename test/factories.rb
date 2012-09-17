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
    status_id 1
    priority_id 6
    author_id 1
    project_id 1
    subject "subject"
  end

end