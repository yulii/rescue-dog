module Rescue
  

  class NoActionError < ArgumentError
    def initialize type
      super "Undefined `#{type}` type. Please specify :show, :edit, :new, :create, :update, or :destory on the :type argument."
    end
  end

  class NoParameterMethodError < NoMethodError
    def initialize clazz, name
      super "Undefined method `#{name}` for #{clazz.name}. Please define private method `#{name}` to return the permissible parameters."
    end
  end

end
