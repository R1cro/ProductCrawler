require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'csv'

BASE_DIR = 'output/'
Dir.mkdir(BASE_DIR) unless File.exists?(BASE_DIR)

BASE_URL = 'https://www.viovet.co.uk'
INPUT_URL = '/Hills_Pet_Nutrition_Dog_Food/c2678/'
PAGINATION = '?_=X&page='
CATEGORY_URL = "#{BASE_URL}#{INPUT_URL}"

CSV_HEADER = %w(
            Название
            Весовка
            Цена
            Картинка
            Доставка
            Код
            )

get_page = Nokogiri::HTML(open (CATEGORY_URL)).at('.pagination')
last_page = get_page.css('a').last.attr('href')
last_page = last_page.slice(last_page.length - 1)

(1..last_page.to_i).each do |page|
# Find links
  get_link = Nokogiri::HTML(open (CATEGORY_URL + PAGINATION + page.to_s)).at('.families-list')
  get_link.css('a.call_to_action._secondary._medium.view_details').each do |link|
    link_list = link.attr('href')
    uri = BASE_URL + link_list #our page-link
    p 'Fetching: ' + uri

#Extract data from page
    page = Nokogiri::HTML(open(uri)).at('.content-box')
    @product = page.at_css('#product_family_heading').inner_text
    dir = BASE_DIR + @product.delete('/')
    Dir.mkdir(dir) unless File.exists?(dir)
    CSV.open(dir + '/output.csv', 'wb') do |csv|
      csv << CSV_HEADER
      @image = page.at('._img_zoom').attr('src').delete("\t\n")
      page.search('li.product').each do |item|
        @items = {
            name: @product,
            filling: item.search('div.title')[0].text.delete("\t\n"),
            price: item.search('div.ours span')[0].text.delete("\t\n"),
            picture: @image,
            delivery: item.search('.in-stock').inner_text.delete("\t\n"),
            code: item.at('a strong').text,
        }
        csv << @items.values #Data
      end # item
    end # cvs
  end # links
  p 'Done.'
end # page
