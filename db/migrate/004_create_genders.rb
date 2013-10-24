class CreateGenders < ActiveRecord::Migration
  def self.up
    create_table :genders, { :id => false  } do |t|
      t.column :id, :string, :limit => 1, :null => false
      t.column :description, :string, :limit => 13, :null => false
      t.timestamps
    end
    
    execute "alter table genders add primary key (id)"
    
    Gender.create_with_id 'M', :description => 'Male'
    Gender.create_with_id 'F', :description => 'Female'
    
  end

  def self.down
    drop_table :genders
  end
end
