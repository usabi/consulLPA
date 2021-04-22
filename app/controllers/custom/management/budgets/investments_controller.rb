require_dependency Rails.root.join('app', 'controllers', 'management', 'budgets', 'investments_controller').to_s
class Management::Budgets::InvestmentsController

  private

    def investment_params
      attributes = [:external_url, :heading_id, :tag_list, :organization_name, :location, :skip_map, :author_phone]
      params.require(:budget_investment).permit(attributes, translation_params(Budget::Investment))
    end
end
