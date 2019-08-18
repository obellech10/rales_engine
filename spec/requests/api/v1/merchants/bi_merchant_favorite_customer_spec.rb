require 'rails_helper'

RSpec.describe 'Merchants' do
  describe 'Merchants Business Intelligence' do
    it 'Can return the merchants favorite cusomter by total successful transactions' do
      merchant_1 = Merchant.create!(name: "Apple", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

      customer_1 = Customer.create!(first_name: "Dan", last_name: "King")
      customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert")

      item_1 = merchant_1.items.create(name: "iPhone", description: "phone", unit_price: 90000)

      invoice_1 = merchant_1.invoices.create!(customer_id: customer_1.id, status: "shipped")
      invoice_2 = merchant_1.invoices.create!(customer_id: customer_2.id, status: "shipped")
      invoice_3 = merchant_1.invoices.create!(customer_id: customer_2.id, status: "shipped")
      invoice_4 = merchant_1.invoices.create!(customer_id: customer_1.id, status: "shipped")
      invoice_5 = merchant_1.invoices.create!(customer_id: customer_2.id, status: "shipped")

      invoice_items_1 = invoice_1.invoice_items.create!(item_id: item_1.id, quantity: 1, unit_price: item_1.unit_price)
      invoice_items_2 = invoice_2.invoice_items.create!(item_id: item_1.id, quantity: 2, unit_price: item_1.unit_price)
      invoice_items_3 = invoice_3.invoice_items.create!(item_id: item_1.id, quantity: 5, unit_price: item_1.unit_price)
      invoice_items_4 = invoice_4.invoice_items.create!(item_id: item_1.id, quantity: 2, unit_price: item_1.unit_price)
      invoice_items_5 = invoice_5.invoice_items.create!(item_id: item_1.id, quantity: 2, unit_price: item_1.unit_price)

      transaction_1 = invoice_1.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
      transaction_2 = invoice_2.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
      transaction_3 = invoice_3.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
      transaction_4 = invoice_4.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
      transaction_5 = invoice_5.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")

      get "/api/v1/merchants/#{merchant_1.id}/favorite_customer"

      top_customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(top_customer["data"]["attributes"]["first_name"]).to eq(customer_2.first_name)
      expect(top_customer["data"]["attributes"]["last_name"]).to eq(customer_2.last_name)
    end
  end
end
