module Custom
  module Concern
    def self.included(base)
      base.extend ClassMethods # add all the methods in ClassMethods directly to MyClass
    end

    module ClassMethods
      def in_class(&block) # saves the block (of method defs) to be run in MyClass's scope
        @included_block = block
      end

      def class_methods(&block)
        @class_methods_block = block
      end

      def included(base) # triggers when included into MyClass
        base.class_eval &@included_block # adds method defs to MyClass instance scope

        const_set :ClassMethods, Module.new # const_set/get are workarounds since you can't set constants/create classes from an instance
        const_get(:ClassMethods).module_eval &@class_methods_block
        base.extend const_get :ClassMethods # adds method defs to MyClass class scope
      end
    end
  end
end



module MyModule
  include Custom::Concern

  def instance_method # module's instance methods are already included
    "instance method"
  end

  in_class do # define instance methods in MyClass
    attr_accessor :foo
  end

  class_methods do # define class methods in MyClass
    def class_method
      "class method"
    end
  end


end



class MyClass
  include MyModule
end



puts MyClass.new.instance_method
puts MyClass.instance_methods(false).inspect
puts MyClass.class_method

module Foo
  def self.const_missing(name)
    const_set(name, Class.new)
  end
  class Bar
    "Hello, Barz!"
  end
end



def Object.hello
  "Hello, world!"
end

> Class.hello
=> "Hello, world!"