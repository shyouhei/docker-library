# opt_aref / opt_aset mixup situation
class X; def x; {}; end; end
x = X.new
x&.x[true] ||= true         # here
