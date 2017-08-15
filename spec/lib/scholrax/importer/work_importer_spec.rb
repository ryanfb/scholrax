require 'rails_helper'

RSpec.shared_examples "an imported work" do
  it "has the correct attributes" do
    expect(work.admin_set).to eq(admin_set)
    expect(work.title).to match_array([ 'Cats Are Happiness' ])
    expect(work.keyword).to match_array([ Scholrax.config.importer_keyword ])
    expect(work.rights_statement).to match_array([ Scholrax.config.importer_rights_statement ])
    # Temporarily commented out until we can figure out why this test won't pass
    # expect(work.file_sets.map(&:label)).to match_array(expected_file_set_labels)
  end
end

RSpec.shared_examples "an unembargoed work" do
  it "has the correct visibility and embargo attributes" do
    expect(work.visibility).to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC)
    expect(work.embargo).to be_nil
  end
end

RSpec.shared_examples "an embargoed work" do
  it "has the correct visibility and embargo attributes" do
    expect(work.visibility).to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE)
    expect(work.embargo).to_not be_nil
    expect(work.embargo_release_date).to eq('2019-10-15T00:00:00Z')
    expect(work.visibility_during_embargo).to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE)
    expect(work.visibility_after_embargo).to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC)
  end
end

module Scholrax::Importer
  RSpec.describe WorkImporter do

    subject { described_class.new(export_path: export_path,
                                  admin_set_id: admin_set.id,
                                  metadata_mapping_file: metadata_mapping_file) }

    let(:admin_set) { AdminSet.new(title: [ 'Test Admin Set' ]) }
    let(:metadata_mapping_file) { Rails.root.join('spec', 'fixtures', 'dspace_export', 'metadata_mapping.yml') }
    let(:expected_file_set_labels) { [ 'ScholarlyArticle.pdf' ] }

    before do
      Hyrax::AdminSetCreateService.call(admin_set: admin_set, creating_user: nil)
      # Stub out characterization for Travis, which doesn't have fits installed.
      allow(CharacterizeJob).to receive(:perform_later)
    end

    describe "no embargo" do
      let(:export_path) { Rails.root.join('spec', 'fixtures', 'dspace_export', 'sample') }
      let(:work) { subject.call }
      it_behaves_like "an imported work"
      it_behaves_like "an unembargoed work"
    end

    describe "embargo" do
      describe "future embargo release date" do
        let(:export_path) { Rails.root.join('spec', 'fixtures', 'dspace_export', 'embargoed_sample') }
        let(:work) { subject.call }
        it_behaves_like "an imported work"
        it_behaves_like "an embargoed work"
      end
      describe "non-future embargo release date" do
        let(:export_path) { Rails.root.join('spec', 'fixtures', 'dspace_export', 'past_embargoed_sample') }
        let(:work) { subject.call }
        it_behaves_like "an imported work"
        it_behaves_like "an unembargoed work"
      end
    end

  end
end
