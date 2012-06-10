class String

  def camelize
    self.downcase!
    self.gsub!(/(?:_| )?(.)([^_ ]*)/) { "#{$1.upcase}#{$2}" }
  end

end

