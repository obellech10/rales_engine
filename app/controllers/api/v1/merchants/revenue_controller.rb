class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    # binding.pry
    # render json: MerchantSerializer.new(Merchant.revenue(params[:date]))
    # render json: RevenueSerializer.new(Merchant.revenue(params[:date]))
  end
end
