module Blacklight::Document::CsvExport
  require 'csv'

  def self.extended(document)
    document.will_export_as(:csv, "text/csv")
  end
  def to_csv
    document = self
    str = ''
    ((::CSV::Writer if ::CSV.const_defined? :Writer) || ::CSV).generate(str) do |csv|
      arr = [document.id, document.get('title_display')]
      field_names_for_csv.each do |solr_fname|
        arr << document.get(solr_fname) || nil
      end
      csv << arr
    end

    str
  end
  def export_as_csv
    str = ''
    ((::CSV::Writer if ::CSV.const_defined? :Writer) || ::CSV).generate(str) do |csv|
      csv << ['id', 'title_display', field_names_for_csv].flatten
    end
    str + self.to_csv.to_s
  end

  def field_names_for_csv
    Blacklight.config[:index_fields][:field_names]
  end
end

