FactoryBot.define do
    factory :user do
        username { "testuser" }
        password { "password123" }
        role { "user" }
    end
    trait :admin do
      role { "admin" }
    end
end
