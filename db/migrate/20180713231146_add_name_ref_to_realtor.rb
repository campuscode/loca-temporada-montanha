class AddNameRefToRealtor < ActiveRecord::Migration[5.2]
  def change
    add_column :realtors, :name, :string
  end
end
