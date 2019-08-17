class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name

  has_many :items
  has_many :invoices

  # attribute :revenue do |obj|
  #   binding.pry
  # end
end
