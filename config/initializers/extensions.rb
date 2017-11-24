Dir[File.join(Rails.root, 'lib', 'extensions', '*.rb')].each { |file| require file }

class String
  include StringExtension
end
