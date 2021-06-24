class CheckoutController < ApplicationController
  def create
    skip_authorization
    @plan = Plan.find(params[:id])
    @price = @plan.price_cents / @plan.quantity
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: 'Valor total:',
        amount: @price,
        quantity: @plan.quantity,
        currency: 'brl'
      }],
      success_url: checkout_success_url,
      cancel_url: plan_url(@plan)
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
