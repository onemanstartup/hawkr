# frozen_string_literal: true

require 'json'
require 'json_schema'

RSpec::Matchers.define :match_response do |_schema|
  match do |model|
    file_path = Pathname.new(example.metadata[:absolute_file_path])
    schema_path = file_path.sub(/#{File.extname(file_path)}$/, '.json')
    schema_data = JSON.parse(File.read(schema_path))
    schema = JsonSchema.parse!(schema_data)

    response = if model.is_a?(String)
                 JSON.parse(model)
               else
                 JSON.parse(model.to_json)
               end

    begin
      @result = schema.validate!(response)
    rescue StandardError => e
      p e
      raise
    end
    true
  end

  failure_message do |actual|
    "expected that #{actual.to_json} would match #{expected.to_json}"
  end
end
