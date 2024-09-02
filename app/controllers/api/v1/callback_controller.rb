# frozen_string_literal: true

module Api
  module V1
    class CallbackController < ActionController::API
      def evaluation_callback
        broadcast_to_channel
      end

      def explanations_callback
        broadcast_to_channel
      end

      private

      def broadcast_to_channel
        payload = JSON.parse(request.body.read)
        return unless payload['token_id'].present?

        token = Token.find_by(value: payload['token_id'])
        return unless token.present?

        api_key = token.api_key
        return unless api_key.present?

        user = api_key.user
        return unless user.present?

        ActionCable.server.broadcast("callback_channel_#{user.id}", payload)
      end
    end
  end
end
