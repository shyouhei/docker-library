# ultra complicated situation: this ||= assignment only generates
# 15 instructions, not including the class definition.
class X; attr_accessor :x; end
x = X.new
x&.x ||= true # here