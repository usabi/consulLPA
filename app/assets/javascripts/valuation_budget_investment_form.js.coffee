App.ValuationBudgetInvestmentForm =

  showFeasibleFields: ->
    $('#valuation_budget_investment_edit_form #feasible_fields textarea').removeAttr('disabled')
    $('#valuation_budget_investment_edit_form #feasible_fields').show('down')

  showNotFeasibleFields: ->
    $('#valuation_budget_investment_edit_form #unfeasible_fields textarea').removeAttr('disabled')
    $('#valuation_budget_investment_edit_form #unfeasible_fields').show('down')

  showNotSelectedFields: ->
    $('#valuation_budget_investment_edit_form #not_selected_fields textarea').removeAttr('disabled')
    $('#valuation_budget_investment_edit_form #not_selected_fields').show('down')

  hideNotActiveFields: ->
    $('#valuation_budget_investment_edit_form #feasible_fields').hide('down')
    $('#valuation_budget_investment_edit_form #unfeasible_fields').hide('down')
    $('#valuation_budget_investment_edit_form #not_selected_fields').hide('down')

    $('#valuation_budget_investment_edit_form #feasible_fields textarea').attr('disabled', true)
    $('#valuation_budget_investment_edit_form #unfeasible_fields textarea').attr('disabled', true)
    $('#valuation_budget_investment_edit_form #not_selected_fields textarea').attr('disabled', true)

  showAllFields: ->
    $('#valuation_budget_investment_edit_form #feasible_fields').show('down')
    $('#valuation_budget_investment_edit_form #unfeasible_fields').show('down')
    $('#valuation_budget_investment_edit_form #not_selected_fields').show('down')


  showFeasibilityFields: ->
    App.ValuationBudgetInvestmentForm.hideNotActiveFields()
    feasibility = $("#valuation_budget_investment_edit_form input[type=radio][name='budget_investment[feasibility]']:checked").val()
    if feasibility == 'feasible'
      App.ValuationBudgetInvestmentForm.showFeasibleFields()
    else if feasibility == 'unfeasible'
      App.ValuationBudgetInvestmentForm.showNotFeasibleFields()
    else if feasibility == 'nextyearbudget'
      return false
    else if feasibility == 'takecharge'
      return false
    else if feasibility == 'notselected'
      App.ValuationBudgetInvestmentForm.showNotSelectedFields()
    else
      App.ValuationBudgetInvestmentForm.showAllFields()


  showFeasibilityFieldsOnChange: ->
    $("#valuation_budget_investment_edit_form input[type=radio][name='budget_investment[feasibility]']").change ->
      App.ValuationBudgetInvestmentForm.showFeasibilityFields()


  initialize: ->
    App.ValuationBudgetInvestmentForm.showFeasibilityFields()
    App.ValuationBudgetInvestmentForm.showFeasibilityFieldsOnChange()
    false
