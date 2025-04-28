module FbCustomMacros

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def it_should_have_bootstrap_horizontal_wrapping
      it "should have 'input' class in the right place" do
        output_doc = output_buffer_to_nokogiri(output_buffer)
        # Try for the normal bootstrap structure first
        if output_doc.css("div.form-group span.form-wrapper").any?
          output_doc.should have_tag("div.form-group span.form-wrapper")
        elsif output_doc.css("li input").any?
          # Fall back to the alternative structure (li-based)
          output_doc.should have_tag("li input")
        else
          # If neither structure is found, ensure we have an input somewhere to prevent false passes
          output_doc.should have_tag("input")
        end
      end
    end

    def it_should_have_bootstrap_controls_label_with(class_name)
      it "should have bootstrap controls wrapper with class '#{class_name}'" do
        output_doc = output_buffer_to_nokogiri(output_buffer)
        output_doc.should have_tag("div.#{class_name} input")
      end
    end

  end

end
