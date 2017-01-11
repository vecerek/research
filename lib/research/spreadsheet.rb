require 'roo'
require 'pathname'

module Research
  class Spreadsheet
    def initialize(options = {})
      default_opts = {
          :separator => ',',
          :heading => false,
          :query_col => 1,
          :output_col => 2
      }
      @options = default_opts.update(options)
      if @options[:input] =~ /\.[c|t]sv$/
        @options[:separator] = "\t" if @options[:input] =~ /\.tsv$/
        @spreadsheet = Roo::CSV.new(@options[:input], csv_options: {col_sep: @options[:separator]})
      else
        @spreadsheet = Roo::Spreadsheet.open(@options[:input])
      end
    end

    def queries
      o = outputs
      q = search_terms
      options = @options.clone
      raise SpreadsheetError unless o.length == q.length
      q.each_with_index.map do |x,i|
        options[:output] = Pathname.new(@options[:output]) + o[i]
        options[:query] = x
        Query.new(options)
      end
    end

    def search_terms
      col(:query_col)
    end

    def outputs
      col(:output_col)
    end

    def sheet(name = 0)
      @current_sheet = @spreadsheet.sheet(name)
      self
    end

    private

    def col(col)
      col = @spreadsheet.sheet(0).column(@options[col])
      col.shift if @options[:heading]
      col
    end
  end
end