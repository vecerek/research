RSpec.describe 'query' do
  before(:all) do
    @options = {
        :query => 'Grafomat',
        :output => '/Projects/examples',
        :limit => 100
    }
    @query = Research::Query.new(@options)
  end

  after(:all) do
    Research::Website.close
  end

  context 'init' do
    it 'is empty' do
      expect(@query.instance_variable_get(:@capacity)).to be 0
    end

    context 'limit' do
      it 'is set as specified' do
        expect(@query.instance_variable_get(:@limit)).to be 100
      end

      it 'does not exceed maximum' do
        options = @options
        options[:limit] = 200
        options[:query] = 'a'
        expect(Research::Query.new(options).instance_variable_get(:@query)).to eq('https://www.google.sk/search?num=100&q=a&pws=0')
      end
    end

    it 'sets query' do
      expect(@query.instance_variable_get(:@query)).to eq('https://www.google.sk/search?num=100&q=Grafomat&pws=0')
    end

    it 'current page set to 1' do
      expect(@query.instance_variable_get(:@current_page)).to be 1
    end

    it 'has no results yet' do
      expect(@query.instance_variable_get(:@results)).to eq([])
    end

    it 'sets output' do
      expect(@query.instance_variable_get(:@output)).to eq('/Projects/examples')
    end
  end

  it 'search' do
    url = 'http://www.grafomat.sk/'
    result = Research::Website.new(1, url, @options[:output])
    query = Research::Query.new(@options)
    expect(query.search(:website).results[0]).to eq(result)
  end
end