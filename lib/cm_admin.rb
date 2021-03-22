require 'cm_admin/version'
require 'cm_admin/engine'
require 'cm_admin/model'

module CmAdmin
  class Error < StandardError; end

  mattr_accessor :layout
  mattr_accessor :included_models
  @@included_models ||= []

  def self.setup
    yield self
  end

  def self.config(entity, &block)
    if entity.is_a?(Class)
      @@included_models << CmAdmin::Model.new(entity, &block)
    end
  end
end
