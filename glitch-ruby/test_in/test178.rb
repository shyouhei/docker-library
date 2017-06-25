def once expr
 return /#{expr}/o # here
end
x = once(true); x = once(false); x = once(nil);
x =~ "true"