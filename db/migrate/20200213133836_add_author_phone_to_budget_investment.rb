class AddAuthorPhoneToBudgetInvestment < ActiveRecord::Migration
  def change
    add_column :budget_investments, :author_phone, :string
  end
end
