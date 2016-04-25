require 'active_support/core_ext/module/delegation'
require 'active_support/inflector'

module Repositor
  module ActiveRecord
    attr_reader :model

    delegate :find, :all, :new, :create, :update, :destroy, to: :model

    def initialize(model: nil)
      @model = model || self.class.to_s.chomp("Repo").singularize.constantize
    end

    # Common find process with supporting of friendly_id params
    def find_or_initialize(id, friendly: false)
      friendly ? friendly_find(id) : model.find(id)
    rescue ::ActiveRecord::RecordNotFound
      model.new
    end

    # Support for `friendly_id` gemf out of box
    def friendly_find(slugged_id)
      model.friendly.find(slugged_id)
    end

    # All methods that have instance object as first argument
    # will be redirected to itself with all other arguments
    # `some_repo.new_record?(record)`
    # same as
    # `record.new_record?`
    # But gives you more control under persistence process
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
