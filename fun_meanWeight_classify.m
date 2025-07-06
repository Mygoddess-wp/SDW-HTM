function [mean_ACC] = fun_meanWeight_classify(datasetName,xyz, joints, frames, coefficient_all,train_subject,test_subject)

addpath('stm_feature_make/')
addpath('source/')
overWrite = false;

coeffName = sprintf('x1_%.2f_x2_%.2f_x3_%.2f', coefficient_all);
coeffName = strrep(coeffName, '.', 'p'); 

saveLoad = fullfile('./outputdata', datasetName, coeffName);
if saveLoad(end) ~= filesep
    saveLoad = [saveLoad filesep];
end

if ~exist(saveLoad, 'dir')
    mkdir(saveLoad);
end
feature_fileName = [saveLoad 'data/' datasetName '_stm_features.mat'];
if (exist(feature_fileName,'file') == 0) || overWrite
    disp([datasetName '  =====begin: get feature_grad_two=============='])
    switch datasetName
        case 'CMB'
            [feature_grad_two,allFeatureName,alabel,slabel] = CMB_stm_feature_make(xyz, joints, frames, coefficient_all);
        case 'NW'
            [feature_grad_two,allFeatureName,alabel,slabel] = NW_stm_feature_make(xyz, joints, frames, coefficient_all);
        case 'KTH'
            [feature_grad_two,allFeatureName,alabel,slabel] = KTH_stm_feature_make(xyz, joints, frames, coefficient_all);
        case 'UTK'
            [feature_grad_two,allFeatureName,alabel,slabel] = UTK_stm_feature_make(xyz, joints, frames, coefficient_all);
        case 'MHAD' 
            [feature_grad_two,allFeatureName,alabel,slabel] = MHAD_stm_feature_make(xyz, joints, frames, coefficient_all);
        otherwise
            error('dataset is null');
    end
    if ~exist([saveLoad 'data/'], 'dir')
        mkdir([saveLoad 'data/']);
    end
    save(feature_fileName,'feature_grad_two','alabel','slabel','datasetName','allFeatureName','-v7.3');
    disp([datasetName '  =====achive: get and save feature_grad_two=============='])
else
    load(feature_fileName);
    disp([datasetName '  =====achive: get feature_grad_two=============='])
end
%% achive pca
rankName = '_1Rank';
feature_pca_fileName = [saveLoad 'data/' datasetName '_stm_features_pca' rankName '.mat'];
if (exist(feature_pca_fileName,'file') == 0) || overWrite
    disp([datasetName '  =====begin pca: get feature_grad_two_pca=============='])
    isnorm = 0;
    pca_dim =[];
    [feature_grad_two_pca] = auto_feature2pca(feature_grad_two,pca_dim);
    
    if ~exist([saveLoad 'data/'], 'dir')
        mkdir([saveLoad 'data/']);
    end
    save(feature_pca_fileName,'feature_grad_two_pca','alabel','slabel','pca_dim','datasetName','allFeatureName','-v7.3')
    disp([datasetName '  =====achive pca: get and save feature_grad_two_pca=============='])
else
    feature_grad_two = [];
    load(feature_pca_fileName);
    disp([datasetName '  =====achive pca: get feature_grad_two_pca=============='])
end

%% get Xtrain and Xnew
[Xtrain,Xnew] = get_Xtrain_Xnew(train_subject,test_subject,slabel,datasetName);
disp([datasetName '  =====achive: get Xtrain and Xnew=============='])

%% begin train
train_dmat_fileName = [saveLoad 'model/' datasetName '_stm' rankName '_dist.mat'];
if (exist(train_dmat_fileName,'file') == 0) || overWrite
    disp([datasetName '  =====begin: training=============='])
    isnorm = 0;
    [all_dmat] =  train(feature_grad_two_pca);
    %save dmat data
    if ~exist([saveLoad 'model/'], 'dir')
        mkdir([saveLoad 'model/']);
    end
    save(train_dmat_fileName,'all_dmat','alabel','slabel','pca_dim','Xtrain','Xnew','datasetName','allFeatureName');
    disp([datasetName '  =====achive: training=============='])
else
    load(train_dmat_fileName);
    disp([datasetName '  =====achive: get  train_dmat=============='])
end

%% begin classify
disp([datasetName '  =====begin: classify =============='])
all_sumWay = {'sum','norm2'};
k = 3;%k of knn
mean_ACC = classify(18,ones(1,18),all_sumWay(1),datasetName,all_dmat,Xtrain,Xnew,alabel,k);

end

