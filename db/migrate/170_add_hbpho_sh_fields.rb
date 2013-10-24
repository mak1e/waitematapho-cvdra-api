class AddHbphoShFields < ActiveRecord::Migration
  def self.up

  if ( Settings.database =~ /hbpho|phocm_hbpho/ )
  
      #change_table :claims_data do |t|
        # t.remove :description, :name # removes the description and name columns
        # t.string :part_number # creates a part_number string column 
        # t.index :part_number # and adds an index on it.
        #t.rename :contraceptionPrescribedMG, :contraceptionPrescribedGM  # renames a column.    
      #end    
    
    add_column :claims_data, :typeOfConsultation, :string, :limit => 48
    add_column :claims_data, :providerType, :string, :limit => 48
    add_column :claims_data, :methodOfConsultation, :string, :limit => 48
    
    add_column :claims_data, :reasonForConsultationA, :string, :limit => 48 # Asymptomatic STI
    add_column :claims_data, :reasonForConsultationS, :string, :limit => 48 # Symptomatic STI
    add_column :claims_data, :reasonForConsultationC, :string, :limit => 48 # Contraception
    add_column :claims_data, :reasonForConsultationO, :string, :limit => 48 # Other

    add_column :claims_data, :referral, :string, :limit => 48
    add_column :claims_data, :confirmClaim, :boolean

    add_column :claims_data, :testPositive, :string, :limit => 48
    add_column :claims_data, :contactTracingCompleted, :string, :limit => 48
    add_column :claims_data, :partnerManagementDiscussed, :string, :limit => 48
    add_column :claims_data, :patientCompliantWithTreatment, :string, :limit => 48
    add_column :claims_data, :didPatientAdvisePartner, :string, :limit => 48

    add_column :claims_data, :contraceptionPrescribedC, :string, :limit => 30 
    add_column :claims_data, :contraceptionPrescribedE, :string, :limit => 30
    add_column :claims_data, :contraceptionPrescribedO, :string, :limit => 30
    add_column :claims_data, :contraceptionPrescribedI, :string, :limit => 30
    add_column :claims_data, :contraceptionPrescribedJ, :string, :limit => 30
    add_column :claims_data, :contraceptionPrescribedR, :string, :limit => 30
    add_column :claims_data, :contraceptionPrescribedD, :string, :limit => 30
    add_column :claims_data, :contraceptionPrescribedM, :string, :limit => 30

    add_column :claims_data, :previousSTI, :string, :limit => 48

    add_column :claims_data, :diagnosticTestingB, :string, :limit => 30 # Blood
    add_column :claims_data, :diagnosticTestingS, :string, :limit => 30 # Self Swabs
    add_column :claims_data, :diagnosticTestingG, :string, :limit => 30 # Genital Exam
    add_column :claims_data, :diagnosticTestingD, :string, :limit => 30 # Declined
    add_column :claims_data, :diagnosticTestingN, :string, :limit => 30 # Not Required
    
    add_column :claims_data, :site_diag01, :string, :limit => 48 # Chlamydial Infection
    add_column :claims_data, :site_diag02, :string, :limit => 48 # Epididyo-orchitis
    add_column :claims_data, :site_diag03, :string, :limit => 48 # Gonorhea
    add_column :claims_data, :site_diag04, :string, :limit => 48 # Herpes simplex
    add_column :claims_data, :site_diag05, :string, :limit => 48 # Nonspecific urethritis
    add_column :claims_data, :site_diag06, :string, :limit => 48 # Genital Warts
    add_column :claims_data, :site_diag07, :string, :limit => 48 # Trichomoniasis - trichomonas
    add_column :claims_data, :site_diag08, :string, :limit => 48 # Female pelvic inflamm diseases
    add_column :claims_data, :site_diag09, :string, :limit => 48 # Genitourinary disease NOS

    add_column :claims_data, :occur_diag01, :string, :limit => 48
    add_column :claims_data, :occur_diag02, :string, :limit => 48
    add_column :claims_data, :occur_diag03, :string, :limit => 48
    add_column :claims_data, :occur_diag04, :string, :limit => 48
    add_column :claims_data, :occur_diag05, :string, :limit => 48
    add_column :claims_data, :occur_diag06, :string, :limit => 48
    add_column :claims_data, :occur_diag07, :string, :limit => 48
    add_column :claims_data, :occur_diag08, :string, :limit => 48
    add_column :claims_data, :occur_diag09, :string, :limit => 48

    add_column :claims_data, :cbProv_diag01Y, :boolean
    add_column :claims_data, :cbProv_diag02Y, :boolean
    add_column :claims_data, :cbProv_diag03Y, :boolean
    add_column :claims_data, :cbProv_diag04Y, :boolean
    add_column :claims_data, :cbProv_diag05Y, :boolean
    add_column :claims_data, :cbProv_diag06Y, :boolean
    add_column :claims_data, :cbProv_diag07Y, :boolean
    add_column :claims_data, :cbProv_diag08Y, :boolean
    add_column :claims_data, :cbProv_diag09Y, :boolean

    add_column :claims_data, :cbConf_diag01Y, :boolean
    add_column :claims_data, :cbConf_diag02Y, :boolean
    add_column :claims_data, :cbConf_diag03Y, :boolean
    add_column :claims_data, :cbConf_diag04Y, :boolean
    add_column :claims_data, :cbConf_diag05Y, :boolean
    add_column :claims_data, :cbConf_diag06Y, :boolean
    add_column :claims_data, :cbConf_diag07Y, :boolean
    add_column :claims_data, :cbConf_diag08Y, :boolean
    add_column :claims_data, :cbConf_diag09Y, :boolean
    
     
    ClaimsData.reset_column_information
    DataField.populate_table

    choices = [
      ['typeOfConsultation', 
         "Initial\r\nFollow Up"],
      ['providerType', 
         "GP\r\nNurse"],
      ['methodOfConsultation', 
         "Face to Face\r\nPhone"],

      ['previousSTI', 
         "Yes\r\nNo\r\nUnknown"],
      ['testPositive', 
        "Yes\r\nNo\r\nReffered\r\nn/a"],
      ['contactTracingCompleted', 
        "Yes\r\nNo\r\nReffered\r\nn/a"],
      ['partnerManagementDiscussed', 
        "Yes\r\nNo\r\nReffered\r\nn/a"],
      ['patientCompliantWithTreatment', 
        "Yes\r\nNo\r\nReffered\r\nn/a"],
      ['didPatientAdvisePartner', 
        "Yes\r\nNo\r\nReffered\r\nn/a"],
      ['referral', 
         "Managed in Primary Care\r\nRef to Secondary\r\nAdmitted to hospital"],

      ['site_diag01', 
         "Urogenital\r\nAnorectal\r\nPharyngeal\r\nEye\r\nOther"],
      ['site_diag02', 
         "Urogenital\r\nAnorectal\r\nPharyngeal\r\nEye\r\nOther"],
      ['site_diag03', 
         "Urogenital\r\nAnorectal\r\nPharyngeal\r\nEye\r\nOther"],
      ['site_diag04', 
         "Urogenital\r\nAnorectal\r\nPharyngeal\r\nEye\r\nOther"],
      ['site_diag05', 
         "Urogenital\r\nAnorectal\r\nPharyngeal\r\nEye\r\nOther"],
      ['site_diag06', 
         "Urogenital\r\nAnorectal\r\nPharyngeal\r\nEye\r\nOther"],
      ['site_diag07', 
         "Urogenital\r\nAnorectal\r\nPharyngeal\r\nEye\r\nOther"],
      ['site_diag08', 
         "Urogenital\r\nAnorectal\r\nPharyngeal\r\nEye\r\nOther"],
      ['site_diag09', 
         "Urogenital\r\nAnorectal\r\nPharyngeal\r\nEye\r\nOther"],

      ['occur_diag01', 
         "Initial\r\nRecurrent"],
      ['occur_diag02', 
         "Initial\r\nRecurrent"],
      ['occur_diag03', 
         "Initial\r\nRecurrent"],
      ['occur_diag04', 
         "Initial\r\nRecurrent"],
      ['occur_diag05', 
         "Initial\r\nRecurrent"],
      ['occur_diag06', 
         "Initial\r\nRecurrent"],
      ['occur_diag07', 
         "Initial\r\nRecurrent"],
      ['occur_diag08', 
         "Initial\r\nRecurrent"],
      ['occur_diag09', 
         "Initial\r\nRecurrent"]]
         
    choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
    end

      #puts "HBPHO - Sexual Health"
      
      #Programme.create_with_id 34, :code => 'SH', :description => 'Sexual Health'
      
      #FeeSchedule.create_with_id 3400, :programme_id => 34, :code => 'SHCCON', :description => 'SH CLaim Consultation', :fee => null, :gl_account_no => '6391-84',:is_the_default => true,
       #   :is_a_entry_service => 1, :is_a_exit_service => 0, :is_a_practice_service => 1,
       #   :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(34, [
          { :position => 0,  :column_name => 'typeOfConsultation'},
          { :position => 1,  :column_name => 'providerType'},
          { :position => 2,  :column_name => 'methodOfConsultation'},

          { :position => 4,  :column_name => 'reasonForConsultationS'}, 
          { :position => 5,  :column_name => 'reasonForConsultationS'}, 
          { :position => 6,  :column_name => 'reasonForConsultationC'}, 
          { :position => 7,  :column_name => 'reasonForConsultationO'}, 

          { :position => 8,  :column_name => 'referral'}, 
          { :position => 9,  :column_name => 'confirmClaimS'}, 
         # { :position => 10,  :column_name => ''}, 
        # { :position => 11,  :column_name => ''}, 
           
         { :position => 12,  :column_name => 'testPositive'}, 
         { :position => 13,  :column_name => 'contactTracingCompleted'}, 
         { :position => 14,  :column_name => 'partnerManagementDiscussed'}, 
         { :position => 15,  :column_name => 'patientCompliantWithTreatment'}, 
           
         { :position => 16,  :column_name => 'didPatientAdvisePartner'}, 
        # { :position => 17,  :column_name => ''}, 
         { :position => 18,  :column_name => 'previousSTI'}, 
        # { :position => 19,  :column_name => ''}, 
           
         { :position => 20,  :column_name => 'contraceptionPrescribedC'}, # Condoms 
         { :position => 21,  :column_name => 'contraceptionPrescribedE'}, # ECP
         { :position => 22,  :column_name => 'contraceptionPrescribedO'}, # Oral
         { :position => 23,  :column_name => 'contraceptionPrescribedI'}, # IUCD
            
         { :position => 24,  :column_name => 'contraceptionPrescribedJ'}, # Jadelle Insert
         { :position => 25,  :column_name => 'contraceptionPrescribedR'}, # Jadelle Removed
         { :position => 26,  :column_name => 'contraceptionPrescribedD'}, # Depo Provera
         { :position => 27,  :column_name => 'contraceptionPrescribedM'} # Mirena
            
        ]);

  end        

  end

  def self.down
    
    remove_column :claims_data, :typeOfConsultation
    remove_column :claims_data, :providerType
    remove_column :claims_data, :methodOfConsultation

    remove_column :claims_data, :reasonForConsultationA
    remove_column :claims_data, :reasonForConsultationS
    remove_column :claims_data, :reasonForConsultationC
    remove_column :claims_data, :reasonForConsultationO

    remove_column :claims_data, :referral
    remove_column :claims_data, :confirmClaim

    remove_column :claims_data, :contraceptionPrescribedC
    remove_column :claims_data, :contraceptionPrescribedE
    remove_column :claims_data, :contraceptionPrescribedO
    remove_column :claims_data, :contraceptionPrescribedI
    remove_column :claims_data, :contraceptionPrescribedJ
    remove_column :claims_data, :contraceptionPrescribedR
    remove_column :claims_data, :contraceptionPrescribedD
    remove_column :claims_data, :contraceptionPrescribedM

    remove_column :claims_data, :previousSTI

    remove_column :claims_data, :diagnosticTestingB
    remove_column :claims_data, :diagnosticTestingS
    remove_column :claims_data, :diagnosticTestingG
    remove_column :claims_data, :diagnosticTestingD
    remove_column :claims_data, :diagnosticTestingN

    remove_column :claims_data, :testPositive
    remove_column :claims_data, :contactTracingCompleted
    remove_column :claims_data, :partnerManagementDiscussed
    remove_column :claims_data, :patientCompliantWithTreatment
    remove_column :claims_data, :didPatientAdvisePartner
    
    remove_column :claims_data, :site_diag01
    remove_column :claims_data, :site_diag02
    remove_column :claims_data, :site_diag03
    remove_column :claims_data, :site_diag04
    remove_column :claims_data, :site_diag05
    remove_column :claims_data, :site_diag06
    remove_column :claims_data, :site_diag07
    remove_column :claims_data, :site_diag08
    remove_column :claims_data, :site_diag09

    remove_column :claims_data, :occur_diag01
    remove_column :claims_data, :occur_diag02
    remove_column :claims_data, :occur_diag03
    remove_column :claims_data, :occur_diag04
    remove_column :claims_data, :occur_diag05
    remove_column :claims_data, :occur_diag06
    remove_column :claims_data, :occur_diag07
    remove_column :claims_data, :occur_diag08
    remove_column :claims_data, :occur_diag09

    remove_column :claims_data, :cbProv_diag01Y
    remove_column :claims_data, :cbProv_diag02Y
    remove_column :claims_data, :cbProv_diag03Y
    remove_column :claims_data, :cbProv_diag04Y
    remove_column :claims_data, :cbProv_diag05Y
    remove_column :claims_data, :cbProv_diag06Y
    remove_column :claims_data, :cbProv_diag07Y
    remove_column :claims_data, :cbProv_diag08Y
    remove_column :claims_data, :cbProv_diag09Y

    remove_column :claims_data, :cbConf_diag01Y
    remove_column :claims_data, :cbConf_diag02Y
    remove_column :claims_data, :cbConf_diag03Y
    remove_column :claims_data, :cbConf_diag04Y
    remove_column :claims_data, :cbConf_diag05Y
    remove_column :claims_data, :cbConf_diag06Y
    remove_column :claims_data, :cbConf_diag07Y
    remove_column :claims_data, :cbConf_diag08Y
    remove_column :claims_data, :cbConf_diag09Y

#    Programme.delete_all( 'id = 34' )
#    FeeSchedule.delete_all( 'programme_id = 34' )

  end
end