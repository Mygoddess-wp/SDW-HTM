function Xn = ReSampleCurve(X,N)
[n,T] = size(X);
%Delete Duplicate Points
delete_index = [];
for i=2:n
    if X(i,1)==X(i-1,1)
        delete_index = [delete_index i];
    end
end
X(delete_index,:)=[];

%Resample

frame_index=X(:,1);
cumdel = (frame_index-min(frame_index))/(max(frame_index)-min(frame_index));
    
newdel = [0:N-1]/(N-1);
for i=2:T
    Xn(:,i-1) = interp1(cumdel,X(:,i),newdel,'linear');
end
end