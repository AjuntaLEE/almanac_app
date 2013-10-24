class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.string :name
      t.string :hourlist
      t.boolean :armed, default: false

      t.timestamps
    end
    add_index :vacations, :name, unique: true
  end
end
