class AddSlugToPulsechecker < ActiveRecord::Migration[6.1]
  def change
    add_column :pulsecheckers, :slug, :string, null: false
  end
end
