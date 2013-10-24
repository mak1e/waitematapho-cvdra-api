class AddWelldU25 < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :coora_contraception_oral, :boolean
    add_column :claims_data, :coecp_contraception_ecp, :boolean
    add_column :claims_data, :codep_contraception_depo_provera, :boolean
    add_column :claims_data, :coiucd_contraception_iucd, :boolean
    add_column :claims_data, :cocon_contraception_condom, :boolean
    add_column :claims_data, :codia_contraception_diaphragm, :boolean
    add_column :claims_data, :cooth_contraception_other, :boolean
    
    add_column :claims_data, :stichl_sti_chlamydia, :boolean
    add_column :claims_data, :stihpv_sti_hpv_warts, :boolean
    add_column :claims_data, :stihsv_sti_hsv_herpes, :boolean
    add_column :claims_data, :stigon_sti_gonorrhoea, :boolean
    add_column :claims_data, :stinsu_sti_nsu, :boolean
    add_column :claims_data, :stioth_sti_other, :boolean
    
    add_column :claims_data, :shoadv_shealth_advice, :boolean
    add_column :claims_data, :shopgt_shealth_pregnancy_test, :boolean
    add_column :claims_data, :shotop_shealth_top_referral, :boolean
    add_column :claims_data, :shooth_shealth_other, :boolean
    
    ClaimsData.reset_column_information
    DataField.populate_table    

    Programme.create_with_id 14, :code => 'U25', :description => 'U25 Sexual Health'
    
    FeeSchedule.create_with_id 1400, :programme_id => 14, :code => 'U25', :description => 'U25 Claim', :fee => 36.00, :gl_account_no => '6400-74', :is_the_default => true
    
    ProgrammeElement.populate(14, [ 
                  { :position => 0,  :column_name => 'coora_contraception_oral'},
                  { :position => 1,  :column_name => 'coecp_contraception_ecp'},
                  { :position => 2,  :column_name => 'codep_contraception_depo_provera'},
                  { :position => 3,  :column_name => 'coiucd_contraception_iucd'},
                  
                  { :position => 4,  :column_name => 'cocon_contraception_condom'},
                  { :position => 5,  :column_name => 'codia_contraception_diaphragm'},
                  { :position => 6,  :column_name => 'cooth_contraception_other'},
                  
                  { :position => 8,  :column_name => 'stichl_sti_chlamydia'},
                  { :position => 9,  :column_name => 'stihpv_sti_hpv_warts'},
                  { :position => 10,  :column_name => 'stihsv_sti_hsv_herpes'},
                  { :position => 11,  :column_name => 'stigon_sti_gonorrhoea'},
                  
                  { :position => 12,  :column_name => 'stinsu_sti_nsu'},
                  { :position => 13,  :column_name => 'stioth_sti_other'},
                  
                  { :position => 16,  :column_name => 'shoadv_shealth_advice'},
                  { :position => 17,  :column_name => 'shopgt_shealth_pregnancy_test'},
                  { :position => 18,  :column_name => 'shotop_shealth_top_referral'},
                  { :position => 19,  :column_name => 'shooth_shealth_other'} ])
    
    
    
  end


  def self.down
    remove_column :claims_data, :coora_contraception_oral
    remove_column :claims_data, :coecp_contraception_ecp
    remove_column :claims_data, :codep_contraception_depo_provera
    remove_column :claims_data, :coiucd_contraception_iucd
    remove_column :claims_data, :cocon_contraception_condom
    remove_column :claims_data, :codia_contraception_diaphragm
    remove_column :claims_data, :cooth_contraception_other
    
    remove_column :claims_data, :stichl_sti_chlamydia
    remove_column :claims_data, :stihpv_sti_hpv_warts
    remove_column :claims_data, :stihsv_sti_hsv_herpes
    remove_column :claims_data, :stigon_sti_gonorrhoea
    remove_column :claims_data, :stinsu_sti_nsu
    remove_column :claims_data, :stioth_sti_other
    
    remove_column :claims_data, :shoadv_shealth_advice
    remove_column :claims_data, :shopgt_shealth_pregnancy_test
    remove_column :claims_data, :shotop_shealth_top_referral
    remove_column :claims_data, :shooth_shealth_other
    
    ClaimsData.reset_column_information
    DataField.populate_table    
    
    Programme.delete_all( 'id = 14')
    FeeSchedule.delete_all( 'programme_id = 14')    
    ProgrammeElement.delete_all( 'programme_id = 14')    
    
  end
end
