require_dependency Rails.root.join('app', 'models', 'user').to_s
class User
  def minimum_votation_required_age?
    return false unless date_of_birth.present?
    Time.current - date_of_birth > 16.years
  end
  def after_database_authentication
    if self.residence_verified_at && self.residence_verified_at < Time.now-12.month
      date_of_birth_fmt = date_of_birth.strftime('%d/%m/%Y')
      r = CensusApi.new.call(document_type, document_number, date_of_birth_fmt)
      if r.valid?
        self.update_attribute(:residence_verified_at, Time.current)
      else
        self.update_attribute(:residence_verified_at, nil)
        self.update_attribute(:verified_at, nil)
      end
    end
  end
end
