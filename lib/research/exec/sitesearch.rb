module Research
  module Exec
    class SiteSearch < Base
      def set_opts(opts)
        opts.banner = <<END
SiteSearch Help:
===============

Usage: sitesearch [options] <QUERY>

Example:
sitesearch --limit=1000 --output=D:\\business\\tyler-project\\research 'Ruby "programming course" site:com'

Description:
Simple google search result parser that saves a screenshot of
each website in the results. The number of results saved can
be limited.

Hint:
If you need to use double quotes inside of the search term, the search term itself should be
encased in single quotes, as seen in the Example.
END
        super(opts)
      end

      def common_options(opts)
        super
        opts.on('-v', '--version', 'Print the SiteSearch version.') do
          puts("SiteSearch v#{::Research::SiteSearch::VERSION}")
          exit
        end
      end

      def miscellaneous_options(opts)
        super(opts)
        opts.on('--lazy-loading', 'Screenshots will also contain the dynamically loaded content(text and some pictures)',
                'Attention: This option may cause decreased performance. It is turned off by default.') do
          @options[:lazy_loading] = true
        end
      end

      def run
        @options[:type] = :website
        Website.browser = @options[:browser]
        percentage = @options[:limit] > 100 ? 'P':'p'
        progressbar = ProgressBar.create(
            :title => 'Downloading',
            :total => @options[:limit],
            :format => "%t: |%B| %#{percentage}%% [%E]"
        )
        @options[:progressbar] = progressbar

        if @options[:input]
          task = ::Research::Task.new(::Research::Spreadsheet.new(@options).queries, @options)
        else
          task = ::Research::Task.new([Query.new(@options)], @options)
        end

        task.run(progressbar, @options[:lazy_loading])
        Website.close
        puts 'Completed!'
      end
    end
  end
end
