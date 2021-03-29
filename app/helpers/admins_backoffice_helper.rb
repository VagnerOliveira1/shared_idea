module AdminsBackofficeHelper
  def translate_attribute(object, method)
    object.model.human_attribute_name(method) if object.present? && method.present?
  end
end
