require 'active_support/core_ext/module/delegation'

module Repositor::Query
  class ActiveRecordAdapter < Repositor::Base
    TYPE = 'Query'.freeze

    delegate :all, :first, :last, to: :model
  end
end
