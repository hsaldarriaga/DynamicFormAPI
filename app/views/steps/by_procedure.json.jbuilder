json.array!(@steps) do |step|
  json.extract! step, :id, :step_id, :procedure_id, :content
  json.url step_url(step, format: :json)
end