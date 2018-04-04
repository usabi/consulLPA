require_dependency Rails.root.join('app', 'controllers', 'budgets', 'ballot', 'lines_controller').to_s
class Budgets::Ballot::LinesController
  before_action :check_minimum_voting_age

  private

  def check_minimum_voting_age
    return head(:forbidden) unless current_user.minimum_votation_required_age?
  end
end
