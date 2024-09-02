class CallbackChannel < ApplicationCable::Channel
  def subscribed
    stream_from "callback_channel_#{current_user.id}"
  end

  def unsubscribed; end

  def receive(data)
    case data['type']
    when 'configuration::get'
      get_configuration
    end
  end

  private

  def get_configuration
    api_key = current_user.api_keys.active.last
    key_pair = if api_key
                 { configuration: { access_token: api_key.access_token, secret_token: decoded_secret(api_key) }}
               else
                 { configuration: { access_token: nil, secret_token: nil }}
               end
    ActionCable.server.broadcast("callback_channel_#{current_user.id}", key_pair)
  end

  def decoded_secret(api_key)
    JWT.decode(api_key.secret_token, ApiKey.usk(api_key.access_token, current_user)).first
  end
end
