module Crypescript
  module AST
    class InitialVar < Crystal::Var
    end

    class IntitialInstanceVar < Crystal::InstanceVar
    end

    class DefInClass < Crystal::Def
    end

    def transpile(klass : Class)
      translate_type(klass.to_s)
    end
  end
end
