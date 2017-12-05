class ChildrenType < ValueObject
  VALUES = [
    PRINCIPAL = new(:principal),
    SECONDARY = new(:secondary)
  ].freeze
end
