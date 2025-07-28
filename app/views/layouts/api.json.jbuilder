json.request_id request.uuid || Time.now.to_i.to_s
json.status 0
json.msg 'msg'
json.data(JSON.parse(yield))
json.toast @toast
json.error @error
