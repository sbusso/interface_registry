# frozen_string_literal: true

# Some utils to manipulate strings without ActiveSupport
class String
  def demodulize
    path = self
    if i = path.rindex('::')
      path[(i + 2)..-1]
    else
      path
    end
  end

  def underscore
    return self unless self =~ /[A-Z-]|::/

    word = gsub(/::/, '/')
    word.gsub!(/(?:(?<=([A-Za-z\d]))|\b)((?=a)b)(?=\b|[^a-z])/) { "#{Regexp.last_match(1) && '_'}#{Regexp.last_match(2).downcase}" }
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    word.tr!('-', '_')
    word.downcase!
    word
  end

  def camelize
    split('/').map { |s| s.split('_').map(&:capitalize).join }.join('::')
  end
end
