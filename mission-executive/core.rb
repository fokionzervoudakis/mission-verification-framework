require 'active_support/inflector'

class Array
  def symbolize_keys!
    each { |item| item.symbolize_keys! if item.instance_of?(Hash) }
    self
  end
end

class Hash
  def symbolize_keys!
    keys.each do |key|
      self[begin
        key.to_sym
      rescue StandardError
        key
      end] = delete(key)
    end
    values.each { |value| value.symbolize_keys! if value.instance_of?(Hash) }
    self
  end
end

class Module
  def defensive_copy(*method_names)
    method_names.each do |name|
      define_method(name) do
        var = instance_variable_get("@#{name}")
        Array.new(var.instance_of?(Array) ? var : var.values)
      end
    end
  end
end

class Symbol
  def include?(sym)
    to_s.include?(sym.to_s)
  end

  def singularize
    to_s.singularize.intern
  end

  def to_c
    Kernel.const_get(self)
  end
end
