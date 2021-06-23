class BoxNamesController < ApplicationController
  def create
    @box_name = BoxName.new(box_name_params)
    @box_name.color = params[:box_name][:color].first
    authorize @box_name
    flash[:notice] = "Caixa '#{@box_name.name}' criada!" if @box_name.save
    redirect_to dashboard_path
  end

  def destroy
    @box_name = BoxName.find(params[:id])
    authorize @box_name
    BoxItem.where(box_name: @box_name.name).each(&:destroy)
    flash[:notice] = "Caixa '#{@box_name.name}' removida!"
    @box_name.destroy
    redirect_to dashboard_path
  end

  private

  def box_name_params
    params.require(:box_name).permit(:name, :description, color: [])
  end
end
