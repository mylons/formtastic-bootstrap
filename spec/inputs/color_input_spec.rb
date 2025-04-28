# encoding: utf-8
require 'spec_helper'

# TODO find a way to make those tests pass,
# by somehow including color_field form helper (rails 4+)
RSpec.describe 'color input' do
  include FormtasticSpecHelper

  before do
    @output_buffer = ActionView::OutputBuffer.new
    mock_everything
  end

  describe "when object is provided" do
    before do
      @output_buffer = ActionView::OutputBuffer.new
      mock_everything

      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.input(:color, :as => :color))
      end)
    end

    it_should_have_bootstrap_horizontal_wrapping
    it_should_have_input_wrapper_with_class(:color)
    it_should_have_input_wrapper_with_class(:input)
    it_should_have_input_wrapper_with_class(:stringish)
    it_should_have_input_wrapper_with_id("post_color_input")
    it_should_have_label_with_text(/Color/)
    it_should_have_label_for("post_color")
    it_should_have_input_with_id("post_color")
    it_should_have_input_with_type(:color)
    it_should_have_input_with_name("post[color]")
    it 'should apply custom input attributes when input_html provided' do
      @output_buffer = ActionView::OutputBuffer.new

      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.input(:color, :as => :color, :input_html => { :class => 'myclass' }))
      end)

      output_doc = output_buffer_to_nokogiri(output_buffer)

      output_doc.should have_tag("form div.form-group span.form-wrapper input[type='color'].myclass")
    end
    it_should_apply_custom_for_to_label_when_input_html_id_provided(:color, :color)
    it_should_apply_error_logic_for_input_type(:color)

    describe 'and its a ActiveModel' do
      let(:default_maxlength) { 50 }

      before do
        @new_post.stub(:class).and_return(::PostModel)
      end

      after do
        @new_post.stub(:class).and_return(::Post)
      end
    end
  end

  describe "when namespace is provided" do

    before do
      concat(semantic_form_for(@new_post, :namespace => 'context2') do |builder|
        concat(builder.input(:color, :as => :color))
      end)
    end

    it_should_have_input_wrapper_with_id("context2_post_color_input")
    it_should_have_label_and_input_with_id("context2_post_color")

  end

  describe "when index is provided" do

    before do
@output_buffer = ActionView::OutputBuffer.new
      mock_everything

      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.fields_for(:author, :index => 3) do |author|
          concat(author.input(:name, :as => :color))
        end)
      end)
    end

    it 'should index the id of the wrapper' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("div#post_author_attributes_3_name_input")
    end

    it 'should index the id of the select tag' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("input#post_author_attributes_3_name")
    end

    it 'should index the name of the select tag' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("input[@name='post[author_attributes][3][name]']")
    end

  end


  describe "when no object is provided" do
    before do
      concat(semantic_form_for(:project, :url => 'http://test.host/') do |builder|
        concat(builder.input(:color, :as => :color))
      end)
    end

    it_should_have_label_with_text(/Color/)
    it_should_have_label_for("project_color")
    it_should_have_input_with_id("project_color")
    it_should_have_input_with_type(:color)
    it_should_have_input_with_name("project[color]")
  end

  describe "when size is nil" do
    before do
      concat(semantic_form_for(:project, :url => 'http://test.host/') do |builder|
        concat(builder.input(:color, :as => :color, :input_html => {:size => nil}))
      end)
    end

    it "should have no size attribute" do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should_not have_tag("input[@size]")
    end
  end

  describe "when required" do

    context "and configured to use HTML5 attribute" do
      it "should add the required attribute to the input's html options" do
        with_config :use_required_attribute, true do
          concat(semantic_form_for(@new_post) do |builder|
            concat(builder.input(:color, :as => :color, :required => true))
          end)
          output_doc = output_buffer_to_nokogiri(output_buffer)
          output_doc.should have_tag("input[@required]")
        end
      end
    end

    context "and configured to not use HTML5 attribute" do
      it "should add the required attribute to the input's html options" do
        with_config :use_required_attribute, false do
          concat(semantic_form_for(@new_post) do |builder|
            concat(builder.input(:color, :as => :color, :required => true))
          end)
          output_doc = output_buffer_to_nokogiri(output_buffer)
          output_doc.should_not have_tag("input[@required]")
        end
      end
    end

  end

end
