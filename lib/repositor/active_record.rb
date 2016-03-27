module Repositor
  module ActiveRecord
    attr_reader :model, :options

    def initialize(model: nil, options = {})
      @model   = model || self.class.to_s.chomp("Repo").singularize.constantize
      @options = options
    end

    def find(record_id)
      model.send :find, record_id
    end

    def all
      model.send :all
    end

    def new
      model.send :new
    end

    def create(record_params)
      model.send :create, record_params
    end

    def update(record_id, record_params)
      find(record_id).tap do |record|
        record.update(record_params)
      end
    end

    def destroy(record_id)
      find(record_id).destroy
    end
  end
end
