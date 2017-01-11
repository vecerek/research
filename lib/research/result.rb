require 'typhoeus'
require 'fileutils'
require 'pathname'

module Research
  class Result
    attr_reader :id, :url

    def self.trace
      @@trace = true
    end

    def initialize(id, url, output)
      @id = id
      @url = url
      @output = output
    end

    def ==(other)
      @url == other.url
    end

    def save(destination)
      open(destination, 'wb') do |file|
        file.write(@url + "\n")
      end
    end

    def filenames(destination, extension)
      root = Pathname.new(destination)
      sources = root + 'urls/'
      file = root + "#{@id.to_s + extension}"
      source = sources + "#{@id.to_s}.txt"
      FileUtils.makedirs(sources) unless File.directory?(sources)
      [file, source]
    end
  end
end
