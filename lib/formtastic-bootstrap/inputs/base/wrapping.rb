module FormtasticBootstrap
  module Inputs
    module Base
      module Wrapping

        include Formtastic::Inputs::Base::Wrapping

        def wrapper_classes
          classes = super.split(' ')
          classes << "form-group"
          classes << "has-error" if errors?
          classes.join(' ')
        end

        def bootstrap_wrapping(&block)
          puts "DEBUG: In bootstrap_wrapping for #{self.class.name} with method #{method}"
          
          label_output = label_html
          puts "DEBUG: Label output: #{label_output}"
          
          input_span_content = template.content_tag(:span, :class => 'form-wrapper') do
            input_cont = input_content(&block)
            puts "DEBUG: Input content: #{input_cont}"
            hint = hint_html(:block)
            error = error_html(:block)
            (input_cont + hint + error).html_safe
          end
          
          puts "DEBUG: Input span content: #{input_span_content}"
          
          full_output = form_group_wrapping do
            label_output + input_span_content
          end
          
          puts "DEBUG: Full output: #{full_output.gsub(/\n/, '\\n')}"
          
          full_output
        end

        def input_content(&block)
          content = [
            add_on_content(options[:prepend]),
            options[:prepend_content],
            yield,
            add_on_content(options[:append]),
            options[:append_content]
          ].compact.join("\n").html_safe

          if prepended_or_appended?(options)
            template.content_tag(:div, content, :class => add_on_wrapper_classes(options).join(" "))
          else
            content
          end
        end

        def prepended_or_appended?(options)
          options[:prepend] || options[:prepend_content] || options[:append] || options[:append_content]
        end

        def add_on_content(content)
          return nil unless content
          template.content_tag(:span, content, :class => 'input-group-addon')
        end

        def form_group_wrapping(&block)
          captured_block = template.capture(&block).html_safe
          options = wrapper_html_options
          result = template.content_tag(:div,
            captured_block,
            options
          )
          result
        end

        def add_on_wrapper_classes(options)
          [:prepend, :append, :prepend_content, :append_content].find do |key|
            options.has_key?(key)
          end ? ['input-group'] : []
        end

      end
    end
  end
end
