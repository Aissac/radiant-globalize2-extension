module Globalize2::Compatibility
  module Archive::ArchivePageExtensions
    def self.included(base)
      base.class_eval do
        def child_url(child)
          date = child.published_at || Time.now
        
          if ArchiveYearIndexPage === child
            clean_url "#{ url }/#{ date.strftime '%Y' }/"
          elsif ArchiveMonthIndexPage === child
            clean_url "#{ url }/#{ date.strftime '%Y/%m' }/"
          elsif ArchiveDayIndexPage === child
            clean_url "#{ url }/#{ date.strftime '%Y/%m/%d/' }/"
          else
            clean_url "#{ url }/#{ date.strftime '%Y/%m/%d' }/#{ child.slug }"
          end
        end
      end
    end
  end
end