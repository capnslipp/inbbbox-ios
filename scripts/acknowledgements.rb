require 'redcarpet/compat'

class Acknowledgements
  def generate_html_acknowlegements(path)
    acknowlegements_md = File.open("Pods/Target Support Files/Pods-Tests/Pods-Tests-acknowledgements.markdown").read
    acknowlegements_html = Markdown.new(acknowlegements_md).to_html
    File.write(path, acknowlegements_html)
  end
end
