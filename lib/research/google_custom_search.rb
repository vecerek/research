require 'net/http'
require 'json'

module Research
  class GoogleCustomSearch
    attr_reader :q, :limit, :results,
                :total_results, :search_time

    def initialize(q, limit, filetype = nil)
      @q = q.gsub(/ /, '+')
      @limit = limit
      @filetype = filetype
      @num = 10
      @start = 1
      @results = []
      @total_results = -1
      @search_time = 0
    end

    def query
      @uri.to_s
    end

    def build
      @uri = 'https://www.googleapis.com/customsearch/v1?'
      params = {
          :q => @q,
          :cx => ::Research::SEARCH_ENGINE_ID,
          :num => @num,
          :start => @start,
          :fields => FIELDS,
          :key => ::Research::API_KEY
      }
      params[:fileType] = @filetype if @filetype
      params_s = ''
      params.each do |key, value|
        params_s += "&#{key.to_s}=#{value.to_s}"
      end
      @uri += params_s[1..-1]
      @uri = URI(@uri)
      self
    end

    def results
      while @results.length < @limit
        begin
          json = response
          @total_results = json['searchInformation']['totalResults'].to_i if @total_results == -1
          @search_time += json['searchInformation']['searchTime']
          json['items'].each { |item| @results << item['link'] }
          @start += RESULTS_PER_PAGE
          @num =  results_left if results_left < RESULTS_PER_PAGE
          build
        rescue ::Research::LimitReachedError => e
          puts e.message
          puts "Processing last #{@results.length} results..."
          break
        end
      end
      @results
    end

    private

    FIELDS = 'items%2Flink%2Cqueries%2CsearchInformation'
    RESULTS_PER_PAGE = 10

    def response
      response = Net::HTTP.get_response(@uri)
      case response.code.to_i
        when 200
          JSON.parse(response.body)
        when 403
          raise ::Research::LimitReachedError
        else
          raise ::Research::UnknownError
      end
    end

    def results_left
      @limit - @results.length
    end
  end
end