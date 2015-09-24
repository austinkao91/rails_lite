
module Bonus
  class Flash
    def initialize(req)
      cookie = req.cookies.find{ |key| key.name == '_rails_lite_app'} if req
      data = cookie if JSON.parse(cookie.value)
      @flash_now = data[:flash]
      @flash = {}
    end

    def [](key)
      @flash[key]
    end

    def []=(key, val)
      @flash[key] = val
    end

    def now
      @flash_now
    end

    def clear(res)
      @flash = nil
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', {:flash => @flash_now}.to_json)
    end

    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', {:flash => @flash_now}.to_json)
    end

  end
end
