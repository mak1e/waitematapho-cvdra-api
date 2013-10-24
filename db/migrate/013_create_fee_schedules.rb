class CreateFeeSchedules < ActiveRecord::Migration
  def self.up
    create_table :fee_schedules do |t|
      t.integer "programme_id", :null => false
      
      t.string  "code", :limit => 8, :null => false
      t.string  "description", :limit => 38, :null => false
      
      t.decimal "fee", :precision => 8, :scale => 2
      t.string  "detail", :limit => 78
      t.string  "gl_account_no", :limit => 8
      
      t.boolean "is_the_default", :default => false, :null => false
      t.boolean "deleted", :default => false, :null => false

      t.timestamps
    end
    
    add_index "fee_schedules", ["programme_id"]

    FeeSchedule.create_with_id 10, :programme_id => 1, :code => 'CPIA', :description => 'Care Plus Initial Assessment', :is_the_default => true, :fee => 50.00 , :gl_account_no => '6-1103'
    FeeSchedule.create_with_id 11, :programme_id => 1, :code => 'CPFU', :description => 'Care Plus Follow Up', :fee => 50.00, :gl_account_no => '6-1104'
    
    FeeSchedule.create_with_id 20, :programme_id => 2, :code => 'CVDRA', :description => 'CVD Risk Assessment' , :is_the_default => true, :fee => 25.00, :gl_account_no => '6-2117'
    FeeSchedule.create_with_id 21, :programme_id => 2, :code => 'CVDMP', :description => 'CVD Management Plan', :fee => 50.00 , :gl_account_no => '6-2118'
    FeeSchedule.create_with_id 22, :programme_id => 2, :code => 'CVDRP', :description => 'CVD Risk and Management Plan', :fee => 75.00 , :gl_account_no => '6-2118'
    FeeSchedule.create_with_id 23, :programme_id => 2, :code => 'CVDCP', :description => 'CVD Care Plus Follow Up', :fee => 50.00, :gl_account_no => '6-1104'
    
    FeeSchedule.create_with_id 30, :programme_id => 3, :code => 'DIAR', :description => 'Diabetes Annual Review', :is_the_default => true, :fee => 50.00, :gl_account_no => '6-3002'
    FeeSchedule.create_with_id 31, :programme_id => 3, :code => 'DIFU', :description => 'Diabetes Follow-up'
    
    FeeSchedule.create_with_id 40, :programme_id => 4, :code => 'ASAS', :description => 'Asthma Assessment', :is_the_default => true, :fee => 50.00, :gl_account_no => '6-9999'
    
    FeeSchedule.create_with_id 50, :programme_id => 5, :code => 'SIAAC', :description => 'Adolescent Clinic', :gl_account_no => '6-3001'
    FeeSchedule.create_with_id 51, :programme_id => 5, :code => 'SIACV', :description => 'Community Voucher', :gl_account_no => '6-3004'
    FeeSchedule.create_with_id 52, :programme_id => 5, :code => 'SIASL', :description => 'Skin Lesion', :gl_account_no => '6-3006'
    FeeSchedule.create_with_id 53, :programme_id => 5, :code => 'SIATC', :description => 'Terminal Care', :gl_account_no => '6-3007'
    FeeSchedule.create_with_id 54, :programme_id => 5, :code => 'SIAPD', :description => 'Podiatry', :gl_account_no => '6-3008'
    FeeSchedule.create_with_id 55, :programme_id => 5, :code => 'SIARA', :description => 'Radiology', :gl_account_no => '6-3009'
    FeeSchedule.create_with_id 56, :programme_id => 5, :code => 'SIAIS', :description => 'Interpretation', :gl_account_no => '6-3011'

  end


  def self.down
    drop_table :fee_schedules
  end
end
