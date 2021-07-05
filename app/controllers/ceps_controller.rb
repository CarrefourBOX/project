class CepsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[calculate_shipment]

  def fetch_address
    authorize :cep
    begin
      address = ViaCep::Address.new(params[:cep])
    rescue ViaCep::Errors::InvalidZipcodeFormat
      address = 'formato inválido'
    rescue ViaCep::Errors::ZipcodeNotFound
      address = 'CEP não encontrado'
    end
    respond_to do |format|
      format.json { render json: { address: address } }
    end
  end

  def calculate_shipment
    skip_authorization
    begin
      address = ViaCep::Address.new(params[:cep])
      destination = "#{address.street}, #{address.city}, #{address.state}"
      shipment_distance = Geocoder::Calculations.distance_between(CARREFOUR_COORDS, destination)
      shipment = shipment_distance < 100 ? 1499 : 1499 + shipment_distance.round
    rescue ViaCep::Errors::InvalidZipcodeFormat
      address = 'formato inválido'
    rescue ViaCep::Errors::ZipcodeNotFound
      address = 'CEP não encontrado'
    end
    respond_to do |format|
      format.json { render json: { address: address, shipment: shipment } }
    end
  end
end
