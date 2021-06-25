class OrdersController < ApplicationController
  def show
    skip_authorization
    @order = current_user.orders.find(params[:id])
  end

  def create
    skip_authorization
    plan = Plan.find(params[:plan_id])
    @price = plan.price / plan.quantity
    @price_cents = plan.price_cents / plan.quantity
    order  = Order.create!(plan: plan, amount: @price, state: 'pending', user: current_user)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: "Compra de #{current_user.name} n #{current_user.plans.count}",
        amount: @price_cents,
        currency: 'brl',
        quantity: plan.quantity
      }],
      success_url: order_url(order),
      cancel_url: order_url(order)
    )

    order.update(checkout_session_id: session.id)
    redirect_to new_order_payment_path(order)
  end
end
