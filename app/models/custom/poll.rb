require_dependency Rails.root.join('app', 'models', 'poll').to_s

class Poll
  attr_accessor :starts_at_hour
  attr_accessor :ends_at_hour

  before_save :set_hours
  validate :check_hours

  scope :current,  -> { where('starts_at <= ? and ? <= ends_at', Time.current, Time.current) }
  scope :incoming, -> { where('? < starts_at', Time.current) }
  scope :expired,  -> { where('ends_at < ?', Time.current) }
  scope :recounting, -> { Poll.where(ends_at: (Time.current - RECOUNT_DURATION)..Time.current) }

  def current?(timestamp = Time.current)
    starts_at <= timestamp && timestamp <= ends_at
  end

  def incoming?(timestamp = Time.current)
    timestamp < starts_at
  end

  def expired?(timestamp = Time.current)
    ends_at < timestamp
  end

  private

  def check_hours
    errors.add(:starts_at_hour, I18n.t('polls.wrong_hour_format')) if starts_at_hour.present? && starts_at_hour !~ /\d?\d:\d\d/
    errors.add(:ends_at_hour, I18n.t('polls.wrong_hour_format')) if ends_at_hour.present? && ends_at_hour !~ /\d?\d:\d\d/
  end

  def set_hours
    if starts_at_hour.present?
      starts_hour, starts_min = starts_at_hour.split(':')
      self.starts_at = starts_at.change(hour: starts_hour, min: starts_min)
    end

    if ends_at_hour.present?
      ends_hour, ends_min = ends_at_hour.split(':')
      self.ends_at = ends_at.change(hour: ends_hour, min: ends_min)
    end
  end
end
