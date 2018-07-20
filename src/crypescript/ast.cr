module Crypescript
  module AST
    class InitialVar < Crystal::Var
    end

    class IntitialInstanceVar < Crystal::InstanceVar
    end

    class DefInClass < Crystal::Def
    end

    class New < Crystal::Call
    end

    class AssignArray < Crystal::Call
    end

    class Each < Crystal::Call
    end

    def transpile(klass : Class)
      translate_type(klass.to_s)
    end
  end
end
