function Xn = MSR_ReSampleCurve(X,N)
[T,n] = size(X);
cumdel = [0:n-1]/(n-1);
newdel = [0:N-1]/(N-1);
for i=1:T
    Xn(i,:) = interp1(cumdel,X(i,:),newdel,'linear');
end


end