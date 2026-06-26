# frozen_string_literal: true

class AddStatusToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :status, :integer
  end
end
