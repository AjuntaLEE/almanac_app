class AddAccrediteduserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :accrediteduser, :boolean, default: false
  end
end
