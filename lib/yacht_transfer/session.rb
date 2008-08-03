module YachtTransfer
  class NonSessionUser < StandardError;  end
  class Session
    class UnknownError < StandardError; end

    attr_writer :auth_token
    attr_reader :session_key

    def initialize(host, uname, pass)
      @host = host
      @username = uname
      @password = pass
    end

    def auth_token
      @auth_token ||= post 'auth.token.get', {:username=>username, :password=>password}
    end

    def secure!
      response = post 'session.get', :auth_token => auth_token
      secure_with!(response['session_key'], response['expires'], response['secret'])
    end

    def secure_with!(session_key, expires, secret_from_session = nil)
      @session_key = session_key
      @expires = Integer(expires)
      @secret_from_session = secret_from_session   
    end

    def secured?
      !@session_key.nil?  && !expired? 
    end

    def post(method, params = {})
      service.post(params.merge!({:method=>method}))
    end

    private
      def service
        @service ||= Service.new(@host, @username)
      end

  end
end
