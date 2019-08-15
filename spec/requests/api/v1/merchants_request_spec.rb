require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq(5)
  end

  it "can get one merchant by it's id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["id"]).to eq(id)
  end

  it "can find merchant by id" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    get "/api/v1/merchants/find?id=#{merchant_1.id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["id"]).to eq(merchant_1.id)
  end

  it "can find merchant by name" do
    merchant_1 = Merchant.create(name: "banana stand", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    merchant_2 = Merchant.create(name: "flower shop", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    merchant_3 = Merchant.create(name: "drinks, drinks, drinks", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

    get "/api/v1/merchants/find?name=#{merchant_1.name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["name"]).to eq(merchant_1.name)
  end

  it "can find merchant by created at parameter" do
    created_merchant = Merchant.create(name: "banana stand", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

    get "/api/v1/merchants/find?created_at=#{created_merchant.created_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["created_at"].to_date).to eq(created_merchant.created_at.to_date)
  end

  it "can find merchant by updated at parameter" do
    created_merchant = Merchant.create(name: "banana stand", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

    get "/api/v1/merchants/find?updated_at=#{created_merchant.updated_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["updated_at"].to_date).to eq(created_merchant.updated_at.to_date)
  end

  it "can find all merchants by id" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    get "/api/v1/merchants/find_all?id=#{merchant_2.id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"].first["attributes"]["id"]).to eq(merchant_2.id)
  end

  it "can find all merchants by name" do
    merchant_1 = Merchant.create(name: "banana stand", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    merchant_2 = Merchant.create(name: "banana stand", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    merchant_2 = Merchant.create(name: "banana stand", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

    get "/api/v1/merchants/find_all?name=#{"banana stand"}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"].count).to eq(3)
  end

  it "can find all merchants by created at date" do
    merchant_1 = Merchant.create(name: "banana stand", created_at: "2019-08-14 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    merchant_2 = Merchant.create(name: "banana stand", created_at: "2019-08-14 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    merchant_2 = Merchant.create(name: "banana stand", created_at: "2019-08-14 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    merchant_2 = Merchant.create(name: "banana stand", created_at: "2019-08-14 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

    get "/api/v1/merchants/find_all?created_at=#{"2019-08-14 15:38:30 UTC"}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"].count).to eq(4)
  end

  it "can find all merchants by updated at date" do
    merchant_1 = Merchant.create(name: "banana stand", created_at: "2019-08-14 15:38:30 UTC", updated_at: "2019-08-14 15:38:30 UTC")
    merchant_2 = Merchant.create(name: "banana stand", created_at: "2019-08-14 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    merchant_2 = Merchant.create(name: "banana stand", created_at: "2019-08-14 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    merchant_2 = Merchant.create(name: "banana stand", created_at: "2019-08-14 15:38:30 UTC", updated_at: "2019-08-14 15:38:30 UTC")

    get "/api/v1/merchants/find_all?updated_at=#{"2019-08-15 15:38:30 UTC"}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"].count).to eq(2)
  end
end
