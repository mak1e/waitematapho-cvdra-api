class AddProgrammeClaimLimit < ActiveRecord::Migration
  def self.up
    puts "Adding claim limits"
    
    # Max number of claims
    add_column :programmes, :claim_limit_count, :integer
    # In this period
    add_column :programmes, :claim_limit_period_mths, :integer # Always 11 months
    # Claim Status
    add_column :programmes, :claim_limit_claim_status_id, :integer
    # Claim Comment
    add_column :programmes, :claim_limit_claim_comment, :string, :limit => 18
    
    # Two claims on same day. Mark 2nd as 
    add_column :programmes, :same_day_claim_status_id, :integer
    # Claim Comment
    add_column :programmes, :same_day_claim_comment, :string, :limit => 18
    Programme.reset_column_information
    
    Programme.update_all( "same_day_claim_status_id = 2, same_day_claim_comment = 'Possible duplicate'")
    # CPlus Limit
    Programme.update_all( "claim_limit_claim_status_id = 2, claim_limit_claim_comment = 'Limit exceeded', claim_limit_count = 4, claim_limit_period_mths = 11", "id = 1")
    # Diab Limit
    Programme.update_all( "claim_limit_claim_status_id = 2, claim_limit_claim_comment = 'Limit exceeded', claim_limit_count = 1, claim_limit_period_mths = 9", "id = 3")
  end

  def self.down
    remove_column :programmes, :same_day_claim_comment
    remove_column :programmes, :same_day_claim_status_id
    remove_column :programmes, :claim_limit_claim_comment
    remove_column :programmes, :claim_limit_claim_status_id
    remove_column :programmes, :claim_limit_period_mths # Always 11 months
    remove_column :programmes, :claim_limit_count
  end
end
