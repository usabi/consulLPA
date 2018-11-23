App.ValuationBudgetInvestmentForm =

  showFeasibleFields: ->
    $('#valuation_budget_investment_edit_form #unfeasible_fields').hide('down')
    $('#valuation_budget_investment_edit_form #takecharge_fields').hide('down')
    $('#valuation_budget_investment_edit_form #feasible_fields').show()

  showNotFeasibleFields: ->
    $('#valuation_budget_investment_edit_form #feasible_fields').hide('down')
    $('#valuation_budget_investment_edit_form #takecharge_fields').hide('down')
    $('#valuation_budget_investment_edit_form #unfeasible_fields textarea').removeAttr('disabled')
    $('#valuation_budget_investment_edit_form #unfeasible_fields').show()
    $('#valuation_budget_investment_edit_form #takecharge_fields textarea').attr('disabled', true)

  showTakeChargeFields: ->
    $('#valuation_budget_investment_edit_form #feasible_fields').hide('down')
    $('#valuation_budget_investment_edit_form #unfeasible_fields').hide('down')
    $('#valuation_budget_investment_edit_form #takecharge_fields textarea').removeAttr('disabled')
    $('#valuation_budget_investment_edit_form #takecharge_fields').show()
    $('#valuation_budget_investment_edit_form #unfeasible_fields textarea').attr('disabled', true)

  showAllFields: ->
    $('#valuation_budget_investment_edit_form #feasible_fields').show('down')
    $('#valuation_budget_investment_edit_form #unfeasible_fields').show('down')
    $('#valuation_budget_investment_edit_form #takecharge_fields').show('down')


  showFeasibilityFields: ->
    feasibility = $("#valuation_budget_investment_edit_form input[type=radio][name='budget_investment[feasibility]']:checked").val()
    if feasibility == 'feasible'
      App.ValuationBudgetInvestmentForm.showFeasibleFields()
    else if feasibility == 'unfeasible'
      App.ValuationBudgetInvestmentForm.showNotFeasibleFields()
    else if feasibility == 'takecharge'
      App.ValuationBudgetInvestmentForm.showTakeChargeFields()


  showFeasibilityFieldsOnChange: ->
    $("#valuation_budget_investment_edit_form input[type=radio][name='budget_investment[feasibility]']").change ->
      App.ValuationBudgetInvestmentForm.showAllFields()
      App.ValuationBudgetInvestmentForm.showFeasibilityFields()


  initialize: ->
    App.ValuationBudgetInvestmentForm.showFeasibilityFields()
    App.ValuationBudgetInvestmentForm.showFeasibilityFieldsOnChange()
    false
