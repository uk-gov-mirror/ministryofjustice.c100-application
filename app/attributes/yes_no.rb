class YesNo < Virtus::Attribute
  def coerce(value)
    value ? GenericYesNo.new(value) : nil
  end
end
