module Api::V1::BaseDoc
  include Apipie::DSL::Concern

  def namespace(namespace, options = {})
    @namespace = namespace
    @namespace_name = options[:name]
  end

  attr_reader :namespace_name

  def resource(resource, options = {})
    controller_name = resource.to_s.camelize + 'Controller'

    (class << self; self; end).send(:define_method, :superclass) do
      mod = @namespace.present? ? @namespace.classify.constantize : Object
      mod.const_get(controller_name)
    end

    Apipie.app.set_resource_id(self, controller_name)

    resource_description do
      api_version @controller.namespace_name if @controller.namespace_name
      short options[:short] if options[:short]
      formats options[:formats] if options[:formats]
    end
  end

  def doc_for(action_name, &block)
    instance_eval(&block)
    api_version namespace_name if namespace_name
    define_method(action_name) do
      # ... define it in your controller with the real code, blank here
    end
  end

  def auth_headers
    header 'Access-Token', 'Current user\'s access token', required: true
    header 'Client', 'Current user\'s client\'s token', required: true
    header 'Uid', 'Current user\'s uid', required: true
  end
end