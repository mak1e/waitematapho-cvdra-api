class RemHbphoShFields < ActiveRecord::Migration
  def self.up

#    remove_column :claims_data, :typeOfConsultation
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
        
  end


  def self.down
    
#    Programme.delete_all( 'id = 34' )
#    FeeSchedule.delete_all( 'programme_id = 34' )


  end
end