require 'net/http'

module ResponseStreamHelper
  def response_streamer(uri)
    response.content_type = 'application/n-triples'

    Net::HTTP.start(uri.host) do |client|
      request = Net::HTTP::Get.new uri

      request.add_field('Accept', 'application/n-triples')

      client.request(request) do |turtle_response|
        turtle_response.read_body do |segment|
          response.stream.write segment
        end
      end
    end
  end
end