

PerfectMatch.delete_all
AllMatch.delete_all
DirtyMatch.delete_all

relations = Relation.all

relations.each do |r|
  puts "======Perfect=========="
  puts r.id
  puts "================"

  unless r.comparisons.count< 25
    count = r.comparisons.where(same_content:true).count
    if count>4
      PerfectMatch.create!(match_counts: count, segment: 5, relation: r)
    else
      PerfectMatch.create!(match_counts: count, segment: count, relation: r)
    end

  end
end


relations.each do |r|
  puts "=======Dirty========="
  puts r.id
  puts "================"

  count = r.comparisons.where(same_content:true).count
  if count>4
    DirtyMatch.create!(match_counts: count, segment: 5, relation: r)
  else
    DirtyMatch.create!(match_counts: count, segment: count, relation: r)
  end

end


relations.each do |r|
  puts "=======All========="
  puts r.id
  puts "================"

  count = r.similarities.where(same_content:true).count
  if count>4
    AllMatch.create!(match_counts: count, segment: 5, relation: r)
  else
    AllMatch.create!(match_counts: count, segment: count, relation: r)
  end

end
