# frozen_string_literal: true

class User < ApplicationRecord
  has_and_belongs_to_many :friends,
                          class_name: 'User',
                          join_table: :friendships,
                          foreign_key: :user_id,
                          association_foreign_key: :friend_user_id

  enum :status, %i[confirmed unconfirmed]
end
