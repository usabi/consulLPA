require_dependency Rails.root.join('app', 'controllers', 'admin', 'budget_investments_controller').to_s
class Admin::BudgetInvestmentsController
  def budget_investment_params
    params.require(:budget_investment)
          .permit(:title, :description, :external_url, :heading_id, :administrator_id,
                  :tag_list, :valuation_tag_list, :incompatible, :organization_name,
                  :selected, :location, :visible_to_valuators, :not_selected,
                  valuator_ids: [], valuator_group_ids: [])
  end
end
