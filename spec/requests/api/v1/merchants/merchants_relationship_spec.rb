require 'rails_helper'

describe 'Merchants relationship endpoints' do
  it "can return all items for a merchant" do
    merchant_1 = Merchant.create(name: "banana stand", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    item_1 = merchant_1.items.create(name: "banana milkshake", description: "milkshake", unit_price: 599)
    item_2 = merchant_1.items.create(name: "banana milkshake", description: "milkshake", unit_price: 699)
    item_3 = merchant_1.items.create(name: "banana milkshake", description: "milkshake", unit_price: 550)
    item_4 = merchant_1.items.create(name: "banana milkshake", description: "milkshake", unit_price: 650)

    get "/api/v1/merchants/#{merchant_1.id}/items"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"].count).to eq(4)
  end

  it 'can return all invoices for a merchant' do
    merchant_1 = Merchant.create!(name: "banana stand", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    customer = Customer.create!(first_name: "Dan", last_name: "Banana")
    invoice_1 = merchant_1.invoices.create!(customer_id: customer.id, status: "shipped")
    invoice_2 = merchant_1.invoices.create!(customer_id: customer.id, status: "shipped")
    invoice_3 = merchant_1.invoices.create!(customer_id: customer.id, status: "shipped")
    invoice_4 = merchant_1.invoices.create!(customer_id: customer.id, status: "shipped")
    invoice_5 = merchant_1.invoices.create!(customer_id: customer.id, status: "shipped")

    get "/api/v1/merchants/#{merchant_1.id}/invoices"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"].count).to eq(5)
  end
end
