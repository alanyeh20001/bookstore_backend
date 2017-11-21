module Request
  module JsonHelpers
    def json_response
      JSON.parse(response.body, symbolize_names: true)
    end
  end

  module AuthHelpers
    def auth_headers(user)
      {
        'Authorization': "Bearer #{token(user)}"
      }
    end

    private

    def token(user)
      JWT.encode(payload(user), Rails.application.secrets.secret_key_base, 'HS256')
    end

    def payload(user)
      {
        user_id: user.id,
        exp: 24.hours.from_now.to_i
      }
    end
  end
end
