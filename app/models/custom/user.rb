require_dependency Rails.root.join('app', 'models', 'user').to_s
class User
  def minimum_votation_required_age?
    Time.current - date_of_birth > 18.years
  end
end
