BASE_CLASS = # frozen_string_literal: true

  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
               end

class CreateFriendships < BASE_CLASS
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
