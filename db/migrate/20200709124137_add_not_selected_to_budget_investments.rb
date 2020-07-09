class AddNotSelectedToBudgetInvestments < ActiveRecord::Migration
  def change
    add_column :budget_investments, :not_selected_explanation, :text
    add_column :budget_investments, :not_selected_email_sent_at, :datetime
  end
end
