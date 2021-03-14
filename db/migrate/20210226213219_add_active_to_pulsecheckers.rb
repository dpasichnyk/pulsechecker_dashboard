class AddActiveToPulsecheckers < ActiveRecord::Migration[6.1]
  def change
    add_column :pulsecheckers, :active, :boolean, null: false, default: true
  end
end
