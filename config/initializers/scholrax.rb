require 'scholrax'

Scholrax.config do |config|

  config.importer_keyword = ENV['IMPORTER_KEYWORD'] || 'keyword'
  config.importer_rights_statement = ENV['IMPORTER_RIGHTS_STATEMENT'] || 'http://rightsstatements.org/vocab/CNE/1.0/'

end
