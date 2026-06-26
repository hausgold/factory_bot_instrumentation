# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[8.1]
  def self.up
    create_table :friendships, id: false do |t|
      t.integer :user_id
      t.integer :friend_user_id
    end

    add_index(:friendships, %i[user_id friend_user_id], unique: true)
    add_index(:friendships, %i[friend_user_id user_id], unique: true)
  end

  def self.down
    remove_index(:friendships, %i[friend_user_id user_id])
    remove_index(:friendships, %i[user_id friend_user_id])
    drop_table :friendships
  end
end
