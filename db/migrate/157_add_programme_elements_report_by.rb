class AddProgrammeElementsReportBy < ActiveRecord::Migration
  def self.up
    add_column :programme_elements , :report_by, :string, :limit => 36
    add_column :programme_elements , :report_by_transpose, :boolean
    
    add_column :programme_elements , :report_by_2, :string, :limit => 36
    add_column :programme_elements , :report_by_transpose_2, :boolean
    
    ProgrammeElement.reset_column_information

    add_column :ethnicities , :ethnicity_level1, :string, :limit => 18
    add_column :ethnicities , :order_by_level1, :integer
    
    add_column :ethnicities , :ethnicity_mpi, :string, :limit => 18
    add_column :ethnicities , :order_by_mpi, :integer

    Ethnicity.reset_column_information
    
    Ethnicity.update_all("ethnicity_level1 = 'European', order_by_level1 = 1","id >= 10 and id < 20")
    Ethnicity.update_all("ethnicity_level1 = 'Maori', order_by_level1 = 2","id >= 20 and id < 30")
    Ethnicity.update_all("ethnicity_level1 = 'Pacific-I', order_by_level1 = 3","id >= 30 and id < 40")
    Ethnicity.update_all("ethnicity_level1 = 'Asian', order_by_level1 = 4","id >= 40 and id < 50")
    Ethnicity.update_all("ethnicity_level1 = 'Other', order_by_level1 = 5","id >= 50")
    
    Ethnicity.update_all("ethnicity_mpi = 'Other', order_by_mpi = 5","id >= 10 and id < 20");
    Ethnicity.update_all("ethnicity_mpi = 'Maori', order_by_mpi = 2","id >= 20 and id < 30");
    Ethnicity.update_all("ethnicity_mpi = 'Pacific-I', order_by_mpi = 3","id >= 30 and id < 40");
    Ethnicity.update_all("ethnicity_mpi = 'Other', order_by_mpi = 5","id >= 40 and id < 50");
    Ethnicity.update_all("ethnicity_mpi = 'Other', order_by_mpi = 5","id >= 50");
    
    if ( Programme.exists?(53) )
      ProgrammeElement.populate(53, [ 
                   { :position => 0,  :column_name => 'refft_referral_from_type'},
                   { :position => 1,  :column_name => 'treat_treatment', :report_by => 'fee_schedules.description'},
                   { :position => 2,  :column_name => 'reas_reason'}
                   ]);
                   
    end

    if ( Programme.exists?(52) )
       ProgrammeElement.populate(52, [ 
                   { :position => 0,  :column_name => 'diab_type_of_diabetes', :report_by => 'fee_schedules.description' },
                   { :position => 1,  :column_name => 'ihd_heart_disease', :report_by => 'fee_schedules.description'},
                   { :position => 2,  :column_name => 'resp_respiratory_illnesses', :report_by => 'fee_schedules.description'},
                   
                   { :position => 4,  :column_name => 'refft_referral_from_type', :report_by => 'count(claims.id)'},
                   
                   { :position => 8,  :column_name => 'reftt_referral_to_type', :report_by => 'count(claims.id)'},
                   { :position => 9,  :column_name => 'nurref_nutritionist_referral', :report_by => 'count(claims.id)'},
                   { :position => 10,  :column_name => 'podref_podiatary_referral', :report_by => 'count(claims.id)'},
                   
                   { :position => 12,  :column_name => 'smref_smoking_action_referral', :report_by => 'count(claims.id)'},
                   { :position => 13,  :column_name => 'refto_referral_to_other', :report_by => 'count(claims.id)'},
                   
                   { :position => 16,  :column_name => 'vcpr_visit_care_plan_reviewed', :report_by => 'fee_schedules.description'},
                   
                   { :position => 20,  :column_name => 'mhex_mhealth_exit_reason', :report_by => 'count(claims.id)'}
                   
                   ]);
    end
    
    if ( Programme.exists?(51) )
       ProgrammeElement.populate(51, [ 
                   { :position => 0,  :column_name => 'conl_contact_location', :report_by => 'count(claims.id)'},
                   { :position => 1,  :column_name => 'km_kilometeres' },
                   
                   { :position => 4,  :column_name => 'immvt_immunisation_vacc_today', :report_by => 'count(claims.id)'}
                   
                   ]);
    end
    
    if ( Settings.database =~ /haupho|phocm/ )
      if ( Programme.exists?(14) )
       ProgrammeElement.populate(14, [ 
                   { :position => 0,  :column_name => 'cacxs_cervical_screening', :report_by => 'count(claims.id)'},
                   { :position => 1,  :column_name => 'cooth_contraception_other', :report_by => 'count(claims.id)'},
                   { :position => 2,  :column_name => 'shopgt_shealth_pregnancy_test', :report_by => 'count(claims.id)'},
                   
                   { :position => 4,  :column_name => 'stioth_sti_other', :report_by => 'count(claims.id)'},
                   { :position => 5,  :column_name => 'shotop_shealth_top_referral', :report_by => 'count(claims.id)'},
                   
                   { :position => 8,  :column_name => 'provt_provider_type', :report_by => 'count(claims.id)'},
                   
                   { :position => 12,  :column_name => 'cocon_contraception_condom'},
                   { :position => 13,  :column_name => 'codep_contraception_depo_provera'},
                   { :position => 14,  :column_name => 'coiucd_contraception_iucd'},
                   { :position => 15,  :column_name => 'coora_contraception_oral'}
                   ]); 
        DataField.update_all("label='Contraception'","column_name = 'cooth_contraception_other'")
        DataField.update_all("label='Pregnancy Test'","column_name = 'shopgt_shealth_pregnancy_test'")
        DataField.update_all("label='STI'","column_name = 'stioth_sti_other'")
        DataField.update_all("label='TOP Referral'","column_name = 'shotop_shealth_top_referral'")
        
      end
    end
    
    
  end

  def self.down
    remove_column :programme_elements , :report_by
    remove_column :programme_elements , :report_by_transpose
    
    remove_column :programme_elements , :report_by_2
    remove_column :programme_elements , :report_by_transpose_2
    
    remove_column :ethnicities , :ethnicity_level1
    remove_column :ethnicities , :order_by_level1
    
    remove_column :ethnicities , :ethnicity_mpi
    remove_column :ethnicities , :order_by_mpi
    
  end

end
