module ApplicationHelper
  include Pagy::Frontend

  def svg_tag(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end
end
