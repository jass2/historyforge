# frozen_string_literal: true

# Please do not make direct changes to this file!
# This generator is maintained by the community around simple_form-bootstrap:
# https://github.com/rafaelfranca/simple_form-bootstrap
# All future development, tests, and organization should happen there.
# Background history: https://github.com/plataformatec/simple_form/issues/1561

# Uncomment this and change the path if necessary to include your own
# components.
# See https://github.com/plataformatec/simple_form#custom-components
# to know more about custom components.
# Dir[Rails.root.join('lib/components/**/*.rb')].each { |f| require f }

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # Default class for buttons
  config.button_class = 'btn'

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = 'form-check-label'

  # How the label text should be generated altogether with the required text.
  config.label_text = lambda { |label, required, explicit_label| "#{label} #{required}" }

  # Define the way to render check boxes / radio buttons with labels.
  config.boolean_style = :inline

  # You can wrap each item in a collection of radio/check boxes with a tag
  config.item_wrapper_tag = :div

  # Defines if the default input wrapper class should be included in radio
  # collection wrappers.
  config.include_default_input_wrapper_class = false

  # CSS class to add for error notification helper.
  config.error_notification_class = 'alert alert-danger'

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # :to_sentence to list all errors for each field.
  config.error_method = :to_sentence

  # add validation classes to `input_field`
  config.input_field_error_class = 'is-invalid'
  config.input_field_valid_class = 'is-valid2' # to keep the green checks from appearing


  # vertical forms
  #
  # vertical default_wrapper
  config.wrappers :vertical_form, tag: 'div', class: 'form-group', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label
    b.use :input, class: 'form-control', error_class: 'is-invalid'
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    b.use :hint, wrap_with: { tag: 'div', class: 'hint-bubble' }
  end

  # vertical input for boolean
  config.wrappers :vertical_boolean, tag: 'fieldset', class: 'form-group', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label
    b.wrapper :form_check_wrapper, tag: 'div', class: 'form-check' do |bb|
      bb.use :input, class: 'form-check-input', error_class: 'is-invalid'
      bb.use :inline_label, class: 'form-check-label'
      bb.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
      bb.use :hint, wrap_with: { tag: 'div', class: 'hint-bubble' }
    end
  end

  # vertical input for radio buttons and check boxes
  config.wrappers :vertical_collection, item_wrapper_class: 'form-check', item_label_class: 'form-check-label', tag: 'div', class: 'form-group', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :legend_tag, tag: 'label', class: 'col-form-label pt-0' do |ba|
      ba.use :label_text
    end
    b.use :input, class: 'form-check-input', error_class: 'is-invalid'
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
    b.use :hint, wrap_with: { tag: 'div', class: 'hint-bubble' }
  end

  # vertical input for inline radio buttons and check boxes
  config.wrappers :vertical_collection_inline, item_wrapper_class: 'form-check form-check-inline', item_label_class: 'form-check-label', tag: 'div', class: 'form-group', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :legend_tag, tag: 'div', class: 'col-form-label pt-0' do |ba|
      ba.use :label_text
    end
    b.use :input, class: 'form-check-input', error_class: 'is-invalid'
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
    b.use :hint, wrap_with: { tag: 'div', class: 'hint-bubble' }
  end

  # vertical file input
  config.wrappers :vertical_file, tag: 'div', class: 'form-group', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label
    b.use :input, class: 'form-control-file', error_class: 'is-invalid'
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    b.use :hint, wrap_with: { tag: 'div', class: 'hint-bubble' }
  end

  # vertical multi select
  config.wrappers :vertical_multi_select, tag: 'div', class: 'form-group', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label
    b.wrapper tag: 'div', class: 'd-flex flex-row justify-content-between align-items-center' do |ba|
      ba.use :input, class: 'form-control mx-1', error_class: 'is-invalid'
    end
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
    b.use :hint, wrap_with: { tag: 'div', class: 'hint-bubble' }
  end

  # vertical range input
  config.wrappers :vertical_range, tag: 'div', class: 'form-group', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :readonly
    b.optional :step
    b.use :label
    b.use :input, class: 'form-control-range', error_class: 'is-invalid'
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
    b.use :hint, wrap_with: { tag: 'div', class: 'hint-bubble' }
  end


  # horizontal forms
  #
  # horizontal default_wrapper
  config.wrappers :horizontal_form, tag: 'div', class: 'form-group row', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-sm-6 col-form-label'
    b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-6' do |ba|
      ba.use :input, class: 'form-control', error_class: 'is-invalid'
      ba.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
      ba.use :hint, wrap_with: { tag: 'small', class: 'hint-bubble' }
    end
  end

  # horizontal input for boolean
  config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group row', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper tag: 'label', class: 'col-sm-6' do |ba|
      ba.use :label_text
    end
    b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-6' do |wr|
      wr.wrapper :form_check_wrapper, tag: 'div', class: 'form-check' do |bb|
        bb.use :input, class: 'form-check-input', error_class: 'is-invalid'
        bb.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
        bb.use :hint, wrap_with: { tag: 'div', class: 'hint-bubble' }
      end
    end
  end

  # horizontal input for radio buttons and check boxes
  config.wrappers :horizontal_collection, item_wrapper_class: 'form-check', item_label_class: 'form-check-label', tag: 'div', class: 'form-group row', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'col-sm-6 col-form-label pt-0'
    b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-6' do |ba|
      ba.use :input, class: 'form-check-input', error_class: 'is-invalid'
      ba.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
      ba.use :hint, wrap_with: { tag: 'small', class: 'hint-bubble' }
    end
  end

  # horizontal input for inline radio buttons and check boxes
  config.wrappers :horizontal_collection_inline, item_wrapper_class: 'form-check form-check-inline', item_label_class: 'form-check-label', tag: 'div', class: 'form-group row', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'col-sm-6 col-form-label pt-0'
    b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-6' do |ba|
      ba.use :input, class: 'form-check-input', error_class: 'is-invalid'
      ba.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
      ba.use :hint, wrap_with: { tag: 'small', class: 'hint-bubble' }
    end
  end

  # horizontal file input
  config.wrappers :horizontal_file, tag: 'div', class: 'form-group row', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label, class: 'col-sm-6 col-form-label'
    b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-6' do |ba|
      ba.use :input, error_class: 'is-invalid'
      ba.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
      ba.use :hint, wrap_with: { tag: 'small', class: 'hint-bubble' }
    end
  end

  # horizontal multi select
  config.wrappers :horizontal_multi_select, tag: 'div', class: 'form-group row', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'col-sm-6 col-form-label'
    b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-6' do |ba|
      ba.wrapper tag: 'div', class: 'd-flex flex-row justify-content-between align-items-center' do |bb|
        bb.use :input, class: 'form-control mx-1', error_class: 'is-invalid'
      end
      ba.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
      ba.use :hint, wrap_with: { tag: 'small', class: 'hint-bubble' }
    end
  end

  # horizontal range input
  config.wrappers :horizontal_range, tag: 'div', class: 'form-group row', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :readonly
    b.optional :step
    b.use :label, class: 'col-sm-6 col-form-label'
    b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-6' do |ba|
      ba.use :input, class: 'form-control-range', error_class: 'is-invalid'
      ba.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
      ba.use :hint, wrap_with: { tag: 'small', class: 'hint-bubble' }
    end
  end


  # inline forms
  #
  # inline default_wrapper
  config.wrappers :inline_form, tag: 'span', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'sr-only'

    b.use :input, class: 'form-control', error_class: 'is-invalid'
    b.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    b.optional :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  # inline input for boolean
  config.wrappers :inline_boolean, tag: 'span', class: 'form-check mb-2 mr-sm-2', error_class: 'form-group-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :input, class: 'form-check-input', error_class: 'is-invalid'
    b.use :label, class: 'form-check-label'
    b.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    b.optional :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :vertical_form

  # Custom wrappers for input types. This should be a hash containing an input
  # type as key and the wrapper that will be used for all inputs with specified type.
  config.wrapper_mappings = {
    boolean:       :vertical_boolean,
    check_boxes:   :vertical_collection,
    date:          :vertical_multi_select,
    datetime:      :vertical_multi_select,
    file:          :vertical_file,
    radio_buttons: :vertical_collection,
    range:         :vertical_range,
    time:          :vertical_multi_select
  }

  # enable custom form wrappers
  # config.wrapper_mappings = {
  #   boolean:       :custom_boolean,
  #   check_boxes:   :custom_collection,
  #   date:          :custom_multi_select,
  #   datetime:      :custom_multi_select,
  #   file:          :custom_file,
  #   radio_buttons: :custom_collection,
  #   range:         :custom_range,
  #   time:          :custom_multi_select
  # }
end

SimpleForm::FormBuilder.class_eval do
  def lookup_model_names #:nodoc:
    @lookup_model_names ||= begin
                              child_index = options[:child_index]
                              names = object_name.to_s.scan(/(?!\d)\w+/).flatten
                              names.delete(child_index) if child_index
                              names.each { |name| name.gsub!('_attributes', '') }
                              if @object.respond_to?(:model_name)
                                names.unshift @object.model_name.param_key
                              end
                              names.freeze
                            end
  end
end

SimpleForm::Inputs::Base.class_eval do
  def translate_from_namespace(namespace, default = '')
    model_names = lookup_model_names.dup
    lookups     = []

    while !model_names.empty?
      # joined_model_names = model_names.join(".")
      name = model_names.shift

      lookups << :"#{name}.#{reflection_or_attribute_name}"
      # lookups << :"#{joined_model_names}.#{lookup_action}.#{reflection_or_attribute_name}"
      # lookups << :"#{joined_model_names}.#{reflection_or_attribute_name}"
    end

    if object.kind_of?(CensusRecord)
      lookups << :"census_record.#{reflection_or_attribute_name}"
    end

    lookups << :"defaults.#{lookup_action}.#{reflection_or_attribute_name}"
    lookups << :"defaults.#{reflection_or_attribute_name}"
    lookups << default

    puts lookups.inspect
    I18n.t(lookups.shift, scope: :"#{i18n_scope}.#{namespace}", default: lookups).presence
  end
end
