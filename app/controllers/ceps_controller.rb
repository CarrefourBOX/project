class CepsController < ApplicationController
  def fetch_address
    authorize :cep
    @address = ViaCep::Address.new(params[:cep])
    respond_to do |format|
      format.json { render json: @address }
    end
  end

  def calculate_shipment
    authorize :cep
    begin
      address = ViaCep::Address.new(params[:cep])
      destination = "#{address.street}, #{address.city}, #{address.state}"
      shipment_distance = Geocoder::Calculations.distance_between(CARREFOUR_COORDS, destination)
      shipment = shipment_distance < 100 ? 1499 : 1499 + shipment_distance.round
    rescue ViaCep::Errors::InvalidZipcodeFormat
      puts 'Rescued: '
      address = 'formato inválido'
    rescue ViaCep::Errors::ZipcodeNotFound
      address = 'CEP não encontrado'
    end
    respond_to do |format|
      format.json { render json: { address: address, shipment: shipment } }
    end
  end
end
