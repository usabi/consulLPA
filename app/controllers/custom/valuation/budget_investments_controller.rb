require_dependency Rails.root.join('app', 'controllers', 'valuation', 'budget_investments_controller').to_s
class Valuation::BudgetInvestmentsController
    def valid_price_params?
      if /[^\d.]/.match params[:budget_investment][:price]
        @investment.errors.add(:price, I18n.t('budgets.investments.wrong_price_format'))
      end

      if /[^\d.]/.match params[:budget_investment][:price_first_year]
        @investment.errors.add(:price_first_year, I18n.t('budgets.investments.wrong_price_format'))
      end

      @investment.errors.empty?
    end
end
