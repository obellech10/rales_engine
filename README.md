# README


* Database initialization

  Make sure that the following CSV files are saved under the rales_engine/db folder
  - merchants.csv
  - customers.csv
  - items.csv
  - invoices.csv
  - transactions.csv
  - invoice_items.csv

  From the terminal run the following commands
  1. Run bundle install
  1. Run rails db:{drop,create,migrate}
  1. Run bundle exec rake import
