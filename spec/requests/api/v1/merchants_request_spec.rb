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
    created_merchant = create(:merchant)

    get "/api/v1/merchants/find?id=#{created_merchant.id}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["id"]).to eq(created_merchant.id)
  end

  it "can find merchant by name" do
    created_merchant = create(:merchant)

    get "/api/v1/merchants/find?name=#{created_merchant.name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["name"]).to eq(created_merchant.name)
  end

  it "can find merchant by created at parameter" do
    created_merchant = create(:merchant)

    get "/api/v1/merchants/find?created_at=#{created_merchant.created_at}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["created_at"].to_date).to eq(created_merchant.created_at.to_date)
  end

  it "can find merchant by updated at parameter" do
    created_merchant = create(:merchant)

    get "/api/v1/merchants/find?updated_at=#{created_merchant.updated_at.to_date}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["updated_at"].to_date).to eq(created_merchant.updated_at.to_date)
  end
end
