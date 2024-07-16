# encoding: utf-8
require 'spec_helper'

RSpec.describe 'InputAction', 'when submitting' do

  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.action(:submit, :as => :input))
    end)
  end

  it 'should render a submit type of input' do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('input[@type="submit"].btn')
  end

end

RSpec.describe 'InputAction', 'when resetting' do

  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything

    concat(semantic_form_for(@new_post) do |builder|
      concat(builder.action(:reset, :as => :input))
    end)
  end

  it 'should render a reset type of input' do
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('input[@type="reset"].btn')
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
        concat(builder.action(:cancel, :as => :input))
      end)
    }.should raise_error(Formtastic::UnsupportedMethodForAction)
  end

end
