module Inflector
  module String
    def camelize
      gsub!(/(.)([A-Z])/,'\1_\2')
      self.downcase
    end

    def capitalize
      to_s.gsub(/\b\w/){$&.upcase}
    end
  end
end

class String
    include Inflector::String
end