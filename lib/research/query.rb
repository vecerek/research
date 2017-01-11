require 'cgi'
require 'uri'
require 'open-uri'
require 'nokogiri'

module Research
  class Query
    attr_reader :output, :term, :results

    @@verify_ssl = true

    def self.verify_ssl
      @@verify_ssl
    end

    def self.verify_ssl=(boolean)
      @@verify_ssl = boolean
    end

    def initialize(options)
      @options = options.clone
      q = options[:query]
      l = options[:limit] < MAX_LIMIT ? options[:limit] : MAX_LIMIT
      @output = options[:output]
      @term = options[:query]
      @capacity = 0
      @limit = options[:limit]
      @filetype = options[:type] == :pdf ? 'pdf':nil
      q += " filetype:#{@filetype}" if @filetype
      @next_query = @query = "https://www.google.com/search?num=#{l}&q=#{q.gsub(/ /, '+')}&filter=0&pws=0"
      @current_page = 1
      @results = []
    end

    def search(attr)
      begin
        page = open(URI.encode(@next_query))
      rescue OpenSSL::SSL::SSLError
        Query.verify_ssl = false
        page = open(URI.encode(@next_query), {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
        unless defined? @@warned_open_ssl
          puts 'WARNING: SSL verification temporarily turned off due to expected problems with the SSL/TLS certificate installed on your OS. Expect your anti-virus program to report this application.'
          @@warned_open_ssl = true
        end
      rescue OpenURI::HTTPError => error
        response = error.io
        if response.status[0].to_i == 503
          unless defined? @@warned_fallback
            #puts 'This message appears when Google automatically detects requests coming from your computer network which appear to be in violation of the Terms of Service (https://www.google.com/policies/terms/). The block will expire shortly after those requests stop.'
            puts 'WARNING: Google temporarily banned your IP address due to suspicious behavior.'
            puts 'Falling back to Google Custom Search API. The limit is 100 search queries per day.'
            puts
            @@warned_fallback = true
          end
          fallback(attr)
          return self
        else
          puts "Unexpected error. Response: #{response.status[0]} #{response.status[1]}"
        end
        exit
      end
      @html = Nokogiri::HTML(page)
      results = @html.css('h3.r > a')
      return self if results.length == 0
      results.each do |result|
        result = link(result)
        next unless result
        id = @capacity + 1
        @results << CLASSES[attr].new(id, result, @output) if @capacity < @limit
        @capacity = id
      end
      if @capacity < @limit
        next_page
        search(attr)
      else
        self
      end
    end

    private

    MAX_LIMIT = 100
    CLASSES = {:pdf => PDF, :website => Website}

    def fallback(attr)
      query = @options[:query]
      results = Research::GoogleCustomSearch.new(query, @limit - @capacity, @filetype).build.results
      results.map.with_index(1) do |link,index|
        result = CLASSES[attr].new(index, link, @output)
        @results << result unless @results.include?(result)
      end
    end

    def next_page
      @next_query = @query + "&start=#{@current_page * MAX_LIMIT}"
      @current_page += 1
    end

    def link(result)
      CGI::parse(result.attribute('href').value[5..-1])['q'][0]
    end
  end
end
