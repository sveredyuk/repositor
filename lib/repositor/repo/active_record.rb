require 'active_support/core_ext/module/delegation'
require 'repositor/repo/instance_allow'

module Repositor::Repo
  class ActiveRecordAdapter < Repositor::Base
    extend InstanceMethodsFilter

    TYPE = 'Repo'.freeze

    delegate :find, :new, :create, :update, :destroy, to: :model

    # Common find process with supporting of friendly_id params
    def find_or_initialize(id, friendly: false)
      friendly ? friendly_find(id) : model.find(id)
    rescue ::ActiveRecord::RecordNotFound
      model.new
    end

    # Support for `friendly_id` gem out of box
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
      # Break if first argument was not a model record
      return unless args[0].instance_of? model

      # Super if allowed_methods not defined or in not included in array
      am = self.class.allowed_methods
      super if am.nil? || !am.include?(method)

      resend_method(method, args)
    end

    def resend_method(method, args)
      # All except first argumet is a record params
      params = args.drop(1)

      if params.any?
        args[0].public_send(method, params)
      else
        args[0].public_send(method)
      end
    end
  end
end
