class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  validates_presence_of :name

  def self.most_revenue(quantity)
    joins(invoices: [:invoice_items, :transactions])
        .select("merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
        .where("transactions.result = ?", "success")
        .group(:id)
        .order("revenue desc")
        .limit(quantity)
  end

  def self.most_items(quantity)
    joins(invoices: [:invoice_items, :transactions])
      .select('merchants.*, SUM(invoice_items.quantity) AS count')
      .where("transactions.result = ?", 'success')
      .group(:id)
      .order('count DESC')
      .limit(quantity)
  end
end
