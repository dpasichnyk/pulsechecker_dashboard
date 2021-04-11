#
# Orignally from: attr_accessor_matchers.rb:
#   https://gist.github.com/itspriddle/1005075/0c0548cf8b6e492987d491988806c3d6abc5fa70.
#

# Validate for a "true" attr accessor. Stored value is then read back and must match the value.
RSpec::Matchers.define :have_attr_accessor do |attr, value = '*'|
  match do |object|
    begin
      object.public_send("#{attr}=", value)
      object.send("#{attr}") == value
    rescue NoMethodError => e
      if e.message.match /`#{attr}[=]{,1}'/
        false
      else
        # Misformatted error, re-raise.
        raise e
      end
    end
  end

  description do
    "have attr_accessor :#{attr}"
  end
end

RSpec::Matchers.define :have_attr_writer do |attr, value = '*'|
  match do |object|
    begin
      object.public_send("#{attr}=", value)
      true
    rescue NoMethodError => e
      if e.message.match /`#{attr}='/
        false
      else
        # Misformatted error, re-raise.
        raise e
      end
    end
  end

  description do
    "have attr_writer :#{attr}"
  end
end
