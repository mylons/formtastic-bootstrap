# encoding: utf-8
require 'spec_helper'

RSpec.describe 'ButtonAction', 'when submitting' do

  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.action(:submit, :as => :button))
    end)
  end

  it 'should render a submit type of button' do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('button[@type="submit"].btn')
  end

end

RSpec.describe 'ButtonAction', 'when resetting' do

  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.action(:reset, :as => :button))
    end)
  end

  it 'should render a reset type of button' do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('button[@type="reset"].btn', :text => "Reset Post")
  end

  it 'should not render a value attribute' do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should_not have_tag('button[@value].btn')
  end

end

RSpec.describe 'InputAction', 'when cancelling' do

  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything
  end

  it 'should raise an error' do
    lambda {
      concat(semantic_form_for(@new_post) do |builder|
        concat(builder.action(:cancel, :as => :button))
      end)
    }.should raise_error(Formtastic::UnsupportedMethodForAction)
  end

end
