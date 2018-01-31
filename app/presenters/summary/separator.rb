module Summary
  class Separator
    attr_reader :title, :i18n_opts

    def initialize(title, i18n_opts = {})
      @title = title
      @i18n_opts = i18n_opts
    end

    def show?
      true
    end

    def to_partial_path
      'shared/separator'
    end
  end
end
