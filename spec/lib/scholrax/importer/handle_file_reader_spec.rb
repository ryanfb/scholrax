require 'rails_helper'

module Scholrax::Importer
  RSpec.describe HandleFileReader do

    describe "call" do
      let(:handle_file_path) { Rails.root.join('spec', 'fixtures', 'dspace_export', 'sample', 'handle') }

      subject { described_class.new(handle_file_path) }
      it "returns the expected handle" do
        expect(subject.handle_id).to eq ('12345/98765')
      end
    end

  end
end
