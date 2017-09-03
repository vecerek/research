# Research

A Ruby gem used for simple web research. It basically does 2 simple things:

1. **PDFSearch**: finds PDFs through Google search in a certain topic (google search query without the need to type *filetype:pdf*) and downloads them to a specified directory.
2. **Sitesearch**: finds websites in a certain topic, creates a full screenshot of them which are then downloaded to the specified directory along their url.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'research'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install research-1.5.0.gem

## Usage

### 1) PDFSearch

pdfsearch [options] <QUERY>

#### Example:
pdfsearch --limit=1000 --output=path/to/output/directory 'tyler catalogue  site:com'

#### Description:
Simple google search result parser that saves the pdf results for the given google search term. Note, that you don't have to specify the filetype:pdf in the query.

#### Hint:
If you need to use double quotes inside of the search term, the search term itself should be encased in single quotes, as seen in the Example.

#### Common options:
    -?, -h, --help                   Show this help message.
    -v, --version                    Print the PDFSearch version.

#### Input and Output options:
        --input=DIRECTORY            Specifies the path to the Excel spreadsheet containing the search terms and the output directory.
                                     For example, with the output parameter set to --output=D:\business\research, the spreadsheet may contain outputs as:
                                     dentist, tyler, etc., so the final directory would be D:\business\research\dentist, D:\business\research\tyler, etc.
        --heading                    Specifies that the spreadsheet's first row is not part of the data
        --output=DIRECTORY           Specifies the path of the folder where you would like to save the results.
                                     For example: D:\business\inspiration\tyler-project - where tyler-project is a folder.
        --limit=NUMBER               Configures the number of results that should be parsed and saved this time and later.
                                     Default value: 100. Maximal value: 200
                                     Your setting will be saved for later use, so you do not have to specify the limit every time.

#### Miscellaneous options:
        --timeout=SECONDS            Sets the timeout of a request in seconds
                                     For example: --timeout=60
                                     Default value: 300
        --trace                      Turns on detailed debugging messages
        --settings                   Shows the saved configuration.

### 2) Sitesearch

sitesearch [options] <QUERY>

#### Example:
sitesearch --limit=1000 --output=path/to/ouput/directory 'Ruby "programming course" site:com'

#### Description:
Simple google search result parser that saves a screenshot of each website in the results. The number of results saved can be limited.

#### Hint:
If you need to use double quotes inside of the search term, the search term itself should be encased in single quotes, as seen in the Example.

#### Common options:
    -?, -h, --help                   Show this help message.
    -v, --version                    Print the SiteSearch version.

#### Input and Output options:
        --input=DIRECTORY            Specifies the path to the Excel spreadsheet containing the search terms and the output directory.
                                     For example, with the output parameter set to --output=D:\business\research, the spreadsheet may contain outputs as:
                                     dentist, tyler, etc., so the final directory would be D:\business\research\dentist, D:\business\research\tyler, etc.
        --heading                    Specifies that the spreadsheet's first row is not part of the data
        --output=DIRECTORY           Specifies the path of the folder where you would like to save the results.
                                     For example: D:\business\inspiration\tyler-project - where tyler-project is a folder.
        --limit=NUMBER               Configures the number of results that should be parsed and saved this time and later.
                                     Default value: 100. Maximal value: 200
                                     Your setting will be saved for later use, so you do not have to specify the limit every time.

#### Miscellaneous options:
        --timeout=SECONDS            Sets the timeout of a request in seconds
                                     For example: --timeout=60
                                     Default value: 300
        --trace                      Turns on detailed debugging messages
        --settings                   Shows the saved configuration.
        --lazy-loading               Screenshots will also contain the dynamically loaded content(text and some pictures)
                                     Attention: This option may cause decreased performance. It is turned off by default.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vecerek/research.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

