require 'time'

module Research
  class PDF < Result
    @@total_size = 0
    @@timed_out = 0

    def self.size_of_download
      @@total_size
    end

    def self.timed_out
      @@timed_out
    end

    def initialize(id, url, output)
      super(id, url, output)
    end

    def save(hydra, progressbar, logger)
      pdf, src = filenames(@output, '.pdf')
      file = File.open pdf, 'wb'
      request = Typhoeus::Request.new(@url, timeout: Task.timeout, connecttimeout: Task::CONNECT_TIMEOUT, ssl_verifypeer: Query.verify_ssl)
      request.on_body do |chunk|
        file.write(chunk)
      end
      request.on_complete do |response|
        if response.success?
          @@total_size += file.size
          super(src)
          progressbar.increment
        elsif response.timed_out?
          progressbar.total = progressbar.total - 1
          logger.error "\tTimed out.\n\tCouldn't download #{@url}"
          @@timed_out += 1
        elsif response.code == 0
          # Could not get an http response, something's wrong.
          progressbar.total = progressbar.total - 1
          logger.error "\t#{response.return_message}\n\tCouldn't download #{@url}"
        else
          # Received a non-successful http response.
          progressbar.total = progressbar.total - 1
          logger.error "\tHTTP request failed: #{response.code.to_s}\n\tCouldn't download #{@url}"
        end
        FileUtils.rm_f(file.path) if File.exists?(file.path) unless response.success?
        file.close
      end
      hydra.queue request
    end
  end
end
