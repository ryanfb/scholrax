# Generated via
#  `rails generate hyrax:work Article`
class Article < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = ArticleIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Article'

  property :institution, predicate: ::RDF::URI.new('http://id.loc.gov/vocabulary/relators/dgg'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :publication_date, predicate: ::RDF::Vocab::DC.issued, multiple: false do |index|
    index.as :stored_searchable
  end

  property :doi, predicate: ::RDF::URI.new('http://id.loc.gov/vocabulary/identifiers/doi'), multiple: false do |index|
    index.as :stored_searchable
  end

  # property :license, predicate: ::RDF::Vocab::DC.license, multiple: false do |index|
  #   index.as :stored_searchable
  # end

  property :abstract, predicate: ::RDF::Vocab::DC.abstract, multiple: false do |index|
    index.as :stored_searchable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
