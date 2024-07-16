# encoding: utf-8
require 'spec_helper'

RSpec.describe 'LinkAction', 'when cancelling' do

  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything
  end

  context 'without a :url' do
    before do
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.action(:cancel, :as => :link))
      end)
    end

    it 'should render a submit type of input' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag('a[@href="javascript:history.back()"].btn')
    end

  end

  context 'with a :url as String' do

    before do
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.action(:cancel, :as => :link, :url => "http://foo.bah/baz"))
      end)
    end

    it 'should render a submit type of input' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag('a[@href="http://foo.bah/baz"].btn')
    end

  end

  context 'with a :url as Hash' do

    before do
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.action(:cancel, :as => :link, :url => { :action => "foo" }))
      end)
    end

    it 'should render a submit type of input' do
      output_doc = output_buffer_to_nokogiri(output_buffer)
      output_doc.should have_tag('a[@href="/mock/path"].btn')
    end

  end

end

RSpec.describe 'LinkAction', 'when submitting' do

  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything
  end

  it 'should raise an error' do
    lambda {
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.action(:submit, :as => :link))
      end)
    }.should raise_error(Formtastic::UnsupportedMethodForAction)
  end

end

RSpec.describe 'LinkAction', 'when submitting' do

  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything
  end

  it 'should raise an error' do
    lambda {
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.action(:reset, :as => :link))
      end)
    }.should raise_error(Formtastic::UnsupportedMethodForAction)
  end

end
