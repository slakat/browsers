hydra = Typhoeus::Hydra.hydra

first_request = Typhoeus::Request.new(Result.first.link)
first_request.on_complete do |response|
  puts response.body
  third_request = Typhoeus::Request.new(Result.second.link)
  hydra.queue third_request
end
second_request = Typhoeus::Request.new(Result.third)

hydra.queue first_request
hydra.queue second_request
hydra.run # this is a blocking call that returns once all requests are complete