class CreatePulsecheckers < ActiveRecord::Migration[6.1]
  def change
    create_table :pulsecheckers do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :kind
      t.string :name
      t.string :url
      t.integer :interval

      t.timestamps
    end
  end
end
