require 'fileutils'
require 'rmagick'

RSpec.describe 'website' do
  before(:all) do
    @temp_dir = Pathname.new(::Research::APP_DIR) + 'temp/'
    FileUtils.makedirs @temp_dir
  end

  after(:all) do
    Research::Website.close
    FileUtils.rm_r(@temp_dir, :secure => true)
  end

  it 'init' do
    Research::Website.new(1, 'http://grafomat.sk/', @temp_dir)
  end

  context 'save' do
    it 'with lazy loading' do
      website = Research::Website.new(1, 'http://grafomat.sk/', @temp_dir)
      website.save(true)
      result =  Magick::Image.read(@temp_dir + '1.png')
      expected =  Magick::Image.read('spec/fixtures/grafomat_screenshot.png')
      diff_img, diff_metric  = result[0].compare_channel(expected[0], Magick::MeanSquaredErrorMetric)
      expect(diff_metric).to be < 0.01
    end

    it 'without lazy loading' do
      website = Research::Website.new(2, 'http://grafomat.sk/', @temp_dir)
      website.save
      result =  Magick::Image.read(@temp_dir + '2.png')
      expected =  Magick::Image.read('spec/fixtures/grafomat_screenshot_without_lazy_loading.png')
      diff_img, diff_metric  = result[0].compare_channel(expected[0], Magick::MeanSquaredErrorMetric)
      expect(diff_metric).to be < 0.01
    end
  end
end