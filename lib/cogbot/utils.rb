# this is a monkey patching over the String class 
# to bring the camelcase method from rails
class String

  # the famous camelize method so useful in metaprogramming
  def camelize
    self.downcase!
    self.gsub!(/(?:_| )?(.)([^_ ]*)/) { "#{$1.upcase}#{$2}" }
  end

end

