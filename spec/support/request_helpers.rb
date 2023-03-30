# frozen_string_literal: true

module RequestHelpers
  def json
    @json ||= JSON.parse(response.body, symbolize_names: true)
  end

  def authenticated_headers(user = nil)
    auth = user.create_new_auth_token
    auth.merge({ 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
