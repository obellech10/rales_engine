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

  # def favorite_customer
  #   Invoice.joins(:transactions, :customer)
  #     .select("customers.*, COUNT(invoices.customer_id) AS invoice_count")
  #     .where("transactions.result = ?", 'success')
  #     .where(invoices: {merchant_id: "merchants.id"})
  #     .group("customers.id")
  #     .order("invoice_count DESC")
  #     .limit(1)
  # end

  def favorite_customer
    Customer.joins(invoices: :transactions)
      .select("customers.*, COUNT(invoices.customer_id) AS invoice_count")
      .where("transactions.result = ?", 'success')
      .where(invoices: {merchant_id: id})
      .group("customers.id")
      .order("invoice_count DESC").first
  end
end
