module YachtTransfer
  class Session

    attr_accessor :service, :username, :password

    def initialize(host, uname, pass)
      @service = host
      @username = uname
      @password = pass
    end

    def secure!
      @agent = service.post({:method=>'session.get', :username=>username, :password=>password})
    end

    def secured?
      !@agent.nil? # && !expired? 
    end

    def post(method, params = {})
      service.post(params.merge!({:method=>method}))
    end
  end
end
