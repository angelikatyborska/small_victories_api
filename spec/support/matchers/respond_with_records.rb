require 'rspec/expectations'

RSpec::Matchers.define :respond_with_records do |expected|
  match do |actual|
    JSON.parse(actual.body).map { |victory| victory['id'] } == expected
  end

  failure_message do |actual|
    "expected #{ JSON.parse(actual.body).map { |victory| victory['id'] }.to_s } to equal #{ expected.to_s }"
  end

  failure_message_when_negated do |actual|
    "expected #{ JSON.parse(actual.body).map { |victory| victory['id'] }.to_s } not to equal #{ expected.to_s }"
  end

  description do
    "respond with records: #{ expected.to_s }"
  end
end
