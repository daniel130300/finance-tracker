class AddFirstNameLastNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :lasrt_name, :string

  end
end
