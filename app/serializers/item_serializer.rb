class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :unit_price, :merchant_id

  belongs_to :merchant

  has_many :invoices
  has_many :invoice_items

  attribute :unit_price do |object|
    "#{'%.2f' % (object.unit_price/100.0)}"
  end
end
