json.request_id request.uuid || Time.now.to_i.to_s

json.data(JSON.parse(yield))
