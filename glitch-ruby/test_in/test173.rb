class X < String
 def empty?
 super # here
 end
 end
X.new.empty?