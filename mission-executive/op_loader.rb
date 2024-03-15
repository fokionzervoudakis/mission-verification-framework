require 'yaml'

require_relative 'core'
require_relative 'action'
require_relative 'asset'
require_relative 'lidar_action'

class OpLoader
  def self.loader(*method_names)
    method_names.each do |name|
      define_method("load_#{name}") do
        instance_variable_get("@#{name}").each_pair do |observer_id, subject_ids|
          subject_ids.each do |subject_id|
            case name
            when :concurrencies then id1 = subject_id
                                     id2 = observer_id
            when :preconditions then id1 = observer_id
                                     id2 = subject_id
            end
            @actions.fetch(id1).send("add_#{name.singularize}", @actions.fetch(id2))
          end
        end
      end
    end
  end

  defensive_copy :assets
  loader :concurrencies, :preconditions

  def initialize(operation)
    @op_file = load_file operation
    collections = %i[actions concurrencies preconditions assets]
    collections.each { |collection| instance_variable_set("@#{collection}", {}) }
    collections.each { |collection| send("load_#{collection}") } # rubocop:disable Style/CombinableLoops
  end

  private

  def load_file(file, dir = :operations)
    YAML.safe_load(File.open("#{dir}/#{file}.yaml")).symbolize_keys!
  end

  def load_actions
    @op_file.fetch(:Action).each_pair do |type, actions|
      actions.symbolize_keys!.each do |action|
        id = action.fetch(:id)
        @actions[id] = type.to_c.new(id, type == :LidarAction ? action.fetch(:interval) : action.fetch(:duration))
        @concurrencies[id] = action.fetch(:concurrencies) if action.include?(:concurrencies)
        @preconditions[id] = action.fetch(:preconditions) if action.include?(:preconditions)
      end
    end
  end

  def load_assets
    load_file(:asset_data).each_pair { |type, asset| type.to_c.endurance = asset.fetch(:endurance) }
    @op_file.fetch(:Asset).each_pair do |type, assets|
      assets.symbolize_keys!.each do |asset|
        id = asset.fetch(:id)
        @assets[id] = type.to_c.new(id)
        asset.fetch(:actions).each { |action| @assets[id].add_action(@actions.fetch(action)) }
      end
    end
  end
end
