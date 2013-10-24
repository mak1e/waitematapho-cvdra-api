class AddHaurakiU25 < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :provt_provider_type, :string, :limit => 18
    ClaimsData.reset_column_information
    DataField.populate_table
    
    FeeSchedule.update_all("fee = 33.00", "id=1400")
    
    if ( Settings.database =~ /haupho|phocm/ )
       puts "Hauraki PHO - U25 Sexual Health, programme_id #14"
       
       # Note The xml from medtech, generates multiple !!! Services need to add together

       ProgrammeElement.populate(14, [ 
                   { :position => 0,  :column_name => 'cacxs_cervical_screening'},
                   { :position => 1,  :column_name => 'cooth_contraception_other'},
                   { :position => 2,  :column_name => 'shopgt_shealth_pregnancy_test'},
                   
                   { :position => 4,  :column_name => 'stioth_sti_other'},
                   { :position => 5,  :column_name => 'shotop_shealth_top_referral'},
                   
                   { :position => 8,  :column_name => 'provt_provider_type'},
                   
                   { :position => 12,  :column_name => 'cocon_contraception_condom'},
                   { :position => 13,  :column_name => 'codep_contraception_depo_provera'},
                   { :position => 14,  :column_name => 'coiucd_contraception_iucd'},
                   { :position => 15,  :column_name => 'coora_contraception_oral'}
                   ]); 
                   
    end
  end

  def self.down
  end
end
