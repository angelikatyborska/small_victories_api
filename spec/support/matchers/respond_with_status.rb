require 'rspec/expectations'

RSpec::Matchers.define :respond_with_status do |expected|
  match do |actual|
    actual.status == expected
  end

  failure_message do |actual|
    "expected response status to equal #{ expected }, got #{ actual.status }"
  end

  failure_message_when_negated do |actual|
    "expected response status not to equal #{ expected }"
  end

  description do
    "respond with status #{ expected }"
  end
end
