class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name,
                        :description,
                        :unit_price

  default_scope{order(id: :asc)}

  def self.most_revenue(quantity)
    joins(:invoice_items, :transactions)
      .select("items.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
      .merge(Transaction.unscoped.successful)
      .group(:id).unscoped
      .order("revenue desc")
      .limit(quantity)
  end
end
