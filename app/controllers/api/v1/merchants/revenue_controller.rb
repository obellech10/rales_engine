class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    binding.pry
    revenue = Merchant.find(params[:id]).total_revenue
    render json: MerchantSerializer.new(revenue)
    # render json: RevenueSerializer.new(Merchant.revenue(params[:date]))
  end
end
