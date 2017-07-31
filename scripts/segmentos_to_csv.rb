require 'csv'

matches_array = []

6.times do |n|
  matches_array << PerfectMatch.where(segment: n)
end

matches_array.each_with_index do |matches,index|
  CSV.open("scripts/results/PerfectMatch_#{index}.csv", "wb") do |csv|
    csv << ["Segmento","Record Name", "matches", "Relation id"]
    matches.each do |match|
      csv << [match.segment, match.relation.record_a.search, match.match_counts, match.relation.id]
    end
  end
end



#==========
matches_array = []

6.times do |n|
  matches_array << DirtyMatch.where(segment: n)
end

matches_array.each_with_index do |matches,index|
  CSV.open("scripts/results/DirtyMatch_#{index}.csv", "wb") do |csv|
    csv << ["Segmento","Record Name", "matches", "Relation id"]
    matches.each do |match|
      csv << [match.segment, match.relation.record_a.search, match.match_counts, match.relation.id]
    end
  end
end


#==========
matches_array = []

6.times do |n|
  matches_array << AllMatch.where(segment: n)
end

matches_array.each_with_index do |matches,index|
  CSV.open("scripts/results/AllMatch_#{index}.csv", "wb") do |csv|
    csv << ["Segmento","Record Name", "matches", "Relation id"]
    matches.each do |match|
      csv << [match.segment, match.relation.record_a.search, match.match_counts, match.relation.id]
    end
  end
end
