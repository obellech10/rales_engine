require 'rails_helper'

describe 'Item Relationship Endpoints' do
  before :each do
    @merchant_1 = Merchant.create!(name: "Apple", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @merchant_2 = Merchant.create!(name: "Keurig", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @merchant_3 = Merchant.create!(name: "Samsung", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @merchant_4 = Merchant.create!(name: "Whirlpool", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

    @customer_1 = Customer.create!(first_name: "Dan", last_name: "King")
    @customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert")

    @item_1 = @merchant_1.items.create(name: "iPhone", description: "phone", unit_price: 90000)
    @item_2 = @merchant_2.items.create(name: "Keurig 300", description: "coffee pot", unit_price: 6990)
    @item_3 = @merchant_3.items.create(name: "Flat screen monitor", description: "monitor", unit_price: 11550)
    @item_4 = @merchant_4.items.create(name: "Oven", description: "oven", unit_price: 65000)

    @invoice_1 = @merchant_1.invoices.create!(customer_id: @customer_1.id, status: "shipped")
    @invoice_2 = @merchant_2.invoices.create!(customer_id: @customer_2.id, status: "shipped")
    @invoice_3 = @merchant_1.invoices.create!(customer_id: @customer_1.id, status: "shipped")
    @invoice_4 = @merchant_2.invoices.create!(customer_id: @customer_2.id, status: "shipped")
    @invoice_5 = @merchant_4.invoices.create!(customer_id: @customer_1.id, status: "shipped")

    @invoice_items_1 = @invoice_1.invoice_items.create!(item_id: @item_1.id, quantity: 1, unit_price: @item_1.unit_price, created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_items_2 = @invoice_1.invoice_items.create!(item_id: @item_2.id, quantity: 2, unit_price: @item_2.unit_price, created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_items_3 = @invoice_2.invoice_items.create!(item_id: @item_1.id, quantity: 5, unit_price: @item_1.unit_price, created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_items_4 = @invoice_2.invoice_items.create!(item_id: @item_2.id, quantity: 2, unit_price: @item_2.unit_price, created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_items_5 = @invoice_4.invoice_items.create!(item_id: @item_4.id, quantity: 1, unit_price: @item_4.unit_price, created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

    @transaction_1 = @invoice_1.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
    @transaction_2 = @invoice_1.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
    @transaction_3 = @invoice_2.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
    @transaction_4 = @invoice_2.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
    @transaction_5 = @invoice_1.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
  end

  it "Returns a collection of associated invoice items" do
    get "/api/v1/items/#{@item_1.id}/invoice_items"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_items["data"].count).to eq(2)
  end

  it "Returns the associated merchant" do
    get "/api/v1/items/#{@item_2.id}/merchant"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["name"]).to eq(@merchant_2.name)
  end
end
