def authenticate user
  request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.id, user.token)
end

def set_api_headers
  request.env['HTTP_ACCEPT'] = "application/json"
  request.env['HTTP_CONTENT_TYPE'] = "application/json"
end

def decode data
  ActiveSupport::JSON.decode(data)
end
