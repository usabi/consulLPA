require_dependency Rails.root.join("lib", "wysiwyg_sanitizer").to_s

class WYSIWYGSanitizer
  def allowed_tags
    %w[p ul ol li strong em u s a h2 h3 iframe script div map area img]
  end

  def allowed_attributes
    %w[href src url class data-url style name shape id coords target title usemap]
  end

end
