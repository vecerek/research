dir = File.dirname(__FILE__)
$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)

require 'research/constants'
require 'research/error'
require 'research/google_custom_search'
require 'research/task'
require 'research/spreadsheet'
require 'research/exec'
require 'research/result'
require 'research/pdf'
require 'research/website'
require 'research/query'
