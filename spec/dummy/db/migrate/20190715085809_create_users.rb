if Rails::VERSION::MAJOR >= 5
  BASE_CLASS = ActiveRecord::Migration[4.2]
else
  BASE_CLASS = ActiveRecord::Migration
end

class CreateUsers < BASE_CLASS
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
  end
end
