class AddSettingsGlCbf < ActiveRecord::Migration
  def self.up
    add_column :settings, :cbf_cap_gl_account_no, :string, :limit => 18 # First Contact Services (Capitation)
    add_column :settings, :cbf_ded_gl_account_no, :string, :limit => 18 # GMS Casual / Fee for Service Deductions 
    add_column :settings, :cbf_cplus_gl_account_no, :string, :limit => 18 # Care Plus
    add_column :settings, :cbf_under6_gl_account_no, :string, :limit => 18 # Under Sixes
    add_column :settings, :cbf_vcla_gl_account_no, :string, :limit => 18 # Very Low Cost Access
    
    add_column :settings, :cbf_hp_gl_account_no, :string, :limit => 18 # NOT used as yet # Health Promotion
    add_column :settings, :cbf_sia_gl_account_no, :string, :limit => 18 # NOT used as yet # Services to Improve Access
  end

  def self.down
    remove_column :settings, :cbf_cap_gl_account_no
    remove_column :settings, :cbf_ded_gl_account_no 
    remove_column :settings, :cbf_cplus_gl_account_no
    remove_column :settings, :cbf_under6_gl_account_no
    remove_column :settings, :cbf_vcla_gl_account_no
    
    remove_column :settings, :cbf_hp_gl_account_no
    remove_column :settings, :cbf_sia_gl_account_no
  end
end
