require 'spec_helper'

RSpec.describe 'FormtasticBootstrap::FormBuilder#fields_for' do

  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything
    @new_post.stub(:author).and_return(::Author.new)
  end

  context 'outside a form_for block' do
    it 'yields an instance of FormHelper.builder' do
      semantic_fields_for(@new_post) do |nested_builder|
        nested_builder.class.should == Formtastic::Helpers::FormHelper.builder
      end
      semantic_fields_for(@new_post.author) do |nested_builder|
        nested_builder.class.should == Formtastic::Helpers::FormHelper.builder
      end
      semantic_fields_for(:author, @new_post.author) do |nested_builder|
        nested_builder.class.should == Formtastic::Helpers::FormHelper.builder
      end
      semantic_fields_for(:author, @hash_backed_author) do |nested_builder|
        nested_builder.class.should == Formtastic::Helpers::FormHelper.builder
      end
    end

    it 'should respond to input' do
      semantic_fields_for(@new_post) do |nested_builder|
        nested_builder.respond_to?(:input).should == true
      end
      semantic_fields_for(@new_post.author) do |nested_builder|
        nested_builder.respond_to?(:input).should == true
      end
      semantic_fields_for(:author, @new_post.author) do |nested_builder|
        nested_builder.respond_to?(:input).should == true
      end
      semantic_fields_for(:author, @hash_backed_author) do |nested_builder|
        nested_builder.respond_to?(:input).should == true
      end
    end
  end

  context 'within a form_for block' do
    it 'yields an instance of FormHelper.builder' do
      semantic_form_for(@new_post) do |builder|
        builder.semantic_fields_for(:author) do |nested_builder|
          nested_builder.class.should == Formtastic::Helpers::FormHelper.builder
        end
      end
    end

    it 'yields an instance of FormHelper.builder with hash-like model' do
      semantic_form_for(:user) do |builder|
        builder.semantic_fields_for(:author, @hash_backed_author) do |nested_builder|
          nested_builder.class.should == Formtastic::Helpers::FormHelper.builder
        end
      end
    end

    it 'nests the object name' do
      semantic_form_for(@new_post) do |builder|
        builder.semantic_fields_for(@bob) do |nested_builder|
          nested_builder.object_name.should == 'post[author]'
        end
      end
    end

    it 'supports passing collection as second parameter' do
      semantic_form_for(@new_post) do |builder|
        builder.semantic_fields_for(:author, [@fred,@bob]) do |nested_builder|
          nested_builder.object_name.should =~ /post\[author_attributes\]\[\d+\]/
        end
      end
    end

    it 'should sanitize html id for li tag' do
      @bob.stub(:column_for_attribute).and_return(double('column', :type => :string, :limit => 255))
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.semantic_fields_for(@bob, :index => 1) do |nested_builder|
          concat(nested_builder.inputs(:login))
        end)
      end)
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag('form fieldset.inputs #post_author_1_login_input')
      # Not valid selector, so using good ol' regex
      expect(output_doc.to_html).not_to match(/id="post\[author\]_1_login_input"/)
      # <=> output_buffer.should_not have_tag('form fieldset.inputs #post[author]_1_login_input')
    end

    it 'should use namespace provided in nested fields' do
      @bob.stub(:column_for_attribute).and_return(double('column', :type => :string, :limit => 255))
      concat(semantic_form_for(@new_post, :namespace => 'context2') do |builder|
        concat(builder.semantic_fields_for(@bob, :index => 1) do |nested_builder|
          concat(nested_builder.inputs(:login))
        end)
      end)
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag('form fieldset.inputs #context2_post_author_1_login_input')
    end
  end

  context "when I rendered my own hidden id input" do

    before do
      @fred.posts.size.should == 1
      @fred.posts.first.stub(:persisted?).and_return(true)
      @fred.stub(:posts_attributes=)

      concat(semantic_form_for(@fred) do |builder|
        concat(builder.semantic_fields_for(:posts) do |nested_builder|
          concat(nested_builder.input(:id, :as => :hidden))
          concat(nested_builder.input(:title))
        end)
      end)
    end

    it "should only render one hidden input (my one)" do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag 'input#author_posts_attributes_0_id', :count => 1
    end

    it "should render the hidden input inside an div.hidden" do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag 'div.hidden.input input#author_posts_attributes_0_id'
    end
  end

end
