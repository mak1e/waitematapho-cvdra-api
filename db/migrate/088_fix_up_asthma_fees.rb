class FixUpAsthmaFees < ActiveRecord::Migration
  def self.up
    if ( Programme.exists?(4) ) 
      f=FeeSchedule.find(40)
      f.code = 'ASF'
      f.fee = 45.00
      f.save!
      FeeSchedule.create_with_id 41, :programme_id => 4, :code => 'ACP', :description => 'Care Plus', :fee => 50.00, :gl_account_no => '6-9999', :is_the_default => false      
    end
  end

  def self.down
  end
end
