require_dependency Rails.root.join('app', 'controllers', 'budgets', 'investments_controller').to_s

class Budgets::InvestmentsController
  before_action :load_categories, only: [:index, :new, :create, :edit, :update]
  valid_filters = %w[not_unfeasible feasible unfeasible unselected selected winners takecharged included_next_year_budget not_selected]

  has_filters valid_filters, only: [:index, :show, :suggest]

  def edit
  end

  def update
    if @investment.update(investment_params)
      redirect_to budget_investment_path(@budget, @investment),
                  notice: t('flash.actions.update.budget_investment')
    else
      render :edit
    end
  end

  private

    def investment_params
      params.require(:budget_investment)
        .permit(:title, :description, :heading_id, :tag_list, :author_phone,
                :organization_name, :location, :terms_of_service, :skip_map,
                image_attributes: image_attributes,
                documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy],
                map_location_attributes: [:latitude, :longitude, :zoom])
    end
end

