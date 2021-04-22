require_dependency Rails.root.join('app', 'controllers', 'budgets', 'investments_controller').to_s

class Budgets::InvestmentsController
  before_action :load_categories, only: [:index, :new, :create, :edit, :update]
  valid_filters = %w[not_unfeasible feasible unfeasible unselected selected winners takecharged included_next_year_budget not_selected]

  has_filters valid_filters, only: [:index, :show, :suggest]

  private

    def investment_params
      attributes = [:heading_id, :tag_list,
                    :organization_name, :location, :terms_of_service, :skip_map,
                    :author_phone,
                    image_attributes: image_attributes,
                    documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy],
                    map_location_attributes: [:latitude, :longitude, :zoom]]
      params.require(:budget_investment).permit(attributes, translation_params(Budget::Investment))
    end
end

