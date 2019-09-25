require_dependency Rails.root.join('app', 'models', 'budget').to_s
class Budget
  def formatted_amount(amount)
    ActionController::Base.helpers.number_to_currency(amount,
                                                      precision: 2,
                                                      locale: I18n.default_locale,
                                                      unit: currency_symbol)
  end

  def investments_orders
    case phase
    when 'accepting', 'reviewing'
      %w{random}
    when 'publishing_prices', 'balloting', 'reviewing_ballots'
      %w{price}
    when 'finished'
      %w{random}
    else
      %w{random confidence_score}
    end
  end

  private

  def sanitize_descriptions
    s = WYSIWYGSanitizer.new
    WYSIWYGSanitizer::ALLOWED_TAGS += ['a', 'img']
    WYSIWYGSanitizer::ALLOWED_ATTRIBUTES += ['href', 'target']

    Budget::Phase::PHASE_KINDS.each do |phase|
      sanitized = s.sanitize(send("description_#{phase}"))
      send("description_#{phase}=", sanitized)
    end
  end

end
