module Globalize2
  module PageExtensions
    def self.included(base)
      base.reflections[:children].options[:order] = 'pages.virtual DESC'
    end
  end
end