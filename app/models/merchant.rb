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

  def favorite_customer
    Customer.joins(invoices: :transactions)
      .select("customers.*, COUNT(invoices.customer_id) AS invoice_count")
      .where(invoices: {merchant_id: id})
      .merge(Transaction.unscoped.successful)
      .group("customers.id")
      .order("invoice_count DESC").first
  end

  # def self.revenue(date)
  #   Invoice.joins(:invoice_items, :transactions)
  #     .merge(Transaction.successful)
  #     .where({invoice_items: {created_at: (date.to_date.all_day)}})
  #     .sum("invoice_items.quantity * invoice_items.unit_price")
  # end
  #
  def total_revenue
    Invoice.joins(:invoice_items, :transactions)
      .merge(Transaction.successful)
      .where(invoices: {merchant_id: id})
      .sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
