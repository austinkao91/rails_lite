require_relative '/flash'
require_relative '../phase6/controller_base'

module Bonus
  class ControllerBase < Phase6::ControllerBase
    def redirect_to(url)
      super(url)
      flash.store_session(res)
    end

    def render_content(content, content_type)
      super(content, content_type)
      flash.store_session(res)
    end

    def flash
      @flash ||= Flash.new(req)
    end

  end
end
