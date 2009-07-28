class CreateTranslationTables < ActiveRecord::Migration
  
  def self.globalizable_content
    Globalize2Extension::GLOBALIZABLE_CONTENT
  end
  
  def self.up
    globalizable_content.each do |model, columns|
      globalize_columns = {}
      columns.each do |column|
        base_column = model.columns.detect { |col| col.name == column.to_s } 
        globalize_columns[column] = base_column.type
      end
      model.create_translation_table! globalize_columns
    end
  end

  def self.down
    globalizable_content.each do |model, columns|
      model.drop_translation_table!
    end
  end
end