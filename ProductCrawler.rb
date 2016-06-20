require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'csv'

require_relative 'conf'

class ProductCrawler

  attr_accessor :url_file, :csv_file_name

  def initialize(url_file, csv_file_name)
    @url_file = url_file 
    @csv_file_name = csv_file_name
  end  

  def input_url
    File.open(url_file).read.gsub(/\s+/, "").split(BASE_URL)
  end

  def category_url
    FULL_URL + input_url.last
  end

  def find_pages
    pagination = Nokogiri::HTML(open (category_url)).xpath(PAGINATION_XPATH)
    page_list = []
    pagination.css(NODE_A).each do |pages|
      page_list.push (pages.attr(ATTR_HREF).match(/page=(\d+)/)[1].to_i)
    end
    page_list.max
  end

  def save_data_to_csv
    CSV.open(BASE_DIR + csv_file_name, 'wb') do |csv|
      csv << CSV_HEADER
      (1..find_pages).each do |page|
        p 'Page: #' + page.to_s 
        get_link = Nokogiri::HTML(open (category_url + PAGINATION + page.to_s)).xpath(FAMILIES_LIST_XPATH)
        get_link.xpath(VIEW_DETAILS_XPATH).each do |link|
          link_list = link.attr(ATTR_HREF)
          p 'Fetching: ' + link_list
          uri = FULL_URL + link_list 
          page = Nokogiri::HTML(open(uri)).xpath(CONTENT_BOX_XPATH)
          product = page.xpath(PRODUCT_FAMILY_HEADING_XPATH).inner_text
          image = page.xpath(IMG_XPATH)
          page.search(PRODUCT_XPATH).each do |item|
            items = {
                name: product + ' - ' + item.search(FILLING_TITLE_PATH)[0].text.delete("\t\n"),
                price: item.search(PRICE_PATH)[0].text.delete("£\t\n"),
                picture: image,
                delivery: item.search(DELIVERY_PATH).inner_text.delete("\t\n"),
                code: item.search(CODE_PATH).text,
            }
            csv << items.values
          end #item
        end #link
      end #page
    end #csv
  end

end

Dir.mkdir(BASE_DIR) unless File.exists?(BASE_DIR)
product_crawler = ProductCrawler.new(ARGV[0], ARGV[1])
product_crawler.save_data_to_csv
