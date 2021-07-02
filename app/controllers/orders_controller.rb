class OrdersController < ApplicationController
  before_action :set_order, only: %i[show confirm_payment]

  def show
    authorize @order
  end

  def create
    plan = Plan.find(params[:plan_id])
    authorize plan, :owner?
    @shipment = plan.shipment_cents
    @price = plan.total_price_cents
    order = Order.create!(plan: plan, amount: @price, status: 'pending', user: current_user)

    if plan.carrefour_card == true
      coupon = Stripe::Coupon.create({
                                       name: 'Desconto Cartão Carrefour',
                                       amount_off: @shipment,
                                       currency: 'brl',
                                       duration: 'once'
                                     })

      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: 'Assinatura Carrefour BOX',
          amount: @price,
          currency: 'brl',
          quantity: 1
        }],
        discounts: [{
          coupon: coupon
        }],
        success_url: confirm_payment_order_url(order),
        cancel_url: plan_url(plan)
      )
    else
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: 'Assinatura Carrefour BOX',
          amount: @price,
          currency: 'brl',
          quantity: 1
        }],
        success_url: confirm_payment_order_url(order),
        cancel_url: plan_url(plan)
      )
    end

    order.update(checkout_session_id: session.id)
    redirect_to new_order_payment_path(order)
  end

  def confirm_payment
    authorize @order
    @order.update(status: 'complete')
    session.delete('boxes')
    redirect_to @order
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
