module Research
  class Task
    attr_reader :query, :output, :type

    def self.format_mb(size)
      conv = %w(B kB MB GB TB PB EB)
      scale = 1024

      ndx = 1
      return "#{(size)} #{conv[ndx-1]}" if size < 2*(scale**ndx)

      size = size.to_f
      [2,3,4,5,6,7].each do |ndx|
        return "#{'%.2f' % (size/(scale**(ndx-1)))} #{conv[ndx-1]}" if size < 2*(scale**ndx)
      end

      ndx = 7
      "#{'%.2f' % (size/(scale**(ndx-1)))} #{conv[ndx-1]}"
    end

    def self.timeout=(timeout)
      @@timeout = timeout
    end

    def self.timeout
      return @@timeout if defined? @@timeout
      TIMEOUT
    end

    def initialize(queries, options)
      @options = options
      @queries = queries
      @type = options[:type]
      @logger = options[:logger]
    end

    def length
      @queries.length
    end

    MAX_CONCURRENCY = 100
    TIMEOUT = 300 #in seconds
    CONNECT_TIMEOUT = 10 #in seconds

    def run(progressbar, lazy_loading = nil)
      hydra = Typhoeus::Hydra.new(max_concurrency: MAX_CONCURRENCY)
      results = []
      progressbar.log "Please, wait. Processing queries...\r" if processing_long?
      STDOUT.flush
      @queries.each do |query|
        results += query.search(@type).results
      end
      progressbar.total = results.length
      results.each do |result|
        case @type
          when :website
            result.save(lazy_loading)
            progressbar.increment
          when :pdf
            result.save(hydra, progressbar, @logger)
          else
            raise NotImplementedError
        end
      end
      begin
        hydra.run if @type == :pdf
      rescue NoMethodError => e
        puts e.message
        puts e.backtrace
      end
    end

    def processing_long?
      @queries.length * @options[:limit] >= 200
    end
  end
end