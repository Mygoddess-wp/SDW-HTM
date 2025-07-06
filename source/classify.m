function [testAcc,pred,dmat] = classify(featureNumber,weights,sumWay,datasetName,all_dmat,Xtrain,Xnew,alabel,k)

    dmat = zeros(size(all_dmat{1,1}));
    if strcmp(sumWay,'sum')
        for i=1:featureNumber
            dmat = dmat + all_dmat{1,i} * weights(i);
        end
    elseif strcmp(sumWay,'norm2')
        for i=1:featureNumber
            dmat = dmat + (all_dmat{1,i}.^2)* weights(i);
        end
        dmat = sqrt(dmat);
    end
    
    if strcmp(datasetName,'UTK')
        %  loocv ;
        dmat_one = dmat + diag(ones(1,size(dmat,1))*inf);
        [~,index_one] = min(dmat_one);
        pred_one = alabel(index_one);
        testAcc=sum(pred_one==alabel)/length(pred_one);
        pred = pred_one;
    else
        new_dmat=dmat(Xtrain,Xnew);
        train_alabel=alabel(Xtrain);
        test_alabel=alabel(Xnew);
        [testAcc,pred]=MyKNN(new_dmat,Xnew,train_alabel,test_alabel,k);
    end
end

