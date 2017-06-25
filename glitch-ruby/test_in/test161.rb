def x
 return yield self # here
end
x do
 true
end