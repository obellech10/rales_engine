class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :unit_price, :merchant_id

  belongs_to :merchant
  
  has_many :invoices
  has_many :invoice_items
end