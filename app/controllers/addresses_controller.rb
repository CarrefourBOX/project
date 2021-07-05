class AddressesController < ApplicationController
  before_action :set_address, only: %i[update destroy]

  def create
    @address = Address.new(address_params)
    authorize @address
    @address.user = current_user
    @address.main = true if current_user.addresses.active.empty?
    flash[:notice] = 'Endereço adicionado' if @address.save
    main_address(@address) if @address.main
    partial = params[:request_path] == '/addresses' ? 'addresses/address' : 'addresses/address_radio'
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.prepend('addresses-list',
                                                  partial: partial,

                                                  locals: { address: @address })
      end
    end
  end

  def update
    authorize @address
    flash[:notice] = 'Endereço atualizado' if @address.update(address_params)
    main_address(@address) if @address.main
    partial = params[:request_path] == '/my_addresses' ? 'addresses/address' : 'addresses/address_radio'
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@address,
                                                  partial: partial,

                                                  locals: { address: @address })
      end
    end
  end

  def destroy
    authorize @address
    flash[:notice] = 'Endereço excluído' if @address.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@address)
      end
    end
  end

  def address_choice
    session[:address_id] = params[:'address-radio']
    @address = Address.find(session[:address_id])
    authorize @address
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('current-address',
                                                  partial: 'addresses/current_address',

                                                  locals: { current_address: @address })
      end
    end
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
