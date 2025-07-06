function [all_dmat] = train(feature_grad_two_pca)
    
    for i=1:length(feature_grad_two_pca)
        all_dmat{1,i} = dist_mat(feature_grad_two_pca{1,i});
    end

   
end

