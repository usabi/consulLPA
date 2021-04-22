require_dependency Rails.root.join('app', 'controllers', 'management', 'budgets', 'investments_controller').to_s
class Management::Budgets::InvestmentsController

  private

    def investment_params
      attributes = [:external_url, :heading_id, :tag_list, :organization_name, :location, :skip_map, :author_phone,
                    image_attributes: image_attributes,
                    documents_attributes: document_attributes,
                    map_location_attributes: map_location_attributes]
      params.require(:budget_investment).permit(attributes, translation_params(Budget::Investment))
    end

    def document_attributes
      [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy]
    end

    def image_attributes
      [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy]
    end

    def map_location_attributes
      [:latitude, :longitude, :zoom]
    end
end
