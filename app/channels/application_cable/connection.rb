module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def disconnect
      self.current_user = nil
    end

    protected

    def find_verified_user
      return unless env['warden'].user

      env['warden'].user
    end
  end
end
