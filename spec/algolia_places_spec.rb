require 'spec_helper'

describe AlgoliaPlaces, :vcr do
  it 'has a version number' do
    expect(AlgoliaPlaces::VERSION).not_to be nil
  end

  describe '#coordinates' do
    context 'with environment variables' do
      subject{ described_class.coordinates '1649 HAVENBROOK, SUDBURY, Ontario' }
      
      it 'brings coordinates' do
        expect(subject).to eq [46.5333, -80.9329]
      end
      
      context 'with unknown location' do
        subject{ described_class.coordinates 'xwdwqdwqdwq dqwd wqwqdwqw' }
        
        it 'brings coordinates' do
          expect(subject).to eq [0, 0]
        end
      end
    end
    
    context 'with wrong credentials' do
      let(:logger) do
        Logger.new("#{AlgoliaPlaces.root}/log/test.log").tap do |l|
          l.level = Logger::INFO
        end
      end
      
      subject{ described_class.coordinates '1649 HAVENBROOK, SUDBURY, Ontario' }

      before do
        AlgoliaPlaces.instance.app_id = 'fake_id'
        AlgoliaPlaces.instance.api_key = 'fake_key'
        AlgoliaPlaces.instance.logger = logger
      end

      it 'returns zeroes' do
        expect(subject).to eq [0, 0]
      end
      
      context 'with rest error' do
        before do
          AlgoliaPlaces.instance.rest_exception = true
        end
        
        it 'raises error' do
          expect{ subject }.to raise_error(RestClient::Forbidden)
        end
      end
    end
  end
  
  describe '#hits' do
    context 'with environment variables' do
      subject{ described_class.hits '1649 HAVENBROOK, SUDBURY, Ontario' }
      
      it 'brings hits' do
        expect(subject.first).to be_kind_of(Hash)
      end
    end    
  end
end
