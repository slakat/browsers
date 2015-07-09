Record.all.each do |r|
  if Relation.where(record_a_id: r.id).first.nil? and Relation.where(record_b_id: r.id).first.nil?
    puts "#{r.id} #{r.search} #{r.dateprint} #{r.browser} #{r.country}"
  end
end