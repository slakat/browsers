require 'rubygems'
require 'nokogiri'
require 'csv'

# define arrays including a dummy array which is needed for reasons i do not yet know :P
# remember that you can easily adapt this parser to suit your needs by defining additional variables
# and by adding additional xpath steps (doc.xpath...) below

class ScraperBing

  def self.bing(doc)

    # search elements via xpath and collect contents in arrays
    search = doc.at_xpath("//input[contains(@id,'sb_form_q')]")['value'].strip
    strasse = doc.xpath("//div[contains(@id,'results')]")

    # generate CSV file output.csv and force UTF-8
    csv = CSV.open("lib/tasks/#{search}_bing.csv", 'wb:UTF-8')
    headers = ['position','title','link','snippet']

    ar = strasse.xpath('//li[@class="sa_wr"]')
    a=[]
    a.push << headers
    ar.each_with_index do |node, index|
      #a.push << node.content.split
      final = []
      final.push(index+1)
      unless node.at_xpath('.//h3').nil?
        final.push(node.at_xpath('.//h3').inner_text)
      end
      unless node.at_xpath('.//cite').nil?
        final.push(node.at_xpath('.//cite').inner_text)
      end
      unless node.at_xpath('.//p').nil?
        final.push(node.at_xpath('.//p').inner_text)
      end
      #puts final
      a  << final
    end


    a.each { |a| csv << a }
  end

end