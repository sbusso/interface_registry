
class String
  def demodulize
    path = self
    if i = path.rindex('::')
      path[(i+2)..-1]
    else
      path
    end
  end

  def underscore
    return self unless self =~ /[A-Z-]|::/
    word = self.gsub(/::/, '/')
    word.gsub!(/(?:(?<=([A-Za-z\d]))|\b)((?=a)b)(?=\b|[^a-z])/) { "#{$1 && '_'}#{$2.downcase}" }
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

end
