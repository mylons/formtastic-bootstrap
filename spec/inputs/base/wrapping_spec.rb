require 'spec_helper'

RSpec.describe "wrapped input" do
  include FormtasticSpecHelper

  before do
    @output_buffer = ActionView::OutputBuffer.new
    mock_everything

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:body, {:as => :text}.merge(options) ))
    end)
    @output_doc = output_buffer_to_nokogiri(output_buffer)
  end

  describe "text add ons" do
    context "when appened with append option" do
      let(:options) { { :append => "text appended in addon"} }

      it "should have the appended text to the input in an addon span" do
        @output_doc.should have_tag("form div.input-group textarea + span.input-group-addon", "text appended in addon")
      end
    end

    context "when prepended with prepend option" do
      let(:options) { { :prepend => "text prepended in addon"} }

      it "should have the prepended text to the input in an addon span" do
        @output_doc.should have_tag("form div.input-group span.input-group-addon", "text prepended in addon")
        @output_doc.should have_tag("form div.input-group span.input-group-addon + textarea")
      end
    end

    context "when prepended and appened with prepend and append options" do
      let(:options) { { :prepend => "text prepended in addon", :append => "text appended in addon"} }

      it "should have the prepended text to the input in an addon span" do
        @output_doc.should have_tag("form div.input-group textarea + span.input-group-addon", "text appended in addon")
        @output_doc.should have_tag("form div.input-group span.input-group-addon", "text prepended in addon")
        @output_doc.should have_tag("form div.input-group span.input-group-addon + textarea")
      end
    end
  end

  describe "content add ons" do
    context "when appended with append_content option" do
      let(:options) { { :append_content => content_tag(:a, "button appended", :class => "btn")} }

      it "should have the appended text to the input in an addon span" do
        @output_doc.should have_tag("form div.input-group a.btn", "button appended")
        @output_doc.should_not have_tag("form div.input-group span.input-group-addon")
      end
    end

    context "when prepended with prepend_content option" do
      let(:options) { { :prepend_content => content_tag(:a, "button prepended", :class => "btn")} }

      it "should have the prepended text to the input in an addon span" do
        @output_doc.should have_tag("form div.input-group a.btn", "button prepended")
        @output_doc.should_not have_tag("form div.input-group span.input-group-addon")
      end
    end

    context "when prepended and appened with prepend and append options" do
      let(:options) { { :prepend_content => content_tag(:a, "button prepended", :class => "btn"), :append_content => content_tag(:a, "button appended", :class => "btn")} }

      it "should have the prepended text to the input in an addon span" do
        @output_doc.should have_tag("form div.input-group a.btn", "button prepended")
        @output_doc.should have_tag("form div.input-group a.btn", "button appended")
      end
    end

  end
end
