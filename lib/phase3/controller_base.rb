require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      class_name = self.class.to_s.split('Controller').first
      controller_name = "#{class_name}_controller"
      file = File.read("views/#{controller_name}/#{template_name}.html.erb")
      new_file = ERB.new(file).result(binding)

      render_content(new_file, 'text/html')
    end
  end
end
