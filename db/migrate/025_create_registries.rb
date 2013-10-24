class CreateRegistries < ActiveRecord::Migration
  def self.up
    create_table :registries do |t|
        t.column :section, :string, :limit => 18, :null => false
        t.column :ident, :string, :limit => 18, :null => false
        t.column :value, :text
        t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :registries
  end
end
