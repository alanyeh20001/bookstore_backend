FactoryBot.define do
  factory :author do
    name Faker::Name.name

    factory :author_with_books do
      transient do
        books_count 2
      end

      after(:create) do |author, evaluator|
        create_list(:book, evaluator.books_count, author: author)
      end
    end
  end
end
