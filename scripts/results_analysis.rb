require 'rubygems'
require 'nokogiri'
require 'csv'
require 'nokogiri/diff'
require 'open-uri'
require 'digest'
require 'open_uri_redirections'

CSS_SELECTOR = 'html'.freeze
INTERVAL = 10.freeze
USER_AGENT = "Ruby/#{RUBY_VERSION}".freeze


def check_http(url)
  unless url.start_with? "http"
    return "http://"+url
  end
  return url
end


Relation.all.each do |r|
  results_a = r.record_a.results
  results_b = r.record_b.results

  results_a.each do |a|
    u1 = check_http(a.link)
    url_a = URI.encode(u1)
    puts "link A: =====> "+u1
    begin
      doc1 = Nokogiri::HTML(open(URI.parse(url_a), :allow_redirections => :all, 'User-Agent' => USER_AGENT))

      results_b.each do |b|
        u2 = check_http b.link
        url_b = URI.encode(u2)
        puts "link B: =====> "+u2
        begin
          doc2 = Nokogiri::HTML(open(URI.parse(url_b), :allow_redirections => :all, 'User-Agent' => USER_AGENT))

          if doc1.diff(doc2) and !u1.ends_with? u2
            puts "different"
          else
            puts "same"

          #sleep INTERVAL
          end
        rescue => error
          response = error.io
          puts response.status[0]+":"+response.status[1]
        end
      end
    rescue => error
      response = error.io
      puts response.status[0]+":"+response.status[1]
    end


  end
end
