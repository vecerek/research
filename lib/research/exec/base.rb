require 'optparse'
require 'yaml'
require 'pathname'
require 'ruby-progressbar'

module Research
  module Exec
    # The abstract base class for GoogleSearch executables.
    class Base
      # @param args [Array<String>] command-line arguments
      def initialize(args)
        @args = args
        @options = {}
      end

      # Parses the command-line arguments and runs the executable.
      # Calls `Kernel#exit` at the end, so it never returns.
      #
      # @see #parse
      def parse!
        begin
          parse
        rescue Exception => e
          raise e if @options[:trace] || e.is_a?(SystemExit)
          $stderr.puts "#{e.class}: " + e.message.to_s
          exit 1
        end
        exit 0
      end

      # Parses the command-line arguments and runs the executable.
      def parse
        # @opts = OptionParser.new(&method(:set_opts))
        OptionParser.new do |opts|
          set_opts(opts)
        end.parse!(@args)

        process_args

        @options
      end

      protected

      # Tells optparse how to parse the arguments.
      #
      # @param opts [OptionParser]
      def set_opts(opts)
        common_options(opts)
        input_and_output(opts)
        miscellaneous_options(opts)
      end

      # Processes the options set by the command-line arguments -
      # `@options[:input]` and `@options[:output]` are being set
      # to appropriate IO streams.
      #
      # This method is being overridden by subclasses
      # to run their respective programs.
      def process_args
        raise QueryNotSpecifiedError if @args.length == 0 unless @options[:input]
        config = load_configuration
        config.update(@options)
        @options = config
        save_configuration(config)
        @options[:query] = @args.join(' ') unless @options[:input]
        @options[:timeout] ||= nil
        @options[:input] ||= nil
        @options[:heading] ||= false
        yield if block_given?
        run
      end

      private

      def common_options(opts)
        opts.separator ''
        opts.separator 'Common options:'

        opts.on('-?', '-h', '--help', 'Show this help message.') do
          puts opts
          exit
        end
      end

      def input_and_output(opts)
        opts.separator ''
        opts.separator 'Input and Output options:'

        opts.on('--input=DIRECTORY',
                'Specifies the path to the Excel spreadsheet containing the search terms and the output directory.',
                'For example, with the output parameter set to --output=D:\business\research, the spreadsheet may contain outputs as:',
                'dentist, tyler, etc., so the final directory would be D:\business\research\dentist, D:\business\research\tyler, etc.') do |input|
          @options[:input] = input
        end

        opts.on('--heading', "Specifies that the spreadsheet's first row is not part of the data") do |heading|
          @options[:heading] = true
        end

        opts.on(:REQUIRED, '--output=DIRECTORY',
                'Specifies the path of the folder where you would like to save the results.',
                'For example: D:\business\inspiration\tyler-project - where tyler-project is a folder.') do |output|
          @options[:output] = output
        end

        opts.on('--limit=NUMBER', Integer,
                'Configures the number of results that should be parsed and saved this time and later.',
                'Default value: 100. Maximal value: 200',
                'Your setting will be saved for later use, so you do not have to specify the limit every time.') do |limit|
          @options[:limit] = limit > 200 ? 200 : limit
        end
      end

      def miscellaneous_options(opts)
        opts.separator ''
        opts.separator 'Miscellaneous options:'

        #opts.on('--browser=BROWSER', [:chrome, :firefox, :ie], 'Select your preferred browser (chrome, firefox, ie)') do |browser|
          #@options[:browser] = browser
        #end

        opts.on('--timeout=SECONDS', Integer,
                'Sets the timeout of a request in seconds',
                'For example: --timeout=60', 'Default value: 300') do |timeout|
          @options[:timeout] = timeout
          ::Research::Task.timeout = timeout
        end

        opts.on('--trace', 'Turns on detailed debugging messages') do
          Result.set_trace
        end

        opts.on('--settings', 'Shows the saved configuration.') do
          puts 'SETTINGS'
          puts '========'
          config = load_configuration
          config.each { |k,v| puts "#{k.to_s}: #{v.to_s}" }
          exit
        end
      end

      CONFIGURATIONS = Pathname.new(::Research::APP_DIR) + '.settings.yml'

      def save_configuration(options)
        config = {
            :limit => options[:limit] || 100,
            :browser => options[:browser] || :firefox
        }
        File.open(CONFIGURATIONS, 'w') do |file|
          file.write(config.to_yaml)
        end
      end

      def load_configuration
        config = YAML::load_file(CONFIGURATIONS)
        options = {}
        config.each { |k, v| options[k.to_sym] = v }
        options
      end

      def run
        raise NotImplementedError
      end
    end
  end
end
