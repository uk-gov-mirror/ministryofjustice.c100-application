class ChildrenType < ValueObject
  VALUES = [
    PRIMARY   = new(:primary),
    SECONDARY = new(:secondary)
  ].freeze
end
