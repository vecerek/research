require 'logger'
require 'pathname'
require 'fileutils'

module Research
  module Exec
    class PDFSearch < Base
      def set_opts(opts)
        opts.banner = <<END
PDFSearch Help:
===============

Usage: pdfsearch [options] <QUERY>

Example:
pdfsearch --limit=1000 --output=D:\\business\\tyler-project\\research 'tyler catalogue  site:com'

Description:
Simple google search result parser that saves the pdf results
for the given google search term. Note, that you don't have to
specify the filetype:pdf in the query.

Hint:
If you need to use double quotes inside of the search term, the search term itself should be
encased in single quotes, as seen in the Example.
END
        super(opts)
      end

      def common_options(opts)
        super
        opts.on('-v', '--version', 'Print the PDFSearch version.') do
          puts("PDFSearch v#{::Research::PDFSearch::VERSION}")
          exit
        end
      end

      def process_args
        super { @options[:query] += ' filetype:pdf' if @options[:query] }
      end

      def run
        @options[:type] = :pdf

        log_file = Pathname.new(@options[:output]) + 'errors.log'
        dir = File.dirname(log_file)
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        @options[:logger] = Logger.new(log_file)
        @options[:logger].datetime_format = '%Y-%m-%d %H:%M:%S'
        @options[:logger].formatter = proc do |severity, datetime, progname, msg|
          "[#{datetime}] #{progname}: #{msg}\n"
        end

        if @options[:input]
          task = ::Research::Task.new(::Research::Spreadsheet.new(@options).queries, @options)
        else
          task = ::Research::Task.new([Query.new(@options)], @options)
        end

        percentage = @options[:limit] > 100 ? 'P':'p'
        progressbar = ProgressBar.create(
            :title => 'Downloading',
            :total => @options[:limit] * task.length,
            :format => "%t: |%B| %#{percentage}%% [%E]"
        )

        updater = Thread.start {
          while true
            sleep 1.0
            progressbar.refresh
          end
        }

        task.run(progressbar)

        updater.kill

        puts 'Completed!'
        puts "Downloaded #{progressbar.total} files."
        puts "#{PDF.timed_out} request#{PDF.timed_out > 1 ? 's':''} timed out."
        puts "Total size: #{Task.format_mb(PDF.size_of_download)}"
        @options[:logger].close
      end
    end
  end
end
