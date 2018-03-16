require_dependency Rails.root.join('app', 'models', 'verification', 'management', 'document').to_s

class Verification::Management::Document

  attr_accessor :date_of_birth


  def initialize(attrs = {})
    self.date_of_birth = parse_date('date_of_birth', attrs)
    attrs = remove_date('date_of_birth', attrs)
    super
  end

  def in_census?
    response = CensusCaller.new.call(document_type, document_number, date_of_birth)
    response.valid?
  end


  def valid_age?
    return if errors[:date_of_birth].any?

    unless allowed_age?
      errors.add(:date_of_birth, I18n.t('verification.residence.new.error_not_allowed_age'))
    end
  end


  private

    def retrieve_census_data
      @census_api_response = CensusCaller.new.call(document_type, document_number, date_of_birth)
    end

    def residency_valid?
      @census_api_response.valid?
    end

    def gender
      # @census_api_response.gender
      '-'
    end

    def district_code
      @census_api_response.district_code
    end

    def residency_errors
      @census_api_response.errors
    end


end
