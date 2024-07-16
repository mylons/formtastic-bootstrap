# encoding: utf-8
require 'spec_helper'

RSpec.describe 'FormtasticBootstrap::FormBuilder#actions' do

  include FormtasticSpecHelper

  before do
@output_buffer = ActionView::OutputBuffer.new
    mock_everything
  end

  describe 'with a block' do
    describe 'when no options are provided' do
      before do
        concat(semantic_form_for(@new_post) do |builder|
          concat(builder.actions do
            concat('hello')
          end)
        end)
        @output_doc = output_buffer_to_nokogiri(output_buffer)
      end

      it 'should render a fieldset inside the form, with a class of "actions"' do
        @output_doc.should have_tag("form fieldset.form-actions")
      end

      it 'should not render an ol inside the fieldset' do
        @output_doc.should_not have_tag("form fieldset.form-actions ol")
      end

      it 'should render the contents of the block inside the fieldset' do
        @output_doc.should have_tag("form fieldset.form-actions", /hello/)
      end

      it 'should not render a legend inside the fieldset' do
        @output_doc.should_not have_tag("form fieldset.form-actions legend")
      end
    end

    describe 'when a :name option is provided' do
      before do
        @legend_text = "Advanced options"

        concat(semantic_form_for(@new_post) do |builder|
          builder.actions :name => @legend_text do
          end
        end)

        @output_doc = output_buffer_to_nokogiri(output_buffer)
      end
      it 'should render a fieldset inside the form' do
        @output_doc.should have_tag("form fieldset.form-actions legend", /#{@legend_text}/)
      end
    end

    describe 'when other options are provided' do
      before do
        @id_option = 'advanced'
        @class_option = 'wide'

        concat(semantic_form_for(@new_post) do |builder|
          builder.actions :id => @id_option, :class => @class_option do
          end
        end)
        @output_doc = output_buffer_to_nokogiri(output_buffer)
      end
      it 'should pass the options into the fieldset tag as attributes' do
        @output_doc.should have_tag("form fieldset##{@id_option}")
        @output_doc.should have_tag("form fieldset.#{@class_option}")
      end
    end

  end

  describe 'without a block' do

    describe 'with no args (default buttons)' do

      before do
        concat(semantic_form_for(@new_post) do |builder|
          concat(builder.actions)
        end)
        @output_doc = output_buffer_to_nokogiri(output_buffer)
      end

      it 'should render a form' do
        @output_doc.should have_tag('form')
      end

      it 'should render an actions fieldset inside the form' do
        @output_doc.should have_tag('form fieldset.form-actions')
      end

      it 'should not render a legend in the fieldset' do
        @output_doc.should_not have_tag('form fieldset.form-actions legend')
      end

      it 'should not render an ol in the fieldset' do
        @output_doc.should_not have_tag('form fieldset.form-actions ol')
      end

      it 'should render a button in the fieldset for each default action' do
        @output_doc.should have_tag('form fieldset.form-actions input.btn', :count => 1)
      end

    end

    describe 'with button names as args' do

      before do
        concat(semantic_form_for(@new_post) do |builder|
          concat(builder.actions(:submit, :cancel, :reset))
        end)
        @output_doc = output_buffer_to_nokogiri(output_buffer)
      end

      it 'should not render a form with a fieldset containing a list item for each button arg' do
        @output_doc.should_not have_tag('form > fieldset.form-actions > ol > li.action', :count => 3)
      end

      it 'should render a form with a fieldset containing each button arg' do
        @output_doc.should_not have_tag('form > fieldset.form-actions > input.btn', :count => 3)
      end

    end

    describe 'with button names as args and an options hash' do

     before do
       concat(semantic_form_for(@new_post) do |builder|
         concat(builder.actions(:submit, :cancel, :reset, :name => "Now click a button", :id => "my-id"))
       end)
       @output_doc = output_buffer_to_nokogiri(output_buffer)
     end

     it 'should render a form with a fieldset containing each button arg' do
       @output_doc.should have_tag('form > fieldset.form-actions > .btn', :count => 3)
     end

     it 'should pass the options down to the fieldset' do
       @output_doc.should have_tag('form > fieldset#my-id.form-actions')
     end

     it 'should use the special :name option as a text for the legend tag' do
       @output_doc.should have_tag('form > fieldset#my-id.form-actions > legend', /Now click a button/)
     end

    end

  end

end

