require 'spec_helper'

RSpec.describe 'check_boxes input' do
  include FormtasticSpecHelper

  before do
    @output_buffer = ActionView::OutputBuffer.new
  end

  describe "with a has_many association" do
    describe "and no object is given" do
      it 'should html escape the label string' do
        form = semantic_form_for(:project, url: 'http://test.host') do |builder|
          builder.input(:author_id, as: :check_boxes, collection: [["<b>Item 1</b>", 1], ["<b>Item 2</b>", 2]])
        end

        output_doc = output_buffer_to_nokogiri(form)

        labels = output_doc.css('div.check_boxes.form-group span.form-wrapper label.choice')

        expect(labels.size).to eq(2)

        labels.each_with_index do |label, index|
          expect(label.inner_html).to include('&lt;b&gt;Item')
          expect(label.inner_html).to include("Item #{index + 1}")
        end
      end
    end
  end
end
