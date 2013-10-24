class AddMhealthProgramme < ActiveRecord::Migration
  def self.up
    FeeSchedule.reset_column_information
    
    Programme.create_with_id 8, :code => 'PMHO', :description => 'Lifestyle Options (MH)'
    
    FeeSchedule.create_with_id 800, :programme_id => 8, :code => 'PMHIGP', :description => 'Initial GP', :fee => 120.00, :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 801, :programme_id => 8, :code => 'PMHFGP', :description => 'Follow-up GP', :fee => 60.00, :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 802, :programme_id => 8, :code => 'PMHEGP', :description => 'Final Consultation/Exit', :fee => 60.00, :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 803, :programme_id => 8, :code => 'PMHNIN', :description => 'Nurse Intervention', :fee => 25.00,  :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 804, :programme_id => 8, :code => 'PMHPHY', :description => 'Phychologist', :fee => 101.25,  :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 805, :programme_id => 8, :code => 'PMHCOU', :description => 'Counsellor', :fee => 101.25,  :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 806, :programme_id => 8, :code => 'PMHTRA', :description => 'Transport', :fee => 0.00,  :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 807, :programme_id => 8, :code => 'PMHCTS', :description => 'Community Service', :fee => 0.00,  :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 808, :programme_id => 8, :code => 'PMHMHS', :description => 'Mental Health Service', :fee => 0.00,  :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 809, :programme_id => 8, :code => 'PMHDNA', :description => 'DNA Session', :fee => 101.25,  :gl_account_no => '6-0000'
#   FeeSchedule.create_with_id 810, :programme_id => 8, :code => 'PMHDNC', :description => 'Did not Complete', :fee => 0,  :gl_account_no => '6-0000'
    
    FeeSchedule.update_all('is_a_entry_service = 1');
    FeeSchedule.update_all('is_a_exit_service = 1');
    FeeSchedule.update_all('is_a_practice_service = 1');
    
    FeeSchedule.update_all('is_a_practice_service = 0', 'id in ( 50,51,54,56,55,804,805,806,807,808,809 )')
    
    FeeSchedule.update_all('is_a_entry_service = 0, is_a_exit_service = 0', 'programme_id = 8')
    FeeSchedule.update_all('is_a_entry_service = 1, is_a_exit_service = 0', 'id in ( 800 )')
    FeeSchedule.update_all('is_a_entry_service = 0, is_a_exit_service = 1', 'id in ( 802,810 )')
    # B4school declined is not to be counted as a service
    FeeSchedule.update_all('is_a_entry_service = 0, is_a_exit_service = 0', 'id in ( 69 )')
    
    data = [ { :programme_id => 8, 
                :elements => [ 
                  { :position => 0, :column_name => 'mhdx_mhealth_diagnosis'},
                  { :position => 1, :column_name => 'mhdx2_mhealth_diagnosis_2'},
                  { :position => 2, :column_name => 'mhdx3_mhealth_diagnosis_3'},
                  { :position => 4, :column_name => 'como_co_morbidities'},
                  { :position => 8, :column_name => 'qolr_quality_of_life_rating'},
                  { :position => 9, :column_name => 'copa_co_payment_amount'}
                ]}
           ]
    

    data.each do |programme|
      ProgrammeElement.delete_all( { :programme_id => programme[:programme_id] })
      programme[:elements].each do |elem|
        e=ProgrammeElement.new(elem)
        e.programme_id = programme[:programme_id]
        e.save!
      end
    end    
    
    DataField.populate_table
    
  end

 
  def self.down
    FeeSchedule.delete_all('programme_id = 8')
    Programme.delete_all('id = 8')
    ProgrammeElement.delete_all( 'programme_id = 8')        
  end
end
