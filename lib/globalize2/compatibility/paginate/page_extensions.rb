module Globalize2::Compatibility
  module Paginate::PageExtensions
    def self.included(base)
      base.class_eval do
        alias_method_chain 'tag:paginate', :globalize
      end
    end
  end
end