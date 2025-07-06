function [feature_grad_two_pca] = auto_feature2pca(feature_grad_two,pca_dim_input)
    for i = 1:length(feature_grad_two)
%         disp(['Processing Subspace ' num2str(i)])
        [dim1,dim2,featureLength] = size(feature_grad_two{1,i});
        if isempty(pca_dim_input)
            pca_dim = min(dim1,dim2);
        else
            pca_dim = pca_dim_input(i);
        end
        feature_grad_two_pca{1,i} = zeros(dim1,dim2,featureLength);
        for j = 1:featureLength % subject
            feature_grad_two_pca{1,i}(:,:,j) = MyPCA(feature_grad_two{1,i}(:,:,j),pca_dim);
        end
        feature_grad_two{1,i}=[]; % Release memory
    end
    return
end

