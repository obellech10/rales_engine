require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'Relationships' do
    it {should have_many :items}
    it {should have_many :invoices}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
  end

  describe 'Class methods' do
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
      @invoice_4 = @merchant_1.invoices.create!(customer_id: @customer_1.id, status: "shipped")
      @invoice_5 = @merchant_4.invoices.create!(customer_id: @customer_2.id, status: "shipped")

      @invoice_items_1 = @invoice_1.invoice_items.create!(item_id: @item_1.id, quantity: 1, unit_price: @item_1.unit_price)
      @invoice_items_2 = @invoice_2.invoice_items.create!(item_id: @item_2.id, quantity: 2, unit_price: @item_2.unit_price)
      @invoice_items_3 = @invoice_3.invoice_items.create!(item_id: @item_3.id, quantity: 5, unit_price: @item_3.unit_price)
      @invoice_items_4 = @invoice_4.invoice_items.create!(item_id: @item_1.id, quantity: 2, unit_price: @item_1.unit_price)
      @invoice_items_5 = @invoice_5.invoice_items.create!(item_id: @item_4.id, quantity: 1, unit_price: @item_4.unit_price)

      @transaction_1 = @invoice_1.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
      @transaction_2 = @invoice_2.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
      @transaction_3 = @invoice_3.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
      @transaction_4 = @invoice_4.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
      @transaction_5 = @invoice_5.transactions.create!(credit_card_number: 123456781234, credit_card_expiration_date: nil, result: "success")
    end

    it 'Returns the top 3 merchants ranked by total revenue' do
      top_merchants = Merchant.most_revenue(3)

      expect(top_merchants[0]).to eq(@merchant_1)
      expect(top_merchants[1]).to eq(@merchant_4)
      expect(top_merchants[2]).to eq(@merchant_3)
    end

    it 'Returns the top 3 merchants ranked by total items sold' do
      top_merchants = Merchant.most_items(3)

      expect(top_merchants[0]).to eq(@merchant_3)
      expect(top_merchants[1]).to eq(@merchant_1)
      expect(top_merchants[2]).to eq(@merchant_2)
    end

    it 'Returns the top customer for a merchant based on successful transactions' do
      top_customer = @merchant_1.favorite_customer

      expect(top_customer).to eq(@customer_1)
    end
  end
end
