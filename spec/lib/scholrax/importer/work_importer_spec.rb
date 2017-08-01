require 'rails_helper'

module Scholrax::Importer
  RSpec.describe WorkImporter do

    subject { described_class.new(export_path: export_path,
                                  admin_set_id: admin_set.id,
                                  metadata_mapping_file: metadata_mapping_file) }

    let(:export_path) { Rails.root.join('spec', 'fixtures', 'dspace_export', 'sample') }
    let(:admin_set) { AdminSet.new(title: [ 'Test Admin Set' ]) }
    let(:metadata_mapping_file) { Rails.root.join('spec', 'fixtures', 'dspace_export', 'metadata_mapping.yml') }
    let(:expected_file_set_labels) { [ 'ScholarlyArticle.pdf' ] }

    before do
      Hyrax::AdminSetCreateService.call(admin_set: admin_set, creating_user: nil)
    end

    it "creates the work, adding the metadata and files" do
      work = subject.call
      expect(work.admin_set).to eq(admin_set)
      expect(work.title).to match_array([ 'Cats Are Happiness' ])
      expect(work.file_sets.map(&:label)).to match_array(expected_file_set_labels)
    end
  end
end
