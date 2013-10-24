class CreateClaimStatuses < ActiveRecord::Migration
  def self.up
    create_table :claim_statuses do |t|
      t.string "description", :limit => 18, :null => false
      t.string "html", :limit => 48, :null => false
      
      t.timestamps
    end
    ClaimStatus.delete_all;
    # ClaimStatus.create_with_id 1,  :description => 'New', :html => 'New'
    ClaimStatus.create_with_id 2,  :description => 'Held', :html => '<span style="color:maroon">Held</span>'
    
    ClaimStatus.create_with_id 5,  :description => 'Accepted', :html => 'Accepted'
    ClaimStatus.create_with_id 6,  :description => 'Borderline', :html => 'Borderline'
    
    ClaimStatus.create_with_id 8,  :description => 'Deleted', :html => '<span style="color:maroon">Deleted</span>'
    ClaimStatus.create_with_id 9,  :description => 'Declined', :html => '<span style="color:maroon">Declined</span>'
    
  end

  def self.down
    drop_table :claim_statuses
  end
end
