module ApplicationHelper
  def error_message_for(record, attribute_name, options = {})
    if record.errors.include?(attribute_name)
      error_name = "#{record.class.model_name.singular}.#{attribute_name}"
      content_tag :span, options.merge(data: { error: error_name }) do
        record.errors[attribute_name].to_sentence
      end
    end
  end
end
