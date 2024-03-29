require 'spec_helper'
require 'token_utils_lims'

RSpec.describe TokenUtilsLims do
  let(:uuid) { "00000000-0000-0000-0000-000000000001" }
  let(:wildcard) { "?variablename" }
  context '#is_uuid?' do
    it 'recognises an uuid' do
      expect(TokenUtilsLims.is_uuid?(uuid)).to eq(true)
    end
    it 'does not recognise a quoted uuid' do
      expect(TokenUtilsLims.is_uuid?(TokenUtilsLims.quote(uuid))).to eq(false)
    end
    it 'does not recognise a string that contains a uuid' do
      expect(TokenUtilsLims.is_uuid?("uuid: #{uuid} ")).to eq(false)
    end
  end
  context '#is_wildcard?' do
    it 'recognises a string that represents a wildcard' do
      expect(TokenUtilsLims.is_wildcard?(wildcard)).to eq(true)
    end
  end
  context '#is_valid_fluidx_barcode?' do
    it 'detects a valid fluidx barcode' do
      expect(TokenUtilsLims.is_valid_fluidx_barcode?("FR123456")).to eq(true)
    end
    it 'rejects invalid fluidx barcode' do
      expect(TokenUtilsLims.is_valid_fluidx_barcode?("12345678")).to eq(false)
    end
  end
  context '#pad' do
    it 'pads a string with a character using a length' do
      expect(TokenUtilsLims.pad("1234", "0", 8)).to eq("00001234")
      expect(TokenUtilsLims.pad("1234", "0", 2)).to eq("1234")
    end
  end

  context '#pad_location' do
    it 'does not change already padded locations' do
      expect(TokenUtilsLims.pad_location("A01")).to eq("A01")
    end
    it 'pads location not padded' do
      expect(TokenUtilsLims.pad_location("A1")).to eq("A01")
    end
  end

  context '#unpad_location' do
    it 'does not unpad already unpadded locations' do
      expect(TokenUtilsLims.unpad_location("A1")).to eq("A1")
    end
    it 'unpads location not unpadded' do
      expect(TokenUtilsLims.unpad_location("A01")).to eq("A1")
    end
  end

  context '#generate_positions' do
    it 'generates a padded list of well positions' do
      expect(TokenUtilsLims.generate_positions(('A'..'C').to_a, ('1'..'3').to_a)).to eq(
        ["A01", "B01", "C01", "A02", "B02", "C02", "A03", "B03", "C03"]
      )
    end
  end

  context '#quote' do
    it 'quotes an string' do
      expect(TokenUtilsLims.quote("abc")).to eq("\"abc\"")
    end
  end

  context '#unquote' do
    it 'unquotes a string' do
      expect(TokenUtilsLims.unquote("\"abc\"")).to eq("abc")
    end
  end

  context '#kind_of_asset_id?' do
    it 'detects when an argument is a uuid' do
      expect(TokenUtilsLims.kind_of_asset_id?(uuid)).to eq(true)
    end
    it 'detects when the argument is a wildcard' do
      expect(TokenUtilsLims.kind_of_asset_id?(wildcard)).to eq(true)
    end
    it 'does not fail when the argument is any other value' do
      [{}, nil, Object.new, "", "abc"].each do |val|
        expect(TokenUtilsLims.kind_of_asset_id?(val)).to eq(false)
      end
    end
  end
end
