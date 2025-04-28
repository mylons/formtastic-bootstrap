module FormtasticBootstrap
  module Inputs
    module Base
      module Html

        include Formtastic::Inputs::Base
        include Formtastic::Inputs::Base::Html
        
        def form_control_input_html_options
          # Fetch original options containing :input_html attrs
          orig_options = input_html_options 
          orig_class = orig_options[:class] 
          # Combine original class with form-control
          new_class = [orig_class, "form-control"].compact.join(" ")
          # Merge the new class string back into the *original* options hash
          orig_options.merge(:class => new_class)
        end

      end
    end
  end
end
