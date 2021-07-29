# frozen_string_literal: true

# This translates a BuildingSearch into a format digestible by AgGrid
class BuildingGridTranslator
  def initialize(search)
    @search = search
  end

  def column_def
    columns.map { |column| column_config(column) }.to_json.html_safe
  end

  def row_data
    records.map do |record|
      hash = { id: record.id }
      columns.each do |column|
        value = record.field_for(column)
        value = { name: value, reviewed: record.reviewed? } if column == 'street_address'
        hash[column] = value
      end
      hash
    end.to_json.html_safe
  end

  private

  attr_reader :search

  delegate :columns, to: :search

  def records
    search.results
  end

  def column_config(column)
    options = {
      headerName: Translator.label(Building, column),
      field: column,
      resizable: true
    }
    options[:headerName] = 'Actions' if column == 'id'
    options[:pinned] = 'left' if %w[id street_address].include?(column)
    options[:cellRenderer] = 'actionCellRenderer' if column == 'id'
    options[:cellRenderer] = 'nameCellRenderer' if column == 'street_address'
    options[:width] = 200 if %w[name street_address description annotations].include?(column)
    options[:sortable] = true unless column == 'id'
    options
  end
end