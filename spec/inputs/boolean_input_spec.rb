# encoding: utf-8
require 'spec_helper'

RSpec.describe 'boolean input' do

  include FormtasticSpecHelper

  before do
    @output_buffer = ActionView::OutputBuffer.new
    mock_everything

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:allow_comments, :as => :boolean))
    end)
  end

  it_should_have_bootstrap_horizontal_wrapping
  it_should_have_bootstrap_controls_label_with("checkbox")
  it_should_have_input_wrapper_with_class("boolean")
  it_should_have_input_wrapper_with_class(:input)
  it_should_have_input_wrapper_with_id("post_allow_comments_input")
  it_should_apply_error_logic_for_input_type(:boolean)

  it 'should generate a label containing the input' do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should_not have_tag('label.label')
    output_doc.should have_tag('form div.form-group span.form-wrapper label', count: 1)
    output_doc.should have_tag('form div.form-group span.form-wrapper label.control-label', count: 1)
    output_doc.should have_tag('form div.form-group span.form-wrapper label[@for="post_allow_comments"]')
    output_doc.should have_tag('form div.form-group span.form-wrapper label', /Allow comments/)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@type="checkbox"]', count: 1)
    output_doc.should have_tag('form div.form-group input[@type="hidden"]', count: 1)
    output_doc.should_not have_tag('form div.form-group span.form-wrapper label input[@type="hidden"]', count: 1) # invalid HTML5
  end

  it 'should not add a "name" attribute to the label' do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should_not have_tag('form div.form-group span.form-wrapper label[@name]')
  end

  it 'should generate a checkbox input' do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input')
    output_doc.should have_tag('form div.form-group span.form-wrapper label input#post_allow_comments')
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@type="checkbox"]')
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@name="post[allow_comments]"]')
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@type="checkbox"][@value="1"]')
  end

  it 'should generate a checked input if object.method returns true' do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@checked="checked"]')
    output_doc.should have_tag('form div.form-group input[@name="post[allow_comments]"]', :count => 2)
    output_doc.should have_tag('form div.form-group span.form-wrapper input#post_allow_comments', :count => 1)
  end

  it 'should generate a checked input if :input_html is passed :checked => checked' do
    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:answer_comments, :as => :boolean, :input_html => {:checked => 'checked'}))
    end)
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@checked="checked"]')
  end

  it 'should name the hidden input with the :name html_option' do
    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:answer_comments, :as => :boolean, :input_html => { :name => "foo" }))
    end)

    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group input[@type="checkbox"][@name="foo"]', :count => 1)
    output_doc.should have_tag('form div.form-group input[@type="hidden"][@name="foo"]', :count => 1)
  end

  it 'should name the hidden input with the :name html_option' do
    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:answer_comments, :as => :boolean, :input_html => { :name => "foo" }))
    end)

    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group input[@type="checkbox"][@name="foo"]', :count => 1)
    output_doc.should have_tag('form div.form-group input[@type="hidden"][@name="foo"]', :count => 1)
  end

  it "should generate a disabled input and hidden input if :input_html is passed :disabled => 'disabled' " do
    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:allow_comments, :as => :boolean, :input_html => {:disabled => 'disabled'}))
    end)
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group label.control-label input[@disabled="disabled"]', :count => 1)
    output_doc.should have_tag('form div.form-group input[@type="hidden"][@disabled="disabled"]', :count => 1)
  end

  it 'should generate an input[id] with matching label[for] when id passed in :input_html' do
    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:allow_comments, :as => :boolean, :input_html => {:id => 'custom_id'}))
    end)
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@id="custom_id"]')
    output_doc.should have_tag('form div.form-group span.form-wrapper label[@for="custom_id"]')
  end

  it 'should allow checked and unchecked values to be sent' do
    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:allow_comments, :as => :boolean, :checked_value => 'checked', :unchecked_value => 'unchecked'))
    end)
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@type="checkbox"][@value="checked"]:not([@unchecked_value][@checked_value])')
    output_doc.should have_tag('form div.form-group input[@type="hidden"][@value="unchecked"]')
    output_doc.should_not have_tag('form div.form-group span.form-wrapper label input[@type="hidden"]') # invalid HTML5
  end

  it 'should generate a checked input if object.method returns checked value' do
    @new_post.stub(:allow_comments).and_return('yes')

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:allow_comments, :as => :boolean, :checked_value => 'yes', :unchecked_value => 'no'))
    end)

    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@type="checkbox"][@value="yes"][@checked="checked"]')
  end

  it 'should not generate a checked input if object.method returns unchecked value' do
    @new_post.stub(:allow_comments).and_return('no')

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:allow_comments, :as => :boolean, :checked_value => 'yes', :unchecked_value => 'no'))
    end)

    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@type="checkbox"][@value="yes"]:not([@checked])')
  end

  it 'should generate a checked input if object.method returns checked value' do
    @new_post.stub(:allow_comments).and_return('yes')

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:allow_comments, :as => :boolean, :checked_value => 'yes', :unchecked_value => 'no'))
    end)

    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@type="checkbox"][@value="yes"][@checked="checked"]')
  end

  it 'should not generate a checked input if object.method returns unchecked value' do
    @new_post.stub(:allow_comments).and_return('no')

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:allow_comments, :as => :boolean, :checked_value => 'yes', :unchecked_value => 'no'))
    end)

    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@type="checkbox"][@value="yes"]:not([@checked])')
  end

  it 'should generate a label and a checkbox even if no object is given' do
    concat(semantic_form_for(:project, :url => 'http://test.host') do |builder|
      concat(builder.input(:allow_comments, :as => :boolean))
    end)

    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('form div.form-group span.form-wrapper label[@for="project_allow_comments"]')
    output_doc.should have_tag('form div.form-group span.form-wrapper label', /Allow comments/)
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@type="checkbox"]')

    output_doc.should have_tag('form div.form-group span.form-wrapper label input#project_allow_comments')
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@type="checkbox"]')
    output_doc.should have_tag('form div.form-group span.form-wrapper label input[@name="project[allow_comments]"]')
  end

  it "should render hints" do
    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.input(:allow_comments, :as => :boolean, :hint => 'Allow user to post comment'))
    end)
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag("form div.form-group span.form-wrapper span.help-block")
  end

  context "when required" do

    it "should add the required attribute to the input's html options" do
      with_config :use_required_attribute, true do
        concat(semantic_form_for(@new_post) do |builder|
          concat(builder.input(:title, :as => :boolean, :required => true))
        end)
        output_doc = output_buffer_to_nokogiri(output_buffer)
        output_doc.should have_tag("input[@required]")
      end
    end

    it "should not add the required attribute to the boolean fields input's html options" do
      with_config :use_required_attribute, true do
        concat(semantic_form_for(@new_post) do |builder|
          concat(builder.input(:title, :as => :boolean))
        end)
        output_doc = output_buffer_to_nokogiri(output_buffer)
        output_doc.should_not have_tag("input[@required]")
      end
    end

  end

  describe "when namespace is provided" do

    before do
      @output_buffer = ActionView::OutputBuffer.new
      mock_everything

      concat(semantic_form_for(@new_post, :namespace => "context2") do |builder|
        concat(builder.input(:allow_comments, :as => :boolean))
      end)
    end

    it_should_have_input_wrapper_with_id("context2_post_allow_comments_input")
    it_should_have_an_inline_label_for("context2_post_allow_comments")

  end

  describe "when index is provided" do

    before do
      @output_buffer = ActionView::OutputBuffer.new
      mock_everything

      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.fields_for(:author, :index => 3) do |author|
          concat(author.input(:name, :as => :boolean))
        end)
      end)
      @output_doc = output_buffer_to_nokogiri(output_buffer)
    end

    it 'should index the id of the wrapper' do
      @output_doc.should have_tag("div#post_author_attributes_3_name_input")
    end

    it 'should index the id of the input tag' do
      @output_doc.should have_tag("input#post_author_attributes_3_name")
    end

    it 'should index the name of the hidden input' do
      @output_doc.should have_tag("input[@type='hidden'][@name='post[author_attributes][3][name]']")
    end

    it 'should index the name of the checkbox input' do
      @output_doc.should have_tag("input[@type='checkbox'][@name='post[author_attributes][3][name]']")
    end

  end

end
