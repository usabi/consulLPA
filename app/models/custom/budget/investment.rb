require_dependency Rails.root.join('app', 'models', 'budget', 'investment').to_s
class Budget::Investment
  validates :author_phone, presence: true, format: { with: /\A[\d \+]+\z/ }

  scope :takecharged, -> { where(feasibility: "takecharge") }
  scope :included_next_year_budget, -> { where(feasibility: "nextyearbudget") }
  scope :not_selected, -> { where(feasibility: "notselected") }

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

    def self.advanced_filters(params, results)
      ids = []
      ids += results.valuation_finished_feasible.pluck(:id) if params[:advanced_filters].include?('feasible')
      ids += results.where(selected: true).pluck(:id)       if params[:advanced_filters].include?('selected')
      ids += results.undecided.pluck(:id)                   if params[:advanced_filters].include?('undecided')
      ids += results.unfeasible.pluck(:id)                  if params[:advanced_filters].include?('unfeasible')
      ids += results.takecharged.pluck(:id)                 if params[:advanced_filters].include?('takecharged')
      ids += results.included_next_year_budget.pluck(:id)   if params[:advanced_filters].include?('included_next_year_budget')
      ids += results.not_selected.pluck(:id)   if params[:advanced_filters].include?('not_selected')
      results.where("budget_investments.id IN (?)", ids)
    end

    def not_selected_email_pending?
      not_selected_email_sent_at.blank? && not_selected? && valuation_finished?
    end

    def not_selected?
      feasibility == "notselected"
    end

    def send_not_selected_email
      Mailer.budget_investment_not_selected(self).deliver_later
      update(not_selected_email_sent_at: Time.current)
    end

    def takecharge_email_pending?
      takecharge_email_sent_at.blank? && takecharge? && valuation_finished?
    end

    def takecharge?
      feasibility == "takecharge"
    end

    def send_takecharge_email
      Mailer.budget_investment_takecharge(self).deliver_later
      update(takecharge_email_sent_at: Time.current)
    end

    def next_year_budget_email_pending?
      next_year_budget_email_sent_at.blank? && next_year_budget? && valuation_finished?
    end

    def next_year_budget?
      feasibility == "nextyearbudget"
    end

    def send_next_year_budget_email
      Mailer.budget_investment_next_year_budget(self).deliver_later
      update(next_year_budget_email_sent_at: Time.current)
    end
end
