# recursive once
def once n
  return %r/#{
    if n == 0
      true
    else
      once(n-1)             # here
    end
  }/ox
end
x = once(128); x = once(7); x = once(16);
x =~ "true" && $~
