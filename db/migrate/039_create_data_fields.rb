class CreateDataFields < ActiveRecord::Migration
  def self.up
    create_table :data_fields do |t|
      t.column 'column_name', :string, :limit => 50, :null => false
      t.column 'label', :string, :limit => 50, :null => false
      t.column 'data_type', :string, :limit => 8, :null => false
      t.column 'limit', :integer
      t.column 'choices', :string, :limit => 200
    end
    change_column :programme_elements, :column_name, :string, :limit => 50
    add_index :data_fields, [:column_name]
  end

  def self.down
    drop_table :data_fields
  end
end
