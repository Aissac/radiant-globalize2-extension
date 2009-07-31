Factory.define(:page) do |f|
  f.title "Cool Page"
  f.slug { |a| a.title.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=+]+/, '-') }
  f.breadcrumb { |a| a.title }
end

Factory.define(:romanian_page_translation, :class => "page_translation") do |f|
  f.locale "ro"
  f.association :page, :factory => :page
  f.title "Pagina Cool"
  f.slug { |a| a.title.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=+]+/, '-') }
  f.breadcrumb { |a| a.title }
end

Factory.define(:not_translated_page, :class => 'page') do |f|
  f.title "Not Translated Page"
  f.slug { |a| a.title.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=+]+/, '-') }
  f.breadcrumb { |a| a.title }
end

Factory.define(:page_part) do |f|
  f.name "body"
  f.association :page, :factory => :page
  f.content "english content"
end

Factory.define(:romanian_page_part_translation, :class => "page_part_translation") do |f|
  f.locale "ro"
  f.association :page_part, :factory => :page_part
  f.content "continut romanesc"
end

Factory.define(:not_translated_page_part, :class => "page_part") do |f|
  f.name "body"
  f.association :page, :factory => :page
  f.content "not-translated"
end

Factory.define(:child_page, :class => "page") do |f|
  f.title "Child Page"
  f.slug { |a| a.title.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=+]+/, '-') }
  f.breadcrumb { |a| a.title }
  f.association :parent, :factory => :page
end

Factory.define(:another_page, :class => "page") do |f|
  f.title "Another Page"
  f.slug { |a| a.title.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=+]+/, '-') }
  f.breadcrumb { |a| a.title }
  f.association :parent, :factory => :page
end