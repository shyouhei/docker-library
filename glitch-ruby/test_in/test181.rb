# inter-thread lockup situation
def once n
 return Thread.start n do |m|
 Thread.pass
 next %r/#{
 sleep m # here
 true
}/ox
 end
end
x = once(1); y = once(0.1); z = y.value
z =~ "true"