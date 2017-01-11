# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubygems'
require 'research/constants'

RESEARCH_GEMSPEC = Gem::Specification.new do |spec|
  spec.name = 'research'
  spec.summary = 'Automates the saving of Google search results.'
  spec.version = Research::VERSION
  spec.authors = ['Attila Večerek']
  spec.email = 'attila.vecerek@grafomat.sk'
  spec.description = <<-END
  END

  spec.required_ruby_version = '>= 2.0.0'

  readmes = Dir['*'].reject { |x| x =~ /(^|[^.a-z])[a-z]+/ || x == 'TODO' }
  spec.executables = %w(pdfsearch sitesearch research)
  spec.files = Dir['lib/**/*', 'bin/*', '.settings.yml'] + readmes
  spec.homepage = ''
  spec.has_rdoc = false
  spec.test_files = Dir['spec/**/*_spec.rb']
  spec.license = 'MIT'

  spec.add_dependency 'watir-webdriver', '~> 0.9'
  spec.add_dependency 'watir-scroll', '~> 0.1'
  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'ruby-progressbar', '~> 1.8'
  spec.add_dependency 'roo', '~> 2.4'
  spec.add_dependency 'typhoeus', '~> 1.1'

  spec.add_development_dependency 'rake', '~> 11.1'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rmagick', '~> 2.15'
end
