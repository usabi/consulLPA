require_dependency Rails.root.join('app', 'models', 'budget').to_s
class Budget
  def formatted_amount(amount)
    ActionController::Base.helpers.number_to_currency(amount,
                                                      precision: 2,
                                                      locale: I18n.default_locale,
                                                      unit: currency_symbol)
  end
end
