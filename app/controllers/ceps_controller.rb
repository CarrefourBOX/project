class CepsController < ApplicationController
  def fetch_address
    authorize :cep
    @address = ViaCep::Address.new(params[:cep])
    respond_to do |format|
      format.json { render json: @address }
    end
  end
end
