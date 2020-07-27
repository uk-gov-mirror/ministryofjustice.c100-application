class EmailValidator < ActiveModel::EachValidator
  EMAIL_REGEX = /\A\s*([-\p{L}\d+._]{1,64})@((?:[-\p{L}\d]+\.)+?\p{L}{2,})\s*\z/i
  COMMON_DOMAIN_TYPOS = %w[
    gamil.com
    gmail.con
    gmail.co
    hotmial.com
    hotmail.con
    hotmail.co
  ].freeze

  def validate_each(record, attribute, value)
    if valid_format?(value)
      record.errors.add(attribute, :typo) if domain_typo?(value)
    else
      record.errors.add(attribute, :invalid)
    end
  end

  private

  def valid_format?(value)
    EMAIL_REGEX.match?(value)
  end

  # Very simplistic but we see these typos quite frequently
  def domain_typo?(value)
    COMMON_DOMAIN_TYPOS.include?(
      value.rpartition('@').last
    )
  end
end
