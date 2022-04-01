P = [
   -0.0043    0.0013    0.0014   -0.3812
    0.0001    0.0042   -0.0017   -0.9244
    0.0000    0.0000    0.0000   -0.0063]


pplus = P'*inv(P*P')
uv = ginput(2)
uv = [uv ones(2,1)]
a = pplus*uv(1,1:end)'
a = a/a(end)
a = a(1:end-1)
b = pplus*uv(2,1:end)'
b = b/b(end)
b = b(1:end-1)

sqrt(sum(power(a-b,2)))
