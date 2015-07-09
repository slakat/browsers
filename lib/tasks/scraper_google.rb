require 'rubygems'
require 'nokogiri'
require 'csv'

# define arrays including a dummy array which is needed for reasons i do not yet know :P
# remember that you can easily adapt this parser to suit your needs by defining additional variables
# and by adding additional xpath steps (doc.xpath...) below

class ScraperGoogle

  def self.google(doc)

    # search elements via xpath and collect contents in arrays
    search = doc.at_xpath("//input[contains(@id,'sbhost')]")['value'].strip
    strasse = doc.at_xpath("//div[contains(@id,'search')]")


    # generate CSV file output.csv and force UTF-8
    csv = CSV.open("results/#{search}_google.csv", 'wb:UTF-8')
    headers = ['position','title','link','snippet']

    ar = strasse.xpath('//li[@class="g"]')
    a=[]
    a.push << headers
    index = 0
    ar.each do |node|
      #a.push << node.content.split
      final = []
      final.push(index+1)
      unless node.at_xpath('.//h3[@class="r"]').nil?
        final.push(node.at_xpath('.//h3[@class="r"]').inner_text)
      end
      unless node.at_xpath('.//cite').nil?
        final.push(node.at_xpath('.//cite').inner_text)
      end
      unless node.at_xpath('.//span[@class="st"]').nil?
        final.push(node.at_xpath('.//span[@class="st"]').inner_text)
      end

      if final.size <3
        next
      end
      #puts final
      a  << final
      index = index + 1
    end


    a.each { |a| csv << a }
  end

end
