class CheckoutController < ApplicationController
  def create
    skip_authorization
    @plan = Plan.find(params[:id])
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: 'Seu plano <%= current_user.plans.count %>',
        amount: @plan.price_cents,
        quantity: @plan.quantity,
        currency: 'brl'
      }],
      success_url: checkout_success_url,
      cancel_url: new_plan_url
    )

    respond_to do |format|
      format.js
    end
  end

  def success
    skip_authorization
  end

  def cancel
    skip_authorization
  end

end
