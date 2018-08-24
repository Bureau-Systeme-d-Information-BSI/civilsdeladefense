FactoryBot.define do
  factory :email, class: 'Email' do
    title "MyString"
    body "MyText"
    job_application nil
    administrator nil
  end
end
