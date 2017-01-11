RSpec.describe 'Google Custom Search' do
  it 'init' do
    Research::GoogleCustomSearch.new('dentist catalogue', 15, 'pdf')
  end

  it 'build' do
    fields = 'items%2Flink%2Cqueries%2CsearchInformation'
    search = Research::GoogleCustomSearch.new('dentist catalogue', 15, 'pdf').build
    expect(search.query).to eq "https://www.googleapis.com/customsearch/v1?q=dentist+catalogue&cx=#{Research::SEARCH_ENGINE_ID}&num=10&start=1&fields=#{fields}&key=#{Research::API_KEY}&fileType=pdf"
  end

  it 'results' do
    expected_results = [
        'http://www.bego.com/fileadmin/user_downloads/Mediathek/Dental/en_Produkte/de_82004_0004_br_en.pdf',
        'http://multimedia.3m.com/mws/media/713343O/3m-espe-dental-products-catalogue-2011-2012-ebu.pdf?fn=3M_ESPE_ProductCatalog_EBU.pdf',
        'http://www.acteonusa.com/pdf/dental/ultrasonics/UltrasonicsTipBook.pdf',
        'http://www.boydindustries.com/PDF/pediatric-dentistry-cat.pdf',
        'https://www.aesculapusa.com/assets/base/doc/DOC1197-Aesculap_Dental_Instruments_Product_Catalog.pdf'
    ]
    results = Research::GoogleCustomSearch.new('dentist catalogue', 15, 'pdf').build.results
    expect(results.length).to be 15
    expected_results.each { |result| expect(results).to include(result) }
  end
end