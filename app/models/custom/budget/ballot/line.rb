require_dependency Rails.root.join('app', 'models', 'budget', 'ballot', 'line').to_s
class Budget::Ballot::Line
  def check_sufficient_funds
    errors.add(:money, "insufficient funds") if ballot.amount_available(investment.heading) < investment.price
  end
end
