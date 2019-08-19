class Api::V1::Items::SearchController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.where(item_params))
  end

  def show
    render json: ItemSerializer.new(Item.find_by(item_params))
  end

private

  def item_params
    adj_unit_price(params.permit(:id,
                                 :name,
                                 :description,
                                 :unit_price,
                                 :merchant_id,
                                 :created_at,
                                 :updated_at))
  end
end
