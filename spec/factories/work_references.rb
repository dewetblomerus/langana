FactoryGirl.define do
  factory :work_reference do
    employer nil
    worker nil
    work 'MyString'
    comment 'MyText'
    rating 1
    recommend false
  end
end
