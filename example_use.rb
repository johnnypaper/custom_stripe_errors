ass Admin::Stripe::Subscriptions::PlansController < ApplicationController

  include CustomStripeErrors

  def index
    @stripe_plans = Stripe::Plan.list(limit: 100)
  end

  def show
    @stripe_plan = Stripe::Plan.retrieve(params[:plan_id])
  end

  def create

    # THIS IS THE WAY TO HANDLE STRIPE ERRORS APPROPRIATELY AS WELL AS StandardErrors
    
    begin
    Stripe::Plan.create(
        :amount => params[:plan][:amount],
        :interval => params[:plan][:interval],
        :name => params[:plan][:name],
        :currency => "usd",
        :id => params[:plan][:plan_id],
        :statement_descriptor => params[:plan][:statement_descriptor],
        :trial_period_days => params[:plan][:trial_period_days]
    )

    rescue => e
      puts e.class
      stripe_error_check(e)
    end

    redirect_to(action: "index", :notice=> "Plan successfully created")

  end

  def update
    p = Stripe::Plan.retrieve(params[:plan_id])
    p.name = params[:plan_name]
    p.statement_descriptor = params[:plan_statement_descriptor]
    p.trial_period_days = params[:plan_trial_period_days]
    p.save
  end

  def destroy
    plan = Stripe::Plan.retrieve(params[:plan_id])
    plan.delete
  end
end

