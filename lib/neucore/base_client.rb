module Neucore
  class BaseClient
    def initialize host = ''
      @host = host

      @conn = Faraday.new do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.ssl.verify = true
      end

      @multipart_conn = Faraday.new do |faraday|
        faraday.request :multipart
        faraday.adapter Faraday.default_adapter
        faraday.ssl.verify = true
      end
    end

    private
    attr_reader :conn, :multipart_conn, :host

    def do_request! method, url, params = {}, headers = {}
      param_in_get_body = params.delete(:param_in_get_body) || false
      timeout = params.delete(:timeout) || 60
      headers['Content-Type'] ||= 'application/json'
      Rails.logger.info "Request info contains url: #{url}, http method: #{method}, header: #{headers}, payload: #{params}"
      method = method.downcase.to_sym

      if method == :delete
        resp = conn.send(:delete, url, params, headers) do |req|
          req.options.timeout = timeout
        end
      elsif method == :get
        if param_in_get_body
          resp = conn.send(:get, url, {}, headers) do |req|
            req.options.timeout = timeout
            req.body = params.to_json
          end
        else
          resp = conn.send(:get, url, params, headers) do |req|
            req.options.timeout = timeout
          end
        end
      elsif %i(post put patch).include?(method)
        request_body =  case headers['Content-Type']
                        when 'application/json', 'application/vnd.whispir.message-v1+json'
                          params.to_json
                        when 'application/x-www-form-urlencoded', 'multipart/form-data'
                          URI.encode_www_form(params)
                        when 'text/xml'
                          Gyoku.xml(params, key_converter: :none)
                        else
                          params
                        end
        resp = conn.send(method, url) do |req|
          req.options.timeout = timeout
          req.body = request_body
          req.headers = headers
        end
      else
        raise "Unknow method: #{method}"
      end

      handle_response!(resp)
    end

    def do_multipart_request! method, url, params = {}, headers = {}
      Rails.logger.info "Request info contains url: #{url}, http method: #{method}, header: #{headers}, payload: #{params}"
      method = method.downcase.to_sym
      resp = multipart_conn.send(method, url) do |req|
        req.body = params
        req.headers = headers
      end

      handle_response!(resp)
    end

    def handle_response!(resp)
      Rails.logger.info "Response info contains code: #{resp.status}, header: #{resp.headers}, body: #{resp.body.force_encoding('utf-8')}"
      return resp if resp.headers['content-type'] =~ /text\/(xml|plain)/ 
      return resp if resp.headers['content-type'] == 'application/vnd.whispir.message-v1+json'

      if resp.status <= 299 && resp.status >= 200
        data = JSON.parse(resp.body) rescue []
        if data.is_a?(Array)
          data.map(&:deep_symbolize_keys)
        else
          data.deep_symbolize_keys rescue {}
        end
      else
        resp
      end
    end
  end
end
