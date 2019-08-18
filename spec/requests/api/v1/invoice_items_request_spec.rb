require 'rails_helper'

describe 'Invoice Items Record Endpoints' do
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
    @invoice_3 = @merchant_3.invoices.create!(customer_id: @customer_1.id, status: "shipped")
    @invoice_4 = @merchant_1.invoices.create!(customer_id: @customer_2.id, status: "shipped")
    @invoice_5 = @merchant_4.invoices.create!(customer_id: @customer_1.id, status: "shipped")

    @invoice_items_1 = @invoice_1.invoice_items.create!(item_id: @item_1.id, quantity: 1, unit_price: @item_1.unit_price, created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_items_2 = @invoice_2.invoice_items.create!(item_id: @item_2.id, quantity: 2, unit_price: @item_2.unit_price, created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_items_3 = @invoice_3.invoice_items.create!(item_id: @item_3.id, quantity: 5, unit_price: @item_3.unit_price, created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_items_4 = @invoice_4.invoice_items.create!(item_id: @item_1.id, quantity: 2, unit_price: @item_1.unit_price, created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_items_5 = @invoice_5.invoice_items.create!(item_id: @item_4.id, quantity: 1, unit_price: @item_4.unit_price, created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

    @transaction_1 = @invoice_1.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
    @transaction_2 = @invoice_2.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
    @transaction_3 = @invoice_3.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
    @transaction_4 = @invoice_4.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
    @transaction_5 = @invoice_5.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
  end
  it 'sends a list of Invoice Items' do
    get '/api/v1/invoice_items'

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)

    expect(invoice_items["data"].count).to eq(5)
  end

  it "Can get one invoice item by it's id" do
    get "/api/v1/invoice_items/#{@invoice_items_1.id}"

    expect(response).to be_successful

    invoice_item = JSON.parse(response.body)

    expect(invoice_item["data"]["attributes"]["id"]).to eq(@invoice_items_1.id)
  end

  describe 'Single Finder Endpoints' do
    it 'Can find a invoice_item by id' do
      get "/api/v1/invoice_items/find?id=#{@invoice_items_3.id}"

      expect(response).to be_successful

      invoice_item = JSON.parse(response.body)

      expect(invoice_item["data"]["attributes"]["id"]).to eq(@invoice_items_3.id)
    end

    it "Can find an invoice_item by it's invoice_id" do
      get "/api/v1/invoice_items/find?invoice_id=#{@invoice_items_4.invoice_id}"

      expect(response).to be_successful

      invoice_item = JSON.parse(response.body)

      expect(invoice_item["data"]["attributes"]["invoice_id"]).to eq(@invoice_items_4.invoice_id)
    end

    it "Can find an invoice item by it's item_id" do
      get "/api/v1/invoice_items/find?item_id=#{@invoice_items_4.item_id}"

      expect(response).to be_successful

      invoice_item = JSON.parse(response.body)

      expect(invoice_item["data"]["attributes"]["item_id"]).to eq(@invoice_items_4.item_id)
    end

    it "Can find an invoice item by it's created_at date" do
      invoice_items_6 = @invoice_4.invoice_items.create!(item_id: @item_1.id, quantity: 2, unit_price: @item_1.unit_price, created_at: "2019-06-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
      invoice_items_7 = @invoice_5.invoice_items.create!(item_id: @item_4.id, quantity: 1, unit_price: @item_4.unit_price, created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

      get "/api/v1/invoice_items/find?created_at=#{invoice_items_6.created_at}"

      expect(response).to be_successful

      invoice_item = JSON.parse(response.body)

      expect(invoice_item["data"]["attributes"]["id"]).to eq(invoice_items_6.id)
    end

    it "Can find an invoice item by it's updated_at date" do
      invoice_items_6 = @invoice_4.invoice_items.create!(item_id: @item_1.id, quantity: 2, unit_price: @item_1.unit_price, created_at: "2019-06-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
      invoice_items_7 = @invoice_5.invoice_items.create!(item_id: @item_4.id, quantity: 1, unit_price: @item_4.unit_price, created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-04-15 15:38:30 UTC")

      get "/api/v1/invoice_items/find?updated_at=#{invoice_items_7.updated_at}"

      expect(response).to be_successful

      invoice_item = JSON.parse(response.body)

      expect(invoice_item["data"]["attributes"]["id"]).to eq(invoice_items_7.id)
    end
  end

  describe "Multi-finder Endpoints" do
    it 'Can find all invoice_item by id' do
      get "/api/v1/invoice_items/find_all?id=#{@invoice_items_3.id}"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items["data"].first["attributes"]["id"]).to eq(@invoice_items_3.id)
    end

    it "Can find all invoice_item by it's invoice_id" do
      get "/api/v1/invoice_items/find_all?invoice_id=#{@invoice_items_4.invoice_id}"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items["data"].first["attributes"]["invoice_id"]).to eq(@invoice_items_4.invoice_id)
    end

    it "Can find all invoice items by it's item_id" do
      get "/api/v1/invoice_items/find_all?item_id=#{@invoice_items_2.item_id}"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items["data"].first["attributes"]["item_id"]).to eq(@invoice_items_2.item_id)
    end

    it "Can find all invoice items by it's created_at date" do
      invoice_items_6 = @invoice_4.invoice_items.create!(item_id: @item_1.id, quantity: 2, unit_price: @item_1.unit_price, created_at: "2018-06-15 15:38:30 UTC", updated_at: "2018-08-15 15:38:30 UTC")
      invoice_items_7 = @invoice_5.invoice_items.create!(item_id: @item_4.id, quantity: 1, unit_price: @item_4.unit_price, created_at: "2018-06-15 15:38:30 UTC", updated_at: "2018-08-15 15:38:30 UTC")

      get "/api/v1/invoice_items/find_all?created_at=#{invoice_items_6.created_at}"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items["data"].count).to eq(2)
    end

    it "Can find all invoice items by it's updated_at date" do
      invoice_items_6 = @invoice_4.invoice_items.create!(item_id: @item_1.id, quantity: 2, unit_price: @item_1.unit_price, created_at: "2018-06-15 15:38:30 UTC", updated_at: "2018-08-15 15:38:30 UTC")
      invoice_items_7 = @invoice_5.invoice_items.create!(item_id: @item_4.id, quantity: 1, unit_price: @item_4.unit_price, created_at: "2018-06-15 15:38:30 UTC", updated_at: "2018-08-15 15:38:30 UTC")
      invoice_items_8 = @invoice_5.invoice_items.create!(item_id: @item_4.id, quantity: 1, unit_price: @item_4.unit_price, created_at: "2018-06-15 15:38:30 UTC", updated_at: "2018-08-15 15:38:30 UTC")

      get "/api/v1/invoice_items/find_all?updated_at=#{invoice_items_8.updated_at}"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items["data"].count).to eq(3)
    end
  end
end
