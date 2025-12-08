FactoryBot.define do
    factory :user do
        username { "testuser" }
        password { "password123" }
        password_confirmation { "password123" } 
        role { "user" }
    end
    trait :admin do
      role { "admin" }
    end
    trait :organizer do
      role { "organizer" }
    end
end
