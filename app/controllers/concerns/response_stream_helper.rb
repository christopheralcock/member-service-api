require 'net/http'

module ResponseStreamHelper
  def response_streamer(query)
    response.content_type = 'application/n-triples'

    Net::HTTP.start(URI(DATA_ENDPOINT).host) do |client|
      request = Net::HTTP::Post.new(URI(DATA_ENDPOINT))

      request.set_form_data('query' => query)
      request.add_field('Accept', 'application/n-triples')

      client.request(request) do |turtle_response|
        turtle_response.read_body do |segment|
          response.stream.write segment
        end
      end
    end
  end
end