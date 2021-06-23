class BoxItemsController < ApplicationController
  def create
    @box_item = BoxItem.new(box_item_params)
    authorize @box_item
    flash[:notice] = @box_item.save ? 'Item adicionado.' : @box_item.errors.full_messages
    redirect_to dashboard_path
  end

  def destroy
    @box_item = BoxItem.find(params[:id])
    authorize @box_item
    @box_item.destroy
    flash[:notice] = 'Item apagado.'
    redirect_to dashboard_path
  end

  private

  def box_item_params
    params.require(:box_item).permit(:item_name, :box_name)
  end
end
