require 'rspec/expectations'

RSpec::Matchers.define :respond_with_keys do |expected|
  match do |actual|
    parsed = JSON.parse(actual.body)
    single_object = parsed.is_a?(Array) ? parsed[0] : parsed

    expected.each do |key|
      if key.is_a? Hash
        key.each do | key, keys |
          keys.each do |inner_key|
            if inner_key.is_a? Hash
              fail ArgumentError.new 'Matcher respond_with_keys only supports one level of nesting'
            end

            return false unless single_object[key.to_s].keys.include? inner_key.to_s
          end
        end
      else
        return false unless single_object.keys.include? key.to_s
      end
    end

    true
  end

  failure_message do |actual|
    parsed = JSON.parse(actual.body)
    single_object = parsed.is_a?(Array) ? parsed[0] : parsed

    "expected #{ single_object.keys.to_s } to equal #{ expected.to_s }"
  end

  failure_message_when_negated do |actual|
    parsed = JSON.parse(actual.body)
    single_object = parsed.is_a?(Array) ? parsed[0] : parsed

    "expected #{ single_object.keys.to_s } not to equal #{ expected.to_s }"
  end

  description do
    "respond with record(s) with keys: #{ expected.to_s }"
  end
end
