require_dependency Rails.root.join('app', 'models', 'budget', 'investment').to_s
class Budget::Investment
  def enough_money?(ballot)
    available_money = ballot.amount_available(heading)
    price <= available_money
  end
end
