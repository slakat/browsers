
product_name = "data_";
id = 0;

filenames = Dir.glob("lib/tasks/data/*.html")

filenames.each do |filename|
  File.rename("lib/tasks/data/"+filename, product_name + id.to_s+'.html')
  id += 1
end