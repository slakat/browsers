require 'rubygems'
require 'nokogiri'
require 'csv'

# define arrays including a dummy array which is needed for reasons i do not yet know :P
# remember that you can easily adapt this parser to suit your needs by defining additional variables
# and by adding additional xpath steps (doc.xpath...) below

class ScraperBing

  def self.bing(doc,id)

    # search elements via xpath and collect contents in arrays
    search = doc.at_xpath("//input[contains(@id,'sb_form_q')]")['value'].strip
    strasse = doc.xpath("//div[contains(@id,'results')]")

    # generate CSV file output.csv and force UTF-8
    #csv = CSV.open("lib/tasks/#{search}_bing.csv", 'wb:UTF-8')
    #headers = ['position','title','link','snippet']

    ar = strasse.xpath('//li[@class="sa_wr"]')
    a=[]
    #a.push << headers
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


    #a.each { |a| csv << a }
    a.each do |s|
      Result.create!(position: s[0] , title: s[1], link: s[2], snippet: s[3], record_id: id )
    end

  end
end


class ScraperGoogle

  def self.google(doc,id)

    # search elements via xpath and collect contents in arrays
    #search = doc.at_xpath("//input[contains(@id,'sbhost')]")['value'].strip
    strasse = doc.at_xpath("//div[contains(@id,'search')]")


    # generate CSV file output.csv and force UTF-8
    #csv = CSV.open("lib/tasks/#{search}_google.csv", 'wb:UTF-8')
    #headers = ['position','title','link','snippet']

    ar = strasse.xpath('//li[@class="g"]')
    a=[]
    #a.push << headers
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


   # a.each { |a| csv << a }
    a.each do |s|
      if s[3]
        s[3] = s[3].force_encoding("UTF-8")
      end
      Result.create!(position: s[0] , title: s[1], link: s[2], snippet: s[3], record_id: id )
    end
  end
end

index=0
Dir.foreach("lib/tasks/data") do |item|
  next if item[0] == '.' or item[0] == '..'
  time = File.mtime("lib/tasks/data/data_"+index.to_s)
  doc = Nokogiri::HTML(open('lib/tasks/data/data_'+index.to_s))
  puts doc.class   # => Nokogiri::HTML::Document
  puts item
  puts index
  # search elements via xpath and collect contents in arrays
  country = doc.search('ul.tbt li a.q/text()').first
  strasse = doc.xpath("//title").text

  if strasse.to_s.end_with?("Google")
    search = doc.at_xpath("//input[contains(@id,'sbhost')]")
    if search
      search = search['value']
    else
      search = strasse.to_s.split('-')[0]
    end
    search.strip
    r = Record.create!(search: search, country: country, browser: 'GOOGLE', dateprint: time.to_datetime,rol: "data_#{index}" )
    ScraperGoogle.google(doc,r.id)
  elsif strasse.to_s.end_with? 'Bing'
    search = doc.at_xpath("//input[contains(@id,'sb_form_q')]")['value'].strip
    r = Record.create!(search: search, country: country, browser: 'BING', dateprint: time.to_datetime,rol: "data_#{index}" )
    ScraperBing.bing(doc,r.id)
  end
  index+=1
end

=begin

12
13
1474
1478
3004
3005
11127
11168
11169
11335
=end
