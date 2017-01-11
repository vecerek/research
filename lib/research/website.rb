require 'watir-webdriver'
require 'watir-scroll'
require 'selenium-webdriver'

module Research
  class Website < Result
    def initialize(id, url, output)
      super(id, url, output)
      begin
        @@b = Watir::Browser.new unless defined? @@b
      rescue Selenium::WebDriver::Error::WebDriverError => e
        puts 'The version of your Firefox is not supported. Recommended Firefox version is 44.0.2'
        puts e.backtrace if @@trace
        raise
      end
    end

    def save(lazy_loading = false)
      img, src = filenames(@output, '.png')
      @@b = Watir::Browser.new unless @@b.exists?
      @@b.goto @url
      if lazy_loading
        15.times do
          @@b.send_keys :space
        end
      end
      @@b.scroll.to :bottom
      sleep 0.25
      @@b.scroll.to :top
      sleep 0.25
      @@b.screenshot.save img
      super(src)
    end

    def self.browser=(browser)
      @@browser = browser
    end

    def self.close
      @@b.close
    end
  end
end
