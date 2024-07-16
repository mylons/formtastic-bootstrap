require 'spec_helper'

RSpec.describe 'deprecated time, datetime and date inputs' do
  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything
  end

  it 'should warn :time is deprecated' do
    ::ActiveSupport::Deprecation.should_receive(:warn)
    semantic_form_for(@new_post) do |f|
      concat(f.input :created_at, :as => :time)
    end
  end

  it 'should warn :datetime is deprecated' do
    ::ActiveSupport::Deprecation.should_receive(:warn)
    semantic_form_for(@new_post) do |f|
      concat(f.input :created_at, :as => :datetime)
    end
  end

  it 'should warn :date is deprecated' do
    ::ActiveSupport::Deprecation.should_receive(:warn)
    semantic_form_for(@new_post) do |f|
      concat(f.input :created_at, :as => :date)
    end
  end

  it 'should use wrapper css class based off :as, not off their parent class' do
    with_deprecation_silenced do
      concat(semantic_form_for(@new_post) do |f|
        concat(f.input :created_at, :as => :time)
        concat(f.input :created_at, :as => :datetime)
        concat(f.input :created_at, :as => :date)
      end)
    end
    output_doc = output_buffer_to_nokogiri(output_buffer)
    output_doc.should have_tag('div.form-group.time')
    output_doc.should have_tag('div.form-group.datetime')
    output_doc.should have_tag('div.form-group.date')
    output_doc.should_not have_tag('li.time_select')
    output_doc.should_not have_tag('li.datetime_select')
    output_doc.should_not have_tag('li.date_select')
  end

end
