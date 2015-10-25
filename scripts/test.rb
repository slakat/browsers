require 'rubygems'
require 'nokogiri'
require 'csv'
require 'nokogiri/diff'
require 'open-uri'
require 'digest'
require 'open_uri_redirections'
require 'domainatrix'
require 'fuzzystringmatch'


CSS_SELECTOR = 'html'.freeze
INTERVAL = 10.freeze
USER_AGENT = "Ruby/#{RUBY_VERSION}".freeze


def check_http(url)
  unless url.start_with? "http"
    return "http://"+url
  end
  return url
end


class SameOrigin
  def self.test(str1, str2)
    uri1 = URI.parse(URI.encode(str1))
    uri2 = URI.parse(URI.encode(str2))
    uri1.scheme == uri2.scheme && uri1.host == uri2.host && uri1.port == uri2.port
  end
end

puts SameOrigin.test "http://google.com", "http://google.com"     # => true
puts SameOrigin.test "http://google.com:80", "http://google.com"  # => true
puts SameOrigin.test "https://www.facebook.com/roberto.gaher", "https://es-la.facebook.com/public/M-Roberto-Ga-Glez
" # => false
puts SameOrigin.test "https://www.facebook.com/roberto.gaher
", "https://www.facebook.com/mroberto.gaglez"    # => false



u1 = check_http("https://www.facebook.com/roberto.gaher")
u2 = check_http("https://www.facebook.com/roberto.gaher")
url_a = URI.encode(u1)
url_b = URI.encode(u2)
puts "link A: =====> "+u1
begin
  doc1 = Nokogiri::HTML(open(URI.parse(url_a), :allow_redirections => :all, 'User-Agent' => USER_AGENT))
  doc2 = Nokogiri::HTML(open(URI.parse(url_b), :allow_redirections => :all, 'User-Agent' => USER_AGENT))
  delta = 0.1
  jarow = FuzzyStringMatch::JaroWinkler.create( :native )
  distance = jarow.getDistance(doc1.to_s, doc2.to_s) # 0.85 .. that is the text looks to be 85% similar
  puts distance
  if doc1.diff(doc2) and !u1.ends_with? u2
    puts "diferentes"
  else
    puts "iguales"
  end
rescue => error
  response = error.io
  puts response.status[0]+":"+response.status[1]
end


class SameOrigin2
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

puts SameOrigin2.relaxed_test "http://google.com", "http://google.com"     # => true
puts SameOrigin2.relaxed_test "http://google.com:80", "http://google.com"  # => true
puts SameOrigin2.relaxed_test "http://google.com", "http://www.google.com" # => false
puts SameOrigin2.relaxed_test "https://google.com", "http://google.com"    # => false
puts SameOrigin2.relaxed_test "https://www.facebook.com/roberto.gaher", "https://es-la.facebook.com/public/M-Roberto-Ga-Glez
" # => false
puts SameOrigin2.relaxed_test "https://www.facebook.com/roberto.gaher
", "https://www.facebook.com/mroberto.gaglez"    # => false

puts SameOrigin2.relaxed_test2 "http://google.com", "http://google.com"     # => true
puts SameOrigin2.relaxed_test2 "http://google.com:80", "http://google.com"  # => true
puts SameOrigin2.relaxed_test2 "http://google.com", "http://www.google.com" # => false
puts SameOrigin2.relaxed_test2 "https://google.com", "http://google.com"    # => false
puts SameOrigin2.relaxed_test2 "https://www.facebook.com/roberto.gaher", "https://es-la.facebook.com/public/M-Roberto-Ga-Glez
" # => false
puts SameOrigin2.relaxed_test2 "https://www.facebook.com/roberto.gaher
", "https://www.facebook.com/mroberto.gaglez"    # => false