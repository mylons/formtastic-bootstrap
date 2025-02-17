# encoding: utf-8
require 'spec_helper'

RSpec.describe 'time_zone input' do

  include FormtasticSpecHelper

  before do
    @output_buffer = ActionView::OutputBuffer.new
    mock_everything

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:time_zone))
    end)
  end

  it_should_have_bootstrap_horizontal_wrapping
  it_should_have_input_wrapper_with_class("time_zone")
  it_should_have_input_wrapper_with_class(:input)
  it_should_have_input_wrapper_with_id("post_time_zone_input")
  it_should_apply_error_logic_for_input_type(:time_zone)

  it 'should generate a label for the input' do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group label.control-label')
    output_doc.should have_tag('form div.form-group label.control-label[@for="post_time_zone"]')
    output_doc.should have_tag('form div.form-group label.control-label', /Time zone/)
  end

  it "should generate a select" do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag("form div.form-group span.form-wrapper select")
    output_doc.should have_tag("form div.form-group span.form-wrapper select#post_time_zone")
    output_doc.should have_tag("form div.form-group span.form-wrapper select[@name=\"post[time_zone]\"]")
  end

  it 'should use input_html to style inputs' do
    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:time_zone, :input_html => { :class => 'myclass' }))
    end)
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag("form div.form-group span.form-wrapper select.myclass")
  end

  describe "when namespace is provided" do

    before do
      @output_buffer = ActionView::OutputBuffer.new
      mock_everything

      concat(semantic_form_for(@new_post, :namespace => 'context2') do |builder|
        concat(builder.input(:time_zone))
      end)
    end

    it_should_have_input_wrapper_with_id("context2_post_time_zone_input")
    it_should_have_select_with_id("context2_post_time_zone")
    it_should_have_label_for("context2_post_time_zone")

  end

  describe "when index is provided" do

    before do
      @output_buffer = ActionView::OutputBuffer.new
      mock_everything

      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.fields_for(:author, :index => 3) do |author|
          concat(author.input(:name, :as => :time_zone))
        end)
      end)
    end

    it 'should index the id of the control group' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("div.form-group#post_author_attributes_3_name_input")
    end

    it 'should index the id of the select tag' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("select#post_author_attributes_3_name")
    end

    it 'should index the name of the select tag' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("select[@name='post[author_attributes][3][name]']")
    end

  end


  describe 'when no object is given' do
    before do
      concat(semantic_form_for(:project, :url => 'http://test.host/') do |builder|
        concat(builder.input(:time_zone, :as => :time_zone))
      end)
    end

    it 'should generate labels' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag('form div.form-group label.control-label')
      output_doc.should have_tag('form div.form-group label.control-label[@for="project_time_zone"]')
      output_doc.should have_tag('form div.form-group label.control-label', /Time zone/)
    end

    it 'should generate select inputs' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("form div.form-group span.form-wrapper select")
      output_doc.should have_tag("form div.form-group span.form-wrapper select#project_time_zone")
      output_doc.should have_tag("form div.form-group span.form-wrapper select[@name=\"project[time_zone]\"]")
    end
  end

  context "when required" do
    it "should add the required attribute to the input's html options" do
      with_config :use_required_attribute, true do
        concat(semantic_form_for(@new_post) do |builder|
          concat(builder.input(:title, :as => :time_zone, :required => true))
        end)
        output_doc = output_buffer_to_nokogiri(output_buffer)
        output_doc.should have_tag("select[@required]")
      end
    end
  end

end
