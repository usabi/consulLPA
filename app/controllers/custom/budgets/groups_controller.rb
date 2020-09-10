require_dependency Rails.root.join('app', 'controllers', 'budgets', 'groups_controller').to_s

class Budgets::GroupsController
  has_filters %w[not_unfeasible feasible unfeasible unselected selected winners takecharged included_next_year_budget not_selected], only: [:show]

end
