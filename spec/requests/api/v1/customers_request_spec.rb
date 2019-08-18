require 'rails_helper'

describe "Customer API" do
  it 'sends a list of customers' do
    create_list(:customer, 6)

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers["data"].count).to eq(6)
  end

  it "can get one customer by it's id" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]["id"]).to eq(id)
  end

  it 'Can find a customer by id' do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)

    get "/api/v1/customers/find?id=#{customer_2.id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]["id"]).to eq(customer_2.id)
  end

  it 'Can find a customer by name' do
    customer_1 = Customer.create!(first_name: "Dan", last_name: "King")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert")

    get "/api/v1/customers/find?first_name=#{customer_2.first_name}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]["first_name"]).to eq(customer_2.first_name)
    expect(customer["data"]["attributes"]["last_name"]).to eq(customer_2.last_name)
  end

  it 'Can find customer by created at parameter' do
    customer_1 = Customer.create!(first_name: "Dan", last_name: "King", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert", created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")

    get "/api/v1/customers/find?created_at=#{customer_1.created_at}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]["first_name"]).to eq(customer_1.first_name)
    expect(customer["data"]["attributes"]["last_name"]).to eq(customer_1.last_name)
  end

  it 'Can find customer by updated at parameter' do
    customer_1 = Customer.create!(first_name: "Dan", last_name: "King", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert", created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-07-15 15:38:30 UTC")

    get "/api/v1/customers/find?updated_at=#{customer_2.updated_at}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]["first_name"]).to eq(customer_2.first_name)
    expect(customer["data"]["attributes"]["last_name"]).to eq(customer_2.last_name)
  end

  it 'Can find all customers by id' do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)

    get "/api/v1/customers/find_all?id=#{customer_3.id}"

    customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customers["data"].first["attributes"]["id"]).to eq(customer_3.id)
  end

  it 'Can find all customers by name' do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)

    get "/api/v1/customers/find_all?first_name=#{customer_2.first_name}"

    customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customers["data"].count).to eq(3)
  end

  it 'Can find all customers by created at date' do
    customer_1 = Customer.create!(first_name: "Dan", last_name: "King", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert", created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert", created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert", created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-07-15 15:38:30 UTC")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert", created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-07-15 15:38:30 UTC")

    get "/api/v1/customers/find_all?created_at=#{"2019-07-15 15:38:30 UTC"}"

    customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customers["data"].count).to eq(4)
  end

  it 'Can find all customers by updated at date' do
    customer_1 = Customer.create!(first_name: "Dan", last_name: "King", created_at: "2019-08-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert", created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert", created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-08-15 15:38:30 UTC")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert", created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-07-15 15:38:30 UTC")
    customer_2 = Customer.create!(first_name: "Chris", last_name: "Evert", created_at: "2019-07-15 15:38:30 UTC", updated_at: "2019-07-15 15:38:30 UTC")

    get "/api/v1/customers/find_all?updated_at=#{"2019-08-15 15:38:30 UTC"}"

    customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customers["data"].count).to eq(3)
  end
end
