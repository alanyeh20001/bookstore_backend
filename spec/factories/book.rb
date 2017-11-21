FactoryBot.define do
  factory :book do
    author

    title { Faker::Lorem.word }
    price { Faker::Number.number(2) }
  end
end
