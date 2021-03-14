class AddResponseTimeToPulsecheckers < ActiveRecord::Migration[6.1]
  def change
    add_column :pulsecheckers, :response_time, :integer, null: false, default: 500
  end
end
