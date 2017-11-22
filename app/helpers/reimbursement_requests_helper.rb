#:nocov:
module ReimbursementRequestsHelper

  # https://github.com/nathanvda/cocoon/blob/master/lib/cocoon/view_helpers.rb#L45
  def render_association(association, f, new_object, form_name, render_options={}, custom_partial=nil)
    partial = get_partial_path(custom_partial, association)
    locals =  render_options.delete(:locals) || {}
    ancestors = f.class.ancestors.map{|c| c.to_s}
    method_name = ancestors.include?('SimpleForm::FormBuilder') ? :simple_fields_for : (ancestors.include?('Formtastic::FormBuilder') ? :semantic_fields_for : :fields_for)
    f.send(method_name, association, new_object, {:child_index => "new_#{association}"}.merge(render_options)) do |builder|
      partial_options = {form_name.to_sym => builder, :dynamic => true}.merge(locals)
      render(partial, partial_options)
    end
  end

  def create_object(f, association, force_non_association_create=false)
    assoc = f.object.class.reflect_on_association(association)

    assoc ? create_object_on_association(f, association, assoc, force_non_association_create) : create_object_on_non_association(f, association)
  end

  def get_partial_path(partial, association)
    partial ? partial : association.to_s.singularize + "_fields"
  end

  def create_object_on_non_association(f, association)
    builder_method = %W{build_#{association} build_#{association.to_s.singularize}}.select { |m| f.object.respond_to?(m) }.first
    return f.object.send(builder_method) if builder_method
    raise "Association #{association} doesn't exist on #{f.object.class}"
  end

  def create_object_on_association(f, association, instance, force_non_association_create)
    if instance.class.name == "Mongoid::Relations::Metadata" || force_non_association_create
      create_object_with_conditions(instance)
    else
      assoc_obj = nil

      # assume ActiveRecord or compatible
      if instance.collection?
        assoc_obj = f.object.send(association).build
        f.object.send(association).delete(assoc_obj)
      else
        assoc_obj = f.object.send("build_#{association}")
        f.object.send(association).delete
      end

      assoc_obj = assoc_obj.dup if assoc_obj.frozen?

      assoc_obj
    end
  end

  def create_object_with_conditions(instance)
    # in rails 4, an association is defined with a proc
    # and I did not find how to extract the conditions from a scope
    # except building from the scope, but then why not just build from the
    # association???
    conditions = instance.respond_to?(:conditions) ? instance.conditions.flatten : []
    instance.klass.new(*conditions)
  end
end
#:nocov:
