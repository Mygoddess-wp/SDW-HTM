function [data_PCA, COEFF, sum_explained]=MyPCA(data,k)
% k: The first k principal components
% data=zscore(data);  %Normalized data

warning off
[COEFF,SCORE,latent,tsquared,explained,mu]=pca(data);
warning on

data = zscore(data);

data_PCA=data*COEFF(:,1:k);
mod = sqrt(sum(data_PCA.^2))';
mod(mod==0)=1;
data_PCA = data_PCA*diag(1./mod);

sum_explained=sum(explained(1:k));
end