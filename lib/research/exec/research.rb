module Research
  module Exec
    class Research < Base
      def set_opts(opts)
        opts.banner = <<END
Research Help:
===============

Description:
The Research app package contains two individual apps.
Open each app's Manual Page by specifying the respective
commands:

pdfsearch --help
sitesearch --help
END
        super(opts)
      end

      def common_options(opts)
        super
        opts.on('-v', '--version', 'Print the Research version.') do
          puts("Research v#{Research::VERSION}")
          exit
        end
      end

      def input_and_output(opts); end
      def miscellaneous_options(opts); end

      def run; end
    end
  end
end
