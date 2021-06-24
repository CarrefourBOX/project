class BoxItemsController < ApplicationController
  def new
    @box_item = BoxItem.new
    authorize @box_item
  end

  def create
    @box_item = BoxItem.new(box_item_params)
    authorize @box_item
    return unless @box_item.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("#{@box_item.box_name.downcase.gsub(' ', '-')}-items",
                                                 partial: 'box_items/item',

                                                 locals: { item: @box_item })
      end
    end
  end

  def destroy
    @box_item = BoxItem.find(params[:id])
    authorize @box_item
    @box_item.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@box_item)
      end
    end
  end

  private

  def box_item_params
    params.require(:box_item).permit(:item_name, :box_name)
  end
end
