# encoding: utf-8
require 'spec_helper'

RSpec.describe 'radio input' do

  include FormtasticSpecHelper

  before do
    @output_buffer = ActionView::OutputBuffer.new
    mock_everything
  end

  describe 'for belongs_to association' do
    before do
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.input(:author, :as => :radio, :value_as_class => true, :required => true))
      end)
    end

    it_should_have_bootstrap_horizontal_wrapping
    it_should_have_input_wrapper_with_class("radio_buttons")
    it_should_have_input_wrapper_with_class(:input)
    it_should_have_input_wrapper_with_id("post_author_input")
    # it_should_have_a_nested_fieldset
    # it_should_have_a_nested_fieldset_with_class('choices')
    # it_should_have_a_nested_ordered_list_with_class('choices-group')
    it_should_apply_error_logic_for_input_type(:radio)
    it_should_use_the_collection_when_provided(:radio, 'input')

    it 'should generate a control label with text for the input' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag('form div.form-group label.control-label')
      output_doc.should have_tag('form div.form-group label.control-label', /Author/)
    end

    it 'should have one option with a "checked" attribute' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag('form div.form-group span.form-wrapper input[@checked]', :count => 1)
    end

    describe "each choice" do

      it 'should not give the choice label the .label class' do
        output_doc = output_buffer_to_nokogiri(output_buffer)
        output_doc.should_not have_tag('span.form-wrapper label.label')
      end

      it 'should not add the required attribute to each input' do
        output_doc = output_buffer_to_nokogiri(output_buffer)
        output_doc.should_not have_tag('span.form-wrapper input[@required]')
      end


      it 'should contain a label for the radio input with a nested input and label text' do
        ::Author.all.each do |author|
          output_doc = output_buffer_to_nokogiri(output_buffer)
          output_doc.should have_tag('form div.form-group span.form-wrapper label', /#{author.to_label}/)
          output_doc.should have_tag("form div.form-group span.form-wrapper label[@for='post_author_id_#{author.id}']")
        end
      end

      it 'should use values as li.class when value_as_class is true' do
        ::Author.all.each do |author|
          output_doc = output_buffer_to_nokogiri(output_buffer)
          output_doc.should have_tag("form div.form-group span.form-wrapper label.author_#{author.id}")
        end
      end

      it "should have a radio input" do
        ::Author.all.each do |author|
          output_doc = output_buffer_to_nokogiri(output_buffer)
          output_doc.should have_tag("form div.form-group span.form-wrapper label input#post_author_id_#{author.id}")
          output_doc.should have_tag("form div.form-group span.form-wrapper label input[@type='radio']")
          output_doc.should have_tag("form div.form-group span.form-wrapper label input[@value='#{author.id}']")
          output_doc.should have_tag("form div.form-group span.form-wrapper label input[@name='post[author_id]']")
        end
      end

      it "should mark input as checked if it's the the existing choice" do
        @new_post.author_id.should == @bob.id
        @new_post.author.id.should == @bob.id
        @new_post.author.should == @bob

        concat(semantic_form_for(@new_post) do |builder|
          concat(builder.input(:author, :as => :radio))
        end)

        output_doc = output_buffer_to_nokogiri(output_buffer)
        output_doc.should have_tag("form div.form-group span.form-wrapper label input[@checked='checked']")
      end

      it "should mark the input as disabled if options attached for disabling" do
        concat(semantic_form_for(@new_post) do |builder|
          concat(builder.input(:author, :as => :radio, :collection => [["Test", 'test'], ["Try", "try", {:disabled => true}]]))
        end)

        output_doc = output_buffer_to_nokogiri(output_buffer)
        output_doc.should_not have_tag("form div.form-group span.form-wrapper label input[@value='test'][@disabled='disabled']")
        output_doc.should have_tag("form div.form-group span.form-wrapper label input[@value='try'][@disabled='disabled']")
      end

      it "should not contain invalid HTML attributes" do

        concat(semantic_form_for(@new_post) do |builder|
          concat(builder.input(:author, :as => :radio))
        end)

        output_doc = output_buffer_to_nokogiri(output_buffer)
        output_doc.should_not have_tag("form li fieldset ol li input[@find_options]")
      end

    end

    describe 'and no object is given' do
      before do
        @output_buffer = ActionView::OutputBuffer.new

        concat(semantic_form_for(:project, :url => 'http://test.host') do |builder|
          concat(builder.input(:author_id, :as => :radio, :collection => ::Author.all))
        end)
      end

      it 'should generate labels for each item' do
        ::Author.all.each do |author|
          output_doc = output_buffer_to_nokogiri(output_buffer)
          output_doc.should have_tag('form div.form-group span.form-wrapper label', /#{author.to_label}/)
          output_doc.should have_tag("form div.form-group span.form-wrapper label[@for='project_author_id_#{author.id}']")
        end
      end

      it 'should html escape the label string' do
        concat(semantic_form_for(:project, :url => 'http://test.host') do |builder|
          concat(builder.input(:author_id, :as => :radio, :collection => [["<b>Item 1</b>", 1], ["<b>Item 2</b>", 2]]))
        end)
        output_doc = output_buffer_to_nokogiri(output_buffer)

        labels = output_doc.css('form div.form-group span.form-wrapper label')
        expect(labels.size).to be >= 2  # Ensure we have at least the two labels we're looking for

        escaped_labels = labels.select { |label| label.text.match?(/Item [12]/) }
        expect(escaped_labels.size).to eq(2)

        escaped_labels.each do |label|
          expect(label.inner_html).to match /&lt;b&gt;Item [12]&lt;\/b&gt;/
        end
      end

      it 'should generate inputs for each item' do
        ::Author.all.each do |author|
          output_doc = output_buffer_to_nokogiri(output_buffer)
          output_doc.should have_tag("form div.form-group span.form-wrapper label input#project_author_id_#{author.id}")
          output_doc.should have_tag("form div.form-group span.form-wrapper label input[@type='radio']")
          output_doc.should have_tag("form div.form-group span.form-wrapper label input[@value='#{author.id}']")
          output_doc.should have_tag("form div.form-group span.form-wrapper label input[@name='project[author_id]']")
        end
      end
    end
  end

  describe "with i18n of the legend label" do

    before do
      ::I18n.backend.store_translations :en, :formtastic => { :labels => { :post => { :authors => "Translated!" }}}

      with_config :i18n_lookups_by_default, true do
        @new_post.stub(:author_ids).and_return(nil)
        concat(semantic_form_for(@new_post) do |builder|
          concat(builder.input(:authors, :as => :radio))
        end)
      end
    end

    after do
      ::I18n.backend.reload!
    end

    it "should do foo" do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("label.control-label", /Translated/)
    end

  end

  describe "when :label option is set" do
    before do
      @new_post.stub(:author_ids).and_return(nil)
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.input(:authors, :as => :radio, :label => 'The authors'))
      end)
    end

    it "should output the correct label title" do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("label.control-label", /The authors/)
    end
  end

  describe "when :label option is false" do
    before do
@output_buffer = ActionView::OutputBuffer.new
      @new_post.stub(:author_ids).and_return(nil)
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.input(:authors, :as => :radio, :label => false))
      end)
    end

    it "should not output the legend" do
      # TODO I think this is not supported in FB.
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should_not have_tag("label.control-label")
      output_doc.should_not include("&gt;")
    end

    it "should not cause escaped HTML" do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should_not include("&gt;")
    end
  end

  describe "when :required option is true" do
    before do
      @new_post.stub(:author_ids).and_return(nil)
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.input(:authors, :as => :radio, :required => true))
      end)
    end

    it "should output the correct label title" do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("label.control-label abbr")
    end
  end

  describe "when :namespace is given on form" do
    before do
      @output_buffer = ActionView::OutputBuffer.new
      @new_post.stub(:author_ids).and_return(nil)
      concat(semantic_form_for(@new_post, :namespace => "custom_prefix") do |builder|
        concat(builder.input(:authors, :as => :radio, :label => ''))
      end)

      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should match(/for="custom_prefix_post_author_ids_(\d+)"/)
      output_doc.should match(/id="custom_prefix_post_author_ids_(\d+)"/)
    end
    it_should_have_input_wrapper_with_id("custom_prefix_post_authors_input")
  end

  describe "when index is provided" do

    before do
      @output_buffer = ActionView::OutputBuffer.new
      mock_everything

      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.fields_for(:author, :index => 3) do |author|
          concat(author.input(:name, :as => :radio))
        end)
      end)
    end

    it 'should index the id of the form-group' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("div.form-group#post_author_attributes_3_name_input")
    end

    it 'should index the id of the select tag' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("input#post_author_attributes_3_name_true")
      output_doc.should have_tag("input#post_author_attributes_3_name_false")
    end

    it 'should index the name of the select tag' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("input[@name='post[author_attributes][3][name]']")
    end

  end

  describe "when collection contains integers" do
    before do
      @output_buffer = ActionView::OutputBuffer.new
      mock_everything

      concat(semantic_form_for(:project) do |builder|
        concat(builder.input(:author_id, :as => :radio, :collection => [1, 2, 3]))
      end)
    end

    it 'should output the correct labels' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag("span.form-wrapper label", /1/)
      output_doc.should have_tag("span.form-wrapper label", /2/)
      output_doc.should have_tag("span.form-wrapper label", /3/)
    end
  end

end
