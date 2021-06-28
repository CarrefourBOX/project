class PaymentsController < ApplicationController
  def new
    skip_authorization
    @order = current_user.orders.find(params[:order_id])
  end
end
