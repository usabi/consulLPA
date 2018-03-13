class ChangeBudgetInvestmentPriceToDecimal < ActiveRecord::Migration
  def change
    change_column :budget_investments, :price, :decimal, precision: 16, scale: 2, default: 0.0
    change_column :budget_investments, :price_first_year, :decimal, precision: 16, scale: 2, default: 0.0
  end
end
