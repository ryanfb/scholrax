require 'rails_helper'

module Scholrax::Importer
  RSpec.describe WorksFolderImporter do

   subject { described_class.new(export_top_folder: export_top_folder,
                                 admin_set_id: admin_set_id,
                                 metadata_mapping_file: metadata_mapping_file) }


    let(:export_top_folder) { Rails.root.join('spec', 'fixtures', 'dspace_export') }
    let(:admin_set_id) { 'TestAdminSet_123' }
    let(:metadata_mapping_file) { Rails.root.join('spec', 'fixtures', 'dspace_export', 'metadata_mapping.yml') }
    let(:expected_paths) { [ File.join(export_top_folder, 'sample'),
                             File.join(export_top_folder, 'embargoed_sample'),
                             File.join(export_top_folder, 'past_embargoed_sample') ] }

    it "enqueues the expected jobs" do
        expected_paths.each do |e|
        	expected_args = {
        		export_path: e,
        		admin_set_id: admin_set_id,
        		metadata_mapping_file: metadata_mapping_file }
        	expect(WorkImporterJob).to receive(:perform_later).with(expected_args)
        end

        subject.call
    end
  end
end
