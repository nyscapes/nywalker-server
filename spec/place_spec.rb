require 'spec_helper'

describe Place do
  subject { build(:place) }
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  
  it 'fails if there is no name' do
    subject.name = nil
    expect{subject.save}.to raise_error Sequel::ValidationFailed
  end

  it 'fails if the name is too long' do
    subject.name = (1..60).map{|i| i}.join
    expect{subject.save}.to raise_error Sequel::DatabaseError
  end

  describe '#instance_count' do

    context 'when there are no instances' do
      it 'returns 0' do
        subject.save
        expect(subject.instance_count).to eq 0
      end
    end

    context 'when there is one instance' do
      it 'returns 1' do
        subject.save
        create(:instance, book: book, user: user, place: subject)
        expect(subject.instance_count).to eq 1
      end
    end

  end
end
