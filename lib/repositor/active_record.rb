module Repositor
  module ActiveRecord
    attr_reader :model

    def initialize(model: nil)
      @model   = model || self.class.to_s.chomp("Repo").singularize.constantize
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

    def update(record, record_params)
      record.update(record_params)
      record
    end

    def destroy(record)
      record.destroy
    end

    def method_missing(method, *args)
      return unless args[0].instance_of? model

      unless args.drop(1).empty?
        args[0].send(method, args.drop(1))
      else
        args[0].send(method)
      end
    end
  end
end
