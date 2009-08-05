class PopulateTranslations < ActiveRecord::Migration
  
  def self.globalizable_content
    Globalize2Extension::GLOBALIZABLE_CONTENT
  end
  
  def self.up    
    globalizable_content.each do |model, columns|
      model.send(:all).each do |item|
        translation = item.globalize_translations.find_or_initialize_by_locale(Globalize2Extension.default_language.to_s)
        columns.each do |column|
          translation[column] = item[column]
        end
        translation.save
      end
    end
  end

  def self.down
  end
end
