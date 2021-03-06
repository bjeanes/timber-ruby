require "timber/event"
require "timber/util"

module Timber
  module Events
    # The HTTP server request event tracks incoming HTTP requests to your HTTP server.
    # Such as unicorn, webrick, puma, etc.
    #
    # @note This event should be installed automatically through integrations,
    #   such as the {Integrations::ActionController::LogSubscriber} integration.
    class HTTPServerRequest < Timber::Event
      attr_reader :body, :headers, :host, :method, :path, :port, :query_string, :request_id,
        :scheme

      def initialize(attributes)
        @body = attributes[:body] && Util::HTTPEvent.normalize_body(attributes[:body])
        @headers = Util::HTTPEvent.normalize_headers(attributes[:headers])
        @host = attributes[:host] || raise(ArgumentError.new(":host is required"))
        @method = Util::HTTPEvent.normalize_method(attributes[:method]) || raise(ArgumentError.new(":method is required"))
        @path = attributes[:path]
        @port = attributes[:port]
        @query_string = Util::HTTPEvent.normalize_query_string(attributes[:query_string])
        @scheme = attributes[:scheme] || raise(ArgumentError.new(":scheme is required"))
        @request_id = attributes[:request_id]
      end

      def to_hash
        {body: body, headers: headers, host: host, method: method, path: path, port: port,
          query_string: query_string, request_id: request_id, scheme: scheme}
      end
      alias to_h to_hash

      # Builds a hash representation of containing simply objects, suitable for serialization.
      def as_json(_options = {})
        {:http_server_request => to_hash}
      end

      def message
        'Started %s "%s"' % [method, path]
      end
    end
  end
end