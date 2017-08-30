RSpec::Matchers.define :have_content_type do |expected|
  match do |actual|
    begin
      actual.content_type == content_type(expected)
    rescue ArgumentError
      false
    end
  end
  
  failure_message do |actual|
    sprintf('Expected "%s (%s)" to be Content Type "%s" (%s)',
      content_type(actual.content_type),
      actual.content_type,
      content_type(expected),
      expected
    )
  end
  
  failure_message_when_negated do |actual|
    sprintf('Expected "%s (%s)" to not be Content Type "%s" (%s)',
      content_type(actual.content_type),
      actual.content_type,
      content_type(expected),
      expected
    )
  end
  
  def content_type(type)
    types = {
      html: "text/html",
      json: "application/json"
    }
    types[type.try(:to_sym)] || "unknown content type"
  end
end
