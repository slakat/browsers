require 'rubygems'
require 'nokogiri'
require 'csv'
require 'nokogiri/diff'
require 'open-uri'
require 'digest'
require 'open_uri_redirections'
require 'domainatrix'
require 'fuzzystringmatch'


class SameOrigin
  def self.relaxed_test(str1, str2)
    d1 = Domainatrix.parse(URI.encode(str1))
    d1 = Domainatrix.parse(URI.encode(str2))

    uri1 = URI.parse(URI.encode(str1))
    uri2 = URI.parse(URI.encode(str2))

    uri1.scheme == uri2.scheme &&
        d1.domain == d1.domain &&
        d1.public_suffix == d1.public_suffix &&
        uri1.port == uri2.port
  end

  def self.relaxed_test2(str1, str2)
    uri1 = URI.parse(URI.encode(str1))
    uri2 = URI.parse(URI.encode(str2))

    re = /^(?:(?>[a-z0-9-]*\.)+?|)([a-z0-9-]+\.(?>[a-z]*(?>\.[a-z]{2})?))$/i
    domain1 = uri1.host.gsub(re, '\1').strip
    domain2 = uri2.host.gsub(re, '\1').strip

    uri1.scheme == uri2.scheme && domain1 == domain2 && uri1.port == uri2.port
  end
end


CSS_SELECTOR = 'html'.freeze
INTERVAL = 10.freeze
USER_AGENT = "Ruby/#{RUBY_VERSION}".freeze

jarow = FuzzyStringMatch::JaroWinkler.create( :native )

def check_http(url)
  unless url.start_with? "http"
    return "http://"+url
  end
  return url
end

content = false
relation = false

Relation.all.each do |r|
  results_a = r.record_a.results
  results_b = r.record_b.results

  results_a.each do |a|
    u1 = check_http(a.link)
    url_a = URI.encode(u1)
    begin
      content = false
      relation = false
      doc1 = Nokogiri::HTML(open(URI.parse(url_a), :allow_redirections => :all, 'User-Agent' => USER_AGENT))

      results_b.each do |b|
        content = false
        relation = false

        if Comparison.where(result_a: a,result_b: b).blank?
          u2 = check_http b.link
          url_b = URI.encode(u2)
          puts "link A: =====> "+u1
          puts "link B: =====> "+u2
          begin
            doc2 = Nokogiri::HTML(open(URI.parse(url_b), :allow_redirections => :all, 'User-Agent' => USER_AGENT))
            distance = jarow.getDistance(doc1.to_s, doc2.to_s)>0.8 # 0.85 .. that is the text looks to be 85% similar
            if (SameOrigin.relaxed_test2 u1, u2)
              puts "related"
              relation = true
            else
              puts "not similiar"
            end


            if (doc1.diff(doc2) and distance)
              puts "same"
              content = true
            else
              puts "different"

            #sleep INTERVAL
            end

            Comparison.create!(result_a: a, result_b: b,same_content:content,related_pages: relation, relation: r, error: nil)
          rescue => error
            response = error.io
            msg = response.status[0]+":"+response.status[1]
            puts msg
            Comparison.create!(result_a: a, result_b: b,same_content:content,related_pages: relation, relation: r, error: msg)
          end

        end
      end

    rescue => error
      response = error.io
      msg = response.status[0]+":"+response.status[1]
      puts msg
      if Comparison.where(result_a: a,result_b: nil).blank?
        Comparison.create!(result_a: a, result_b: nil,same_content:content,related_pages: relation, relation: r, error: msg)
      end
    end


  end
end
