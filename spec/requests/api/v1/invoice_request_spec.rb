require 'rails_helper'

describe 'Invoice Record Endpoints' do
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

    @invoice_1 = @merchant_1.invoices.create!(customer_id: @customer_1.id, status: "shipped", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_2 = @merchant_2.invoices.create!(customer_id: @customer_2.id, status: "shipped", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_3 = @merchant_3.invoices.create!(customer_id: @customer_1.id, status: "shipped", created_at: "2000-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    @invoice_4 = @merchant_1.invoices.create!(customer_id: @customer_2.id, status: "shipped", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2000-08-15 15:38:30 UTC")
    @invoice_5 = @merchant_4.invoices.create!(customer_id: @customer_1.id, status: "shipped", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

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

  it 'Sends a list of Invoices' do
    get '/api/v1/invoices'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)

    expect(invoices["data"].count).to eq(5)
  end

  it "Can get one invoice by it's id" do
    get "/api/v1/invoices/#{@invoice_1.id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["attributes"]["id"]).to eq(@invoice_1.id)
  end

  describe 'Single Finder Endpoints' do
    it 'Can find an invoice by id' do
      get "/api/v1/invoices/find?id=#{@invoice_2.id}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"]["attributes"]["id"]).to eq(@invoice_2.id)
    end

    it 'Can find an invoice by customer_id' do
      get "/api/v1/invoices/find?customer_id=#{@invoice_3.customer_id}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"]["attributes"]["customer_id"]).to eq(@customer_1.id)
    end

    it 'Can find an invoice by merchant_id' do
      get "/api/v1/invoices/find?merchant_id=#{@invoice_4.merchant_id}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"]["attributes"]["merchant_id"]).to eq(@merchant_1.id)
    end

    it 'Can find an invoice by status' do
      get "/api/v1/invoices/find?status=#{@invoice_5.status}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"]["attributes"]["id"]).to eq(@invoice_1.id)
    end

    it 'Can find an invoice by created_at date' do
      get "/api/v1/invoices/find?created_at=#{@invoice_3.created_at}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"]["attributes"]["id"]).to eq(@invoice_3.id)
    end

    it 'Can find an invoice by updated_at date' do
      get "/api/v1/invoices/find?updated_at=#{@invoice_4.updated_at}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"]["attributes"]["id"]).to eq(@invoice_4.id)
    end
  end

  describe "Multi-finder Endpoints" do
    it 'Can find all invoices by id' do
      get "/api/v1/invoices/find_all?id=#{@invoice_1.id}"

      expect(response).to be_successful

      invoices = JSON.parse(response.body)

      expect(invoices["data"].first["attributes"]["id"]).to eq(@invoice_1.id)
    end

    it 'Can find all invoices by customer_id' do
      get "/api/v1/invoices/find_all?customer_id=#{@invoice_2.customer_id}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"].first["attributes"]["customer_id"]).to eq(@customer_2.id)
    end

    it 'Can find all invoices by merchant_id' do
      get "/api/v1/invoices/find_all?merchant_id=#{@invoice_3.merchant_id}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"].first["attributes"]["merchant_id"]).to eq(@merchant_3.id)
    end

    it 'Can find all invoices by status' do
      get "/api/v1/invoices/find_all?status=#{@invoice_1.status}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"].first["attributes"]["id"]).to eq(@invoice_1.id)
    end

    it 'Can find all invoices by created_at date' do
      get "/api/v1/invoices/find_all?created_at=#{@invoice_3.created_at}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"].first["attributes"]["id"]).to eq(@invoice_3.id)
    end

    it 'Can find all invoices by updated_at date' do
      get "/api/v1/invoices/find_all?updated_at=#{@invoice_4.updated_at}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"].first["attributes"]["id"]).to eq(@invoice_4.id)
    end
  end
end
