require 'bundler/setup'
require 'pry'
require 'rspec'
require 'active_record'
require 'rails'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# Find Formtastic and grab its testing support first.
formtastic_full_gem_path = Bundler.load.specs.find{|s| s.name == "formtastic" }.full_gem_path
full_path = File.join(formtastic_full_gem_path, 'spec', 'spec_helper.rb')
puts "full path: #{full_path}"
require full_path

# Now add in ours.
require 'formtastic-bootstrap'
Dir[File.join(File.dirname(__FILE__), "support", "**/*.rb")].each { |f| require f }

# Helper method to convert the output buffer to a Nokogiri document
def output_buffer_to_nokogiri(output_buffer)
  buffer_content = output_buffer.respond_to?(:to_s) ? output_buffer.to_s : output_buffer.to_str
  Nokogiri::HTML::DocumentFragment.parse(buffer_content)
end

# Helper method for RSpec error matchers
def errors_matcher(method_name)
  method_name
end

RSpec.configure do |config|
  config.before(:each) do
    Formtastic::Helpers::FormHelper.builder = FormtasticBootstrap::FormBuilder
  end
  config.include FbCustomMacros

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
