require_dependency Rails.root.join("app", "controllers", "admin", "system_emails_controller").to_s

class Admin::SystemEmailsController
  def index
    @system_emails = {
      proposal_notification_digest:   %w[view preview_pending],
      budget_investment_created:      %w[view edit_info],
      budget_investment_selected:     %w[view edit_info],
      budget_investment_unfeasible:   %w[view edit_info],
      budget_investment_not_selected: %w[view edit_info],
      budget_investment_takecharge: %w[view edit_info],
      budget_investment_next_year_budget: %w[view edit_info],
      budget_investment_unselected:   %w[view edit_info],
      comment:                        %w[view edit_info],
      reply:                          %w[view edit_info],
      direct_message_for_receiver:    %w[view edit_info],
      direct_message_for_sender:      %w[view edit_info],
      email_verification:             %w[view edit_info],
      user_invite:                    %w[view edit_info],
      evaluation_comment:             %w[view edit_info]
    }
  end
end
