module Repositor
  module InstanceMethodsFilter
    attr_reader :allowed_methods

    # Define which methods only will be allowed to resend to model instance
    def allow_instance_methods(*methods)
      @allowed_methods = methods
    end
  end
end
