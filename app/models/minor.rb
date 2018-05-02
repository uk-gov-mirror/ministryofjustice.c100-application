class Minor < Person
  has_many :relationships, source: :minor, dependent: :destroy
end

# hackhackhack to make sure that c100_application.minors
# includes the subtypes in development
# (autoloading only includes _KNOWN_ subclasses -
# see http://guides.rubyonrails.org/autoloading_and_reloading_constants.html#autoloading-and-sti )
require_dependency 'child'
require_dependency 'other_child'
