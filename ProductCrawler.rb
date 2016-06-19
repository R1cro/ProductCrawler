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
    File.open(url_file).read.split(BASE_URL)
  end

  def category_url
    FULL_URL + input_url.last
  end

  def find_pages
    pagination = Nokogiri::HTML(open (category_url)).at('.pagination')
    page_list = []
    pagination.css('a').each do |pages|
      page_list.push (pages.attr('href').match(/page=(\d+)/)[1].to_i)
    end
    page_list.max
  end

  def save_data_to_csv
    CSV.open(BASE_DIR + csv_file_name, 'wb') do |csv|
      csv << CSV_HEADER
      (1..find_pages).each do |page|
        p 'Page: #' + page.to_s 
        get_link = Nokogiri::HTML(open (category_url + PAGINATION + page.to_s)).at('.families-list')
        get_link.css('a.call_to_action._secondary._medium.view_details').each do |link|
          link_list = link.attr('href')
          p 'Fetching: ' + link_list
          uri = FULL_URL + link_list 
          page = Nokogiri::HTML(open(uri)).at('.content-box')
          product = page.at_css('#product_family_heading').inner_text
          image = page.at('img').attr('src').delete("\t\n")
          page.search('li.product').each do |item|
            items = {
                name: product + ' - ' + item.search('div.title')[0].text.delete("\t\n"),
                price: item.search('div.ours span')[0].text.delete("\t\n"),
                picture: image,
                delivery: item.search('.in-stock').inner_text.delete("\t\n"),
                code: item.at('a strong').text,
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