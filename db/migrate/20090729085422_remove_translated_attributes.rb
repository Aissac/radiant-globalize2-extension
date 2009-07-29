class RemoveTranslatedAttributes < ActiveRecord::Migration
  def self.globalizable_content
    Globalize2Extension::GLOBALIZABLE_CONTENT
  end
  
  def self.up
    globalizable_content.each do |model, columns|
      columns.each do |column|
        remove_column model.table_name, column
      end
      # add_column model.table_name, language_column_name, base_column.type, :limit => base_column.limit
    end
  end

  def self.down
  end
end
