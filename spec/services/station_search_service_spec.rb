require 'rails_helper'

RSpec.describe StationSearchService, type: :service do
  describe '.call' do
    context '有効な駅名が渡された場合' do
      it 'HeartRails Express APIから緯度と経度を取得できること' do
        json_response = {
          response: {
            station: [
              {
                'name' => '高円寺',
                'y' => '35.7058',
                'x' => '139.6495'
              }
            ]
          }
        }.to_json

        # Net::HTTP.get の返り値をモックする
        allow(Net::HTTP).to receive(:get).and_return(json_response)

        result = StationSearchService.call('高円寺')

        expect(result).to eq({ lat: 35.7058, lng: 139.6495 })
      end
    end

    context '存在しない駅名が渡された場合' do
      it 'nilを返すこと' do
        json_response = {
          response: {
            station: []
          }
        }.to_json

        allow(Net::HTTP).to receive(:get).and_return(json_response)

        result = StationSearchService.call('存在しない駅')

        expect(result).to be_nil
      end
    end
  end
end