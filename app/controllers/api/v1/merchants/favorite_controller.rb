class Api::V1::Merchants::FavoriteController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]).favorite_customer)
  end
end
