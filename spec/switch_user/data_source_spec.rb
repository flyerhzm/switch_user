require 'switch_user/data_source'

module SwitchUser
  RSpec.describe DataSources do
    describe '#all' do
      it 'aggregates multiple data_sources' do
        user = double(:user)
        s1 = double(:s1, :all => [user])
        source = DataSources.new([s1, s1])

        expect(source.all).to eq [user, user]
      end
    end

    describe '#find_scope_id' do
      it 'can find a corresponding record across data sources' do
        user = double(:user)
        s1 = double(:s1, :find_scope_id => nil)
        s2 = double(:s2, :find_scope_id => user)
        source = DataSources.new([s1, s2])

        expect(source.find_scope_id("user_10")).to eq user
      end
    end
  end

  RSpec.describe DataSource do
    pending # it's tested in integration test, need to find a good way to test it here.
  end

  RSpec.describe GuestDataSource do
    let(:source) { GuestDataSource.new }

    describe '#all' do
      it 'gets a GuestRecord' do
        expect(source.all.size).to eq 1
        expect(source.all.first).to be_instance_of GuestRecord
      end
    end

    describe '#find_scope_id' do
      it 'gets nil' do
        expect(source.find_scope_id('')).to be_nil
      end
    end
  end

  RSpec.describe Record do
    let(:source) { DataSource.new({}, :user, :id, :email) }
    let(:user) { double(:user, id: '1', email: 'flyerhzm@gmail.com') }
    let(:record) { Record.new(user, source) }

    describe '#label' do
      it 'gets user email' do
        expect(record.label).to eq 'flyerhzm@gmail.com'
      end
    end

    describe '#scope' do
      it 'gets user' do
        expect(record.scope).to eq :user
      end
    end

    describe '#scope_id' do
      it 'gets scope and id' do
        expect(record.scope_id).to eq 'user_1'
      end
    end
  end

  RSpec.describe GuestRecord do
    let(:record) { GuestRecord.new }

    describe '#label' do
      it 'gets Guest' do
        expect(record.label).to eq 'Guest'
      end
    end

    describe '#scope_id' do
      it 'gets nil' do
        expect(record.scope_id).to be_nil
      end
    end
  end
end
