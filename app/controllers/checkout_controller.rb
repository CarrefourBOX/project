class CheckoutController < ApplicationController
  def create
    @quantity = params[:boxes].keys.size
    @category = params[:category]
    # Setting up a Stripe Session for payment
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        quantity: @quantity,
        amount: @price_cents,
        category: @category,
        currency: 'brl',
      }],
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url
    )

    respond_to do |format|
      format.js
    end
  end

  def success; end

  def cancel; end

  private

  def calculate_price
    total_price = (CATEGORIES[@category][0] * CATEGORIES[@category][1]) * @quantity
    discounts = @quantity == 1 ? 0 : (total_price * DISCOUNTS[@quantity]) / 100
    @price_cents = total_price - discounts
  end
end
