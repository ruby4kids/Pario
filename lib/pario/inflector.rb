module Inflector
  module String
    def camelize
      self.gsub!(/(.)([A-Z])/,'\1_\2').downcase!
    end
  
    def capitalize
      self.to_s.gsub(/\b\w/){$&.upcase}
    end
  end
end

class String
    include Inflector::String
end