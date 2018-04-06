require_dependency Rails.root.join('app', 'models', 'user').to_s
class User
  def minimum_votation_required_age?
    return false unless date_of_birth.present?
    Time.current - date_of_birth > 18.years
  end
end
