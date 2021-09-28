class RenameLastnameColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :lasrt_name, :last_name
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
