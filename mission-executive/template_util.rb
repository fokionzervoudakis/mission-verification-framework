require_relative 'class_loader'

module ActionUtil
  def self.respondent(*method_names)
    method_names.each do |name|
      define_method("is_#{name}_action?") { self.class.superclass.name == "#{name.capitalize}Action" }
    end
  end

  respondent :kinetic, :sensor
end

module TypeUtil
  attr_reader :type

  def type=(type)
    @type = type.to_sym
  end
end

class Action; include ActionUtil end

class Asset
  include TypeUtil

  def self.reader(*method_names)
    method_names.each do |name|
      temp = "#{name}_actions"

      define_method(temp) do
        unless instance_variable_defined?("@#{temp}")
          instance_variable_set("@#{temp}", Array.new(@actions).delete_if do |action|
                                              !action.send("is_#{name}_action?")
                                            end)
        end

        instance_variable_get("@#{temp}")
      end
    end
  end

  attr_reader :id

  reader :kinetic, :sensor
end

class KineticAction < Action
  include TypeUtil
  attr_reader :id
end
