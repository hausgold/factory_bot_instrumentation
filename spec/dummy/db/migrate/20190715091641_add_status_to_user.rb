if Rails::VERSION::MAJOR >= 5
  BASE_CLASS = ActiveRecord::Migration[4.2]
else
  BASE_CLASS = ActiveRecord::Migration
end

class AddStatusToUser < BASE_CLASS
  def change
    add_column :users, :status, :integer
  end
end
