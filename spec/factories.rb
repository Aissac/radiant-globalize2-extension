Factory.define(:page) do |f|
  f.sequence(:title) { |i| "Cool Page #{i}" }
  f.slug { |a| a.title.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=+]+/, '-') }
  f.breadcrumb { |a| a.title }
end

Factory.define(:romanian_page_translation, :class => "page_translation", :parent => :page) do |f|
  f.locale "ro"
  f.association :page, :factory => :page
  f.title "Pagina Cool"
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

Factory.define(:layout) do |f|
  f.sequence(:name) { |i| "Cool layout #{i}" }
  f.content "english content"
end

Factory.define(:snippet) do |f|
  f.sequence(:name) { |i| "Cool snippet #{i}" }
  f.content "english content"
end

Factory.define(:child_page, :class => "page", :parent => :page) do |f|
  f.sequence(:title) {|i| "Child page #{i}"}
  f.association :parent, :factory => :page
  f.status_id 100
end