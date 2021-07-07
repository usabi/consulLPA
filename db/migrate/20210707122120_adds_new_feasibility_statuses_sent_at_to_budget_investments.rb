class AddsNewFeasibilityStatusesSentAtToBudgetInvestments < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_investments, :takecharge_email_sent_at, :datetime
    add_column :budget_investments, :next_year_budget_email_sent_at, :datetime
  end
end
