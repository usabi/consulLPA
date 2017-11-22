require_dependency Rails.root.join('app', 'models', 'verification', 'residence').to_s

class Verification::Residence

  validate :allowed_age
  validate :postal_code_in_las_palmas_gc
  validate :residence_in_las_palmas_gc
  validates :date_of_birth, presence: true

  VALID_POSTAL_CODES = (35001..35019).to_a + [35220, 35229]

  def postal_code_in_las_palmas_gc
    errors.add(:postal_code, I18n.t('verification.residence.new.error_not_allowed_postal_code')) unless valid_postal_code?
  end

  def residence_in_las_palmas_gc
    return if errors.any?

    unless residency_valid?
      errors.add(residency_errors, false)
      store_failed_attempt
      Lock.increase_tries(user)
    end
  end

  def allowed_age
    return if errors[:date_of_birth].any?

    unless allowed_age?
      errors.add(:date_of_birth, I18n.t('verification.residence.new.error_not_allowed_age'))
    end
  end

  private

    def retrieve_census_data
      @census_data = CensusCaller.new.call(document_type, document_number, date_of_birth)
    end

    def valid_postal_code?
      postal_code.to_i.in?(VALID_POSTAL_CODES)
    end

    def residency_valid?
      @census_data.valid?
    end

    def gender
      # TODO: Decide if we get district from web service or form
      '-'
    end

    def district_code
      @census_data.district_code
    end

    def residency_errors
      @census_data.errors
    end

    def allowed_age?
      Age.in_years(date_of_birth) >= User.minimum_required_age
    end
end
