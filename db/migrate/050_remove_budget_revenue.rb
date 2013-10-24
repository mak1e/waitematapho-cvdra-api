class RemoveBudgetRevenue < ActiveRecord::Migration
  def self.up
     remove_column 'programmes', 'drs_revence_episode' # not used 
  end

  def self.down
  end
end
