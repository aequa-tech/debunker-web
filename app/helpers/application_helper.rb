module ApplicationHelper
  include Pagy::Frontend

  def react_component(component_name, data={})
    json_data = data.to_json
    class_name = "react-#{component_name}"
    content_tag(:div, nil,class: class_name, data: json_data).html_safe
  end

  def svg_tag(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end
end
