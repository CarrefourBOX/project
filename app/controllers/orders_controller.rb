class OrdersController < ApplicationController
  before_action :set_order, only: %i[show confirm_payment]

  def show
    authorize @order
  end

  def create
    plan = Plan.find(params[:plan_id])
    authorize plan, :owner?
    # @price = plan.price / plan.quantity
    # @monthly_price_cents = plan.monthly_price_cents / plan.quantity
    order = Order.create!(plan: plan, amount: @price, status: 'pending', user: current_user)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: "Assinatura Carrefour BOX - Plano #{plan.category}",
        amount: plan.monthly_price_cents,
        currency: 'brl',
        quantity: plan.quantity
      }],
      success_url: confirm_payment_order_url(order),
      cancel_url: plan_url(plan)
    )
    order.update(checkout_session_id: session.id)
    redirect_to new_order_payment_path(order)
  end

  def confirm_payment
    authorize @order
    @order.update(status: 'complete')
    redirect_to @order
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
