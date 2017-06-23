x = y = true
case x
when false
  y = false
when true                   # here
  y = nil
end
y == nil
