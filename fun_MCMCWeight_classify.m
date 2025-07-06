function [finalACC, final_weight] = fun_MCMCWeight_classify(datasetName,input_numIterations,coefficient_all,train_subject,test_subject,initialWeight)

addpath('source/')
overWrite = true;
coeffName = sprintf('x1_%.2f_x2_%.2f_x3_%.2f', coefficient_all);
coeffName = strrep(coeffName, '.', 'p'); 

saveLoad = fullfile('./outputdata', datasetName, coeffName);
saveLoad = [saveLoad '/'];

rankName = '_1Rank';
kind = 'Best';
expDataFileName = 'MCMCWeightData/';
all_sumWay = {'sum','norm2'};
sumWay = all_sumWay(1);
k = 3;
featureName_list = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18];
feature_pca_fileName = [saveLoad 'data/' datasetName '_stm_features_pca' rankName '.mat'];
train_dmat_fileName = [saveLoad 'model/' datasetName '_stm' rankName '_dist.mat'];

save_result_data = [saveLoad 'result/' expDataFileName];
if ~exist([saveLoad 'result/'], 'dir')
    mkdir([saveLoad 'result/']);
end
if ~exist(save_result_data, 'dir')
    mkdir(save_result_data);
end
if (exist(train_dmat_fileName,'file') == 0) 
    error('Please run code meanWeight_classify.m first to generate dist.mat, and then run the file again');
else
    load(feature_pca_fileName)
    load(train_dmat_fileName);
    featureLength=length(all_dmat);
    disp([datasetName '  =====achive: get  train_dmat=============='])
end

%% get Xtrain and Xnew
[Xtrain,Xnew] = get_Xtrain_Xnew(train_subject,test_subject,slabel,datasetName);
disp([datasetName '  =====achive: get Xtrain and Xnew=============='])

%% MCMC net research way to find Best Result
currentWeights = initialWeight;
numIterations = input_numIterations;
trace = zeros(numIterations*(featureLength), featureLength + 1);
[currentAcc,pred_label,dmat] = classify(featureLength,currentWeights,sumWay,datasetName,all_dmat,Xtrain,Xnew,alabel,k);
traceIndex = 0;
for iteration = 1:numIterations
    for i = 1:featureLength
   proposedWeights = currentWeights;
        if proposedWeights(i)==0
            continue
        end
        proposedWeights(i) = rand();
        [proposedAcc,pred_label,dmat] = classify(featureLength,proposedWeights,sumWay,datasetName,all_dmat,Xtrain,Xnew,alabel,k);
        if proposedAcc >= currentAcc
            currentWeights = proposedWeights;
            currentAcc = proposedAcc;
        end
        traceIndex = traceIndex + 1;
        trace(numIterations*(i) + iteration, 1:featureLength) = proposedWeights;
        trace(numIterations*(i) + iteration, featureLength + 1) = proposedAcc;
    end
    if mod(iteration, 100) == 0
        disp(num2str(iteration));
    end
end

%% print best result and save result Data
disp('datasetName:');
disp(datasetName);
disp('Final weights=');
disp(currentWeights);
finalACC = classify(featureLength,currentWeights,sumWay,datasetName,all_dmat,Xtrain,Xnew,alabel,k);
disp(['Final accuracy: ', num2str(finalACC)]);

result(1).datasetName = datasetName;
result(1).initialWeight = initialWeight;
result(1).allWeights = currentWeights;
result(1).featureName = allFeatureName(featureName_list);
result(1).acc = finalACC;
saveloadFilename = [save_result_data 'oneFeatureChange' datasetName '_' num2str(featureLength) '_feature' rankName '_eightMCMC' '_Random' kind ];
save([saveloadFilename  num2str(finalACC) '.mat'],'finalACC','result');
final_weight = currentWeights;

end

