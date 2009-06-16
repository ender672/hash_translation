# Copyright 2009 Timothy Elliott (tle@holymonkey.com).

require 'blankslate.rb'

module HashTranslation
  def self.translate(target, *sources)
    builder = HashBuilder.new target
    readers = sources.map{|s| HashReader.new s}
    yield builder, *readers
  end

  class ScopedHash < BlankSlate
    def initialize(hash = nil, parent = nil)
      hash ||= {}
      @hash = hash
      @parent = parent
      @temp_hash = []
    end

    def [](key)
      sub_method_missing key
    end

    def target!
      @hash
    end

    def to_s
      @hash.to_s
    end

    def inspect
      @hash.inspect
    end

    def set_target!(hash)
      @hash = hash
    end

    def method_missing(method, *args, &block)
      if method.to_s[-1] == ?!
        @hash.send method.to_s.chop.to_sym, *args, &block
      else
        sub_method_missing method, *args, &block
      end
    end

    protected

    def focus_on!(target)
      @temp_hash.push @hash
      @hash = target
      @parent.focus_on! target if @parent
    end

    def go_back_to_original!
      @hash = @temp_hash.pop
      @parent.go_back_to_original! if @parent
    end

    private

    def ancestors_target_me_while_i_run_this!(key, &block)
      focus_on! @hash[key]
      block.call self
      go_back_to_original!
    end
  end
  
  class HashBuilder < ScopedHash
    def []=(key, value)
      sub_method_missing key, value
    end

    def sub_method_missing(key, *args, &block)
      if key.to_s.size > 1 && key.to_s[-1] == ?=
        sub_method_missing key.to_s.chop.to_sym, *args, &block
      else
        if args[0]
          @hash[key] = args[0]
        elsif args.size == 1 && args[0].nil?
          @hash[key] = nil
        elsif !@hash[key].kind_of?(Hash)
          @hash[key] = {}
        end
        ancestors_target_me_while_i_run_this! key, &block if block
        val = @hash[key]
        val.kind_of?(Hash) ? HashBuilder.new(val, self) : val
      end
    end
  end

  class HashReader < ScopedHash
    def sub_method_missing(key, *args, &block)
      if block
        ancestors_target_me_while_i_run_this! key, &block
      elsif @hash[key].kind_of? Hash
        HashReader.new @hash[key], self
      else
        @hash[key]
      end
    end
  end
end
