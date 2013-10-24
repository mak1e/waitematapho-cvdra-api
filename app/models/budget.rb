# == Schema Information
#
# Table name: budgets
#
#  id              :integer       not null, primary key
#  programme_id    :integer       not null
#  organisation_id :integer       not null
#  budget          :integer       
#

class Budget < ActiveRecord::Base
  belongs_to :programme
  belongs_to :organisation
  
  validates_numericality_of :budget, :allow_nil => true , :only_integer => true
  
  # belongs_to :on_new_claim_status, :class_name => 'ClaimStatus'
  
  def caption
    "#{self.programme.description}::#{self.organisation.name}"
  end

  # prepopulate the budgets table, If any more programmes or organisations
  def self.prepopulate_budgets
      # Delete bad items, organisation deleted etc 
      Budget.connection.execute("delete from budgets where not exists (select 1 from organisations where organisations.id = budgets.organisation_id and organisations.deleted = 0 and organisations.pho_id is not null)")
      # Add for new ornanisations
      Budget.connection.execute(
          "insert into budgets (budgets.programme_id,organisation_id)\n"+
          "select programmes.id, organisations.id\n"+
          "from organisations\n"+
          "    left join programmes on 1=1\n"+
          "where organisations.deleted = 0 and organisations.pho_id is not null\n"+
          "and not exists ( select 1 from budgets \n"+
          "  where budgets.programme_id = programmes.id and budgets.organisation_id = organisations.id )\n" )
   end
   
   # Return active record, summarty of all budgets for organisation
   def self.summary_all_budgets_for_organisation(organisation_id)
     query = Query.find_by_sql(
      "select p.code, p.description,p.budget_start, p.budget_method, p.budget_wording,p.budget_details,\n"+
      "       p.commit_episode, b.budget,\n"+
      "       sum(f.is_a_entry_service) episode_count, count(c.id) claim_count, sum(c.amount) actual_amount\n"+
      "from budgets b\n"+
      "  join programmes p on p.id = b.programme_id and p.budget_internal_only = 0 and p.budget_start is not null\n"+
      "  left join claims c on c.cost_organisation_id = b.organisation_id and c.programme_id = b.programme_id\n"+
      "    and c.invoice_date >= p.budget_start and c.invoice_date < dateadd(yy,1,p.budget_start)  and c.claim_status_id <= 6\n"+
      "  left join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "where b.organisation_id = #{organisation_id} and b.budget > 0\n"+
      "group by p.code, p.description,p.budget_start, p.budget_method, p.budget_wording,p.budget_details,\n"+
      "       p.commit_episode, b.budget\n"+
      "order by p.description");
     query
   end
end
