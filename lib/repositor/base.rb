require 'active_support/inflector'

module Repositor
  class Base
    attr_reader :model

    def initialize(model: nil)
      @model = model || self.class.to_s.chomp(self.class::TYPE).singularize.constantize
    end
  end
end
