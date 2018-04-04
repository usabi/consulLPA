require_dependency Rails.root.join('app', 'models', 'budget', 'investment').to_s
class Budget::Investment
  def enough_money?(ballot)
    available_money = ballot.amount_available(heading)
    price <= available_money
  end

  def reason_for_not_being_ballotable_by(user, ballot)
    return permission_problem(user)    if permission_problem?(user)
    return :not_minimum_voting_age     unless user.minimum_votation_required_age?
    return :not_selected               unless selected?
    return :no_ballots_allowed         unless budget.balloting?
    return :different_heading_assigned unless ballot.valid_heading?(heading)
    return :not_enough_money_html      if ballot.present? && !enough_money?(ballot)
  end
end
