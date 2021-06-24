class CheckoutController < ApplicationController
  CATEGORIES = {
    'Mensal' => [9990, 1],
    'Trimestral' => [8990, 3],
    'Semestral' => [7990, 6],
    'Anual' => [6990, 12]
  }.freeze

  DISCOUNTS = { 2 => 5, 3 => 10 }.freeze

  def create
    skip_authorization
    @quantity = params[:boxes].keys.size
    @category = params[:category]
    total_price = (CATEGORIES[@category][0] * CATEGORIES[@category][1]) * @quantity
    discounts = @quantity == 1 ? 0 : (total_price * DISCOUNTS[@quantity]) / 100
    @price_cents = total_price - discounts
    # Setting up a Stripe Session for payment
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: 'Receber no endereço:',

        amount: @price_cents,
        quantity: @quantity,
        currency: 'brl'
      }],
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url
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
