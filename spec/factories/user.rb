FactoryBot.define do
  factory :user do
    transient do
      is_admin false
    end

    email    { Faker::Internet.email }
    password { Faker::Number.number(10) }
    admin    { is_admin ? true : false }
  end
end
