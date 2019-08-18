class ApplicationController < ActionController::API
  def adj_unit_price(parameter)
    if parameter[:unit_price]
      parameter[:unit_price] = parameter[:unit_price].gsub('.','')
    end
      parameter
  end
end
