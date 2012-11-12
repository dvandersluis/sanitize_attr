class String
  def clean_html
    Sanitize.clean(self, Sanitize::Config::HTML)
  end
  
  def clean_html!
    replace(clean_html)
  end
end