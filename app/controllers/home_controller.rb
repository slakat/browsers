class HomeController < ApplicationController
  def index
    most_searched = Relation.all.group('search').order('count_search DESC').count('search')
  end
end
