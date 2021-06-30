class AddressesController < ApplicationController
  before_action :set_address, only: %i[update destroy]

  def create
    @address = Address.new(address_params)
    authorize @address
    @address.user = current_user
    flash[:notice] = 'Endereço adicionado' if @address.save
    main_address(@address) if @address.main
    redirect_to my_addresses_path
  end

  def update
    authorize @address
    flash[:notice] = 'Endereço atualizado' if @address.update(address_params)
    main_address(@address) if @address.main
    redirect_to my_addresses_path
  end

  def destroy
    authorize @address
    flash[:notice] = 'Endereço excluído' if @address.destroy
    redirect_to my_addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:name, :cep, :street, :number, :complements, :state, :city, :main)
  end

  def set_address
    @address = Address.find(params[:id])
  end

  def main_address(address)
    current_user.addresses.where.not(id: address.id).update_all(main: false)
  end
end
