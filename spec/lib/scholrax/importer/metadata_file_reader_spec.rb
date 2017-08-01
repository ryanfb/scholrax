require 'rails_helper'

module Scholrax::Importer
  RSpec.describe MetadataFileReader do

    describe "files hash" do
      let(:metadata_file_path) { Rails.root.join('spec', 'fixtures', 'dspace_export', 'sample', 'dublin_core.xml') }
      let(:metadata_mapping_file) { Rails.root.join('spec', 'fixtures', 'dspace_export', 'metadata_mapping.yml') }
      let(:expected_hash) { { 'creator' => [ 'Adams, A', 'Barnes, B'],
                              'based_near' => [ 'England' ],
                              'date_created' => [ '2017-07-10T21:37:32Z' ],
                              'identifier' => [ 'https://www.ncbi.nlm.nih.gov/pubmed/999999', 'abc.012.12345' ],
                              'title' => [ 'Cats Are Happiness' ] } }
      subject { described_class.new(metadata_file_path, metadata_mapping_file) }
      it "returns the expected hash of metadata" do
        expect(subject.call).to match(expected_hash)
      end
    end

  end
end
