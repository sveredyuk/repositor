RSpec.describe 'Query' do
  let(:query)          { ThingQuery }
  let(:query_instance) { ThingQuery.new }

  describe '#initialize' do
    context 'without any attributes' do
      it 'defines the model' do
        expect(query_instance.model).to eq Thing
      end
    end

    context 'with model attribute' do
      it 'defines custom model' do
        expect(query.new(model: AnotherThing).model).to eq AnotherThing
      end
    end
  end

  describe '#all' do
    it 'resend all method to model' do
      expect(Thing).to receive(:all)
      query_instance.all
    end
  end

  describe '#first' do
    it 'resend all method to model' do
      expect(Thing).to receive(:first)
      query_instance.first
    end
  end

  describe '#last' do
    it 'resend all method to model' do
      expect(Thing).to receive(:first)
      query_instance.first
    end
  end
end
