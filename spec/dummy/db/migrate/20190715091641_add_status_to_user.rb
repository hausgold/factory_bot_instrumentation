BASE_CLASS = # frozen_string_literal: true

  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
               end

class AddStatusToUser < BASE_CLASS
  def change
    add_column :users, :status, :integer
  end
end
