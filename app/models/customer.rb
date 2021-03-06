class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :first_name,
                        :last_name

  def favorite_merchant
    Merchant.joins(invoices: :transactions)
      .select("merchants.*, COUNT(invoices.merchant_id) AS invoice_count")
      .where(invoices: {customer_id: id})
      .merge(Transaction.unscoped.successful)
      .group("merchants.id")
      .order("invoice_count DESC").first
  end
end
