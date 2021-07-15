# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Max' }
    last_name { 'Mustermann' }

    transient do
      friend_traits { [] }
      friend_overwrites { {} }
      friends_amount { 2 }
    end

    trait :confirmed do
      after(:create, &:confirmed!)
    end

    trait :with_friend do
      after(:create) do |user, elevator|
        FactoryBot.create(:user,
                          *elevator.friend_traits.map(&:to_sym),
                          friends: [user],
                          **elevator.friend_overwrites)
      end
    end

    trait :with_friends do
      after(:create) do |user, elevator|
        FactoryBot.create_list(:user,
                               elevator.friends_amount,
                               *elevator.friends_amount.map(&:to_sym),
                               friends: [user],
                               **elevator.friend_overwrites)
      end
    end
  end
end
