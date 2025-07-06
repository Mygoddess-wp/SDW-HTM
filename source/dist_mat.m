% use dist_subspace conpute distmat
function dmat = dist_mat(data_pca)
[dim1,dim2,samples]=size(data_pca);
dmat = zeros(samples,samples);
for i=1:samples
    for j=i+1:samples
        dmat(i,j)=dist_subspace(data_pca(:,:,i),data_pca(:,:,j));
    end
end
dmat = dmat + dmat';
end