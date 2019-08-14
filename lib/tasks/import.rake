require 'csv'

desc "Import merchants from csv file"
task :import => [:environment] do

  merchant = "db/merchants.csv"

  CSV.foreach(merchant, :headers => true) do |row|
    Merchant.create!(row.to_hash)
  end
end

desc "Import customers from csv file"
task :import => [:environment] do

  customer = "db/customers.csv"

  CSV.foreach(customer, :headers => true) do |row|
    Customer.create!(row.to_hash)
  end
end

desc "Import items from csv file"
task :import => [:environment] do

  item = "db/items.csv"

  CSV.foreach(item, :headers => true) do |row|
    Item.create!(row.to_hash)
  end
end

desc "Import invoices from csv file"
task :import => [:environment] do

  invoice = "db/invoices.csv"

  CSV.foreach(invoice, :headers => true) do |row|
    Invoice.create!(row.to_hash)
  end
end

desc "Import transactions from csv file"
task :import => [:environment] do

  transaction = "db/transactions.csv"

  CSV.foreach(transaction, :headers => true) do |row|
    Transaction.create!(row.to_hash)
  end
end

desc "Import invoice_items from csv file"
task :import => [:environment] do

  invoice_item = "db/invoice_items.csv"

  CSV.foreach(invoice_item, :headers => true) do |row|
    InvoiceItem.create!(row.to_hash)
  end
end
