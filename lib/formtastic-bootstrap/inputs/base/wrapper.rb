module FormtasticBootstrap
  module Inputs
    module Base
      module Wrapper
        
        def form_group_wrapper(&block)
          template.content_tag(:div, :class => 'form-group') do
            yield
          end
        end

      end
    end
  end
end 