RSpec.describe 'spreadsheet' do
  before(:all) do
    @options = {
        :input => 'spec/fixtures/tasks.xlsx',
        :output => Pathname.new('/Users/attila/research/'),
        :type => :website,
        :limit => 5
    }
    @options_h = @options.clone
    @options_h[:heading] = true
  end

  it 'init' do
    Research::Spreadsheet.new(@options)
  end

  context 'import names from' do
    expected_queries = ['cats at home', 'dogs in the park', 'dentists smiling', 'trees upside down', 'culture in Taiwan']
    expected_dirs = %w(cats dogs dentists trees culture)
    spreadsheets = %w(xlsx ods csv tsv)
    spreadsheets.each do |extension|
      it ".#{extension}" do
        options = @options.clone
        options[:input] = "spec/fixtures/tasks.#{extension}"
        queries = Research::Spreadsheet.new(options).queries
        queries.each_with_index do |t,i|
          expect(t.term).to eq(expected_queries[i])
          expect(t.output).to eq(@options[:output] + expected_dirs[i])
        end
      end

      it ".#{extension} with heading" do
        exp_q = expected_queries[1..-1]
        exp_d = expected_dirs[1..-1]
        options = @options_h.clone
        options[:input] = "spec/fixtures/tasks.#{extension}"
        queries = Research::Spreadsheet.new(options).queries
        queries.each_with_index do |t,i|
          expect(t.term).to eq(exp_q[i])
          expect(t.output).to eq(@options[:output] + exp_d[i])
        end
      end
    end
  end
end