require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @req = req
      @route_params = {}
      @route_params.merge!(parse_www_encoded_form(req.query_string)) if req.query_string
      @route_params.merge!(parse_www_encoded_form(req.body)) if req.body
      @route_params.merge!(route_params)
    end

    def [](key)
      @route_params[key.to_s] || @route_params[key.to_sym]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      parse = www_encoded_form.split(/\=|\&|\|/)
      parse.map! {|code| parse_key(code).map!{|sym| sym.to_s} }
      modified_parse = Hash.new
      parse.each_with_index do |arr,idx|
        modified_parse[parse[idx]] = parse[idx+1] if idx.even?
      end
      parse_to_hash_improved(modified_parse)

    end
    #
    # def parse_to_hash(parse)
    #   h = Hash.new
    #   parse.each do |arr|
    #     h[arr[0]] ||= {arr[1] => {}}
    #     current = h[arr[0]][arr[1]]
    #     idx = 2
    #     arr[2..-2].each do |key|
    #       if arr[idx] == arr[-2]
    #         current[arr[idx]] ||= arr[idx+1]
    #       else
    #         current[arr[idx]] ||= { arr[idx+1] =>{} }
    #         current = current[arr[idx]][arr[idx+1]]
    #       end
    #       idx += 1
    #     end
    #   end
    #   h
    # end

    def parse_to_hash_improved(hash)
      h = Hash.new
      hash.keys.each do |keys|
        current = h
        keys[0..-2].each do |key|
          current[key] ||= {}
          current = current[key]
        end
        current[keys.last] = hash[keys].first
      end
      h
    end
    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
