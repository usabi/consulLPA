require_dependency Rails.root.join('app', 'controllers', 'management', 'document_verifications_controller').to_s
class Management::DocumentVerificationsController


  private

    def document_verification_params
      params.require(:document_verification).permit(:document_type, :document_number, :date_of_birth)
    end

end
