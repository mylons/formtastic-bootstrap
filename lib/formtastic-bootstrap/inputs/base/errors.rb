module FormtasticBootstrap
  module Inputs
    module Base
      module Errors

        include Formtastic::Inputs::Base::Errors

        def error_html(inline_or_block = :inline)
          errors? ? send(:"error_#{builder.inline_errors}_html", inline_or_block) : ""
        end

        def error_sentence_html(inline_or_block)
          error_class = if inline_or_block == :inline
            options[:error_class] || builder.default_inline_error_class
          else
            options[:error_class] || builder.default_block_error_class
          end
          template.content_tag(:span, errors.to_sentence.html_safe, :class => error_class)
        end

        def error_list_html(ignore)
          super()
        end

        def error_first_html(inline_or_block = :inline)
          error_class = if inline_or_block == :inline
            options[:error_class] || builder.default_inline_error_class
          else
            options[:error_class] || builder.default_block_error_class
          end
          template.content_tag(:span, errors.first.untaint.html_safe, :class => error_class)
        end

        def error_none_html(ignore)
          # super
          ""
        end

      end
    end
  end
end
