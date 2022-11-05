json.extract! stock, :id, :symbol, :desc, :value, :count, :created_at, :updated_at
json.url stock_url(stock, format: :json)
