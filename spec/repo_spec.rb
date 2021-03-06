RSpec.describe 'Repo' do
  let(:repo)          { ThingRepo }
  let(:repo_instance) { ThingRepo.new }
  let(:thing)         { Thing.new }

  describe '#initialize' do
    context 'without any attributes' do
      it 'defines the model' do
        expect(repo_instance.model).to eq Thing
      end
    end

    context 'with model attribute' do
      it 'defines custom model' do
        expect(repo.new(model: AnotherThing).model).to eq AnotherThing
      end
    end
  end

  describe '#find' do
    it 'resend find method to model' do
      expect(Thing).to receive(:find).with(1)
      repo_instance.find(1)
    end
  end

  describe '#new' do
    it 'resend new method to model' do
      expect(Thing).to receive(:new)
      repo_instance.new
    end
  end

  describe '#create' do
    it 'resend create method to model' do
      expect(Thing).to receive(:create).with(data: 'data')
      repo_instance.create(data: 'data')
    end
  end

  describe '#update' do
    it 'resend update method to model' do
      expect(repo_instance).to receive(:update).with(data: 'new_data')
      repo_instance.update(data: 'new_data')
    end
  end

  describe '#destroy' do
    it 'resend destroy method to model' do
      expect(repo_instance).to receive(:destroy)
      repo_instance.destroy
    end
  end

  describe '#method_missing' do
    context 'when allowed' do
      before do
        ThingRepo.class_eval do
          allow_instance_methods :hello
        end
      end

      it 'redirect record method to record instance' do
        expect(repo_instance.hello(thing)).to eq "hello"
      end
    end

    context 'when not allowed (not defined)' do
      it 'raise NoMethodError error' do
        expect{repo_instance.yeah(thing)}.to raise_error(NoMethodError)
      end
    end

    it 'return nil if record not instance of model' do
      expect(repo_instance.hello(Object.new)).to be_nil
    end
  end
end
