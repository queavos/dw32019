json.extract! cliente, :id, :nombres, :fecha, :pais_id, :created_at, :updated_at
json.url cliente_url(cliente, format: :json)
