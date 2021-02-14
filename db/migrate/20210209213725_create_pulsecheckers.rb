class CreatePulsecheckers < ActiveRecord::Migration[6.1]
  def change
    create_table :pulsecheckers do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :kind, null: false
      t.string :name, null: false, default: ''
      t.string :url, null: false, default: ''
      t.integer :interval, null: false

      t.timestamps
    end

    add_index :pulsecheckers, %i[name user_id], unique: true
  end
end
