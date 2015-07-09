def link(input)
  input.map { |k, v| v.map { |h| [k, h] } }
      .inject(:+)
      .group_by   { |_, h| h[:dateprint]                      }
      .select     { |_, a| a.length == input.length    }
      .inject({}) { |h, (n, v)| h.update(n => Hash[v]) }
end

#a=link :a => Record.all


#a.map { |k, v| v.map { |h| [k, h] } }

=begin
a=Record.select("COUNT(dateprint) as total, dateprint").
    group(:dateprint).
    having("COUNT(dateprint) > 1").
    order(:dateprint).
    map{|p| {p.dateprint => p.total} }


a=[]
@records = Record.all.group_by { |record| record.dateprint.to_date }

@records.sort.each do | day, records|
  puts day.strftime('%B %d')
  m=records.group("date_format(created_at, '%Y%m%d %H')").count#.group_by{|rec| rec[:dateprint].hour}
  m.each do |hour, s|
    puts hour
    f=s.sort_by{|obj| obj[:dateprint]}
    for n in f
      if

      end
    end
  end

end

=end

Record.all.each do |a|
  if Relation.where(record_b_id: a.id).first.nil? & Relation.where(record_a_id: a.id).first.nil?
    records = Record.where(search: a.search, dateprint: a.dateprint-15.seconds..a.dateprint+15.seconds).order(:dateprint)
    if records.count >1 and records.first.search == records.second.search and (Relation.where(record_b_id: records.first.id).first.nil? & Relation.where(record_a_id: records.first.id).first.nil?) and(Relation.where(record_b_id: records.second.id).first.nil? & Relation.where(record_a_id: records.second.id).first.nil?)
      Relation.create!(record_a_id: records.first.id, record_b_id: records.second.id, search: a.search,time_a: records.first.dateprint,time_b: records.second.dateprint )
      puts a.search
    end
  end

end