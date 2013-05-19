require "json"

module Linda

  class Tuple
    attr_reader :data, :type, :expire_at
    def initialize(data, opts={})
      unless data.kind_of? Array or data.kind_of? Hash
        raise ArgumentError, 'argument must be instance of Array or Hash'
      end
      @data = data
      @type = data.class
      if opts[:expire].class == Fixnum and opts[:expire] > 0
        @expire_at = Time.now + opts[:expire]
      end
    end

    def match?(target)
      target = self.class.new target unless target.kind_of? self.class
      return false if @type != target.type
      if @type == Array
        return false if @data.length > target.data.length
        @data.each_with_index do |v,i|
          return false if target.data[i] != v
        end
        return true
      elsif @type == Hash
        @data.each do |k,v|
          return false if target.data[k] != v
        end
        return true
      end
      false
    end

    def to_s
      @data.to_s
    end

    def to_json(*a)
      @data.to_json(*a)
    end

  end

end
