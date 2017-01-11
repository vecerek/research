module Research
  class ResearchError < StandardError; end

  class ArgumentUnspecifiedError < ArgumentError
    def initialize(arg)
      @arg = arg
    end

    def message
      "Argument Error: #{@arg} can't be left unspecified."
    end
  end

  class QueryNotSpecifiedError < ArgumentUnspecifiedError
    def message
      'Argument Error: the query must be specified.'
    end
  end

  class SpreadsheetError < ResearchError
    def message
      'The length of the columns is not the same.'
    end
  end

  class LimitReachedError < ResearchError
    def message
      'You have reached your daily search limit. See you again tomorrow :)'
    end
  end

  class UnknownError < ResearchError
    def message
      "Something unexpected just happened.\n" + super
    end
  end
end