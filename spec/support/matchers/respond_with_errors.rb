require 'rspec/expectations'

RSpec::Matchers.define :respond_with_errors do |expected|
  match do |actual|
    actual_sorted = JSON.parse(actual.body)['errors'].sort
    expected_sorted = expected.sort

    actual_sorted.each_with_index.all? do |error, index|
      error.symbolize_keys == expected_sorted[index].symbolize_keys
    end
  end

  failure_message do |actual|
    "expected #{ JSON.parse(actual.body)['errors'].to_s } to equal #{ expected.to_s }"
  end

  failure_message_when_negated do |actual|
    "expected #{ JSON.parse(actual.body)['errors'].to_s } not to equal #{ expected.to_s }"
  end

  description do
    "respond with errors: #{ expected.to_s }"
  end
end
