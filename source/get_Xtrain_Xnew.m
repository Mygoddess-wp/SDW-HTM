function [Xtrain,Xnew] = get_Xtrain_Xnew(train_subject,test_subject,slabel,datasetName)
    Xtrain = [];
    Xnew = [];
    if strcmp(datasetName,'HMDB51')
        Xtrain = find(ismember(slabel, train_subject));
        Xnew = find(ismember(slabel, test_subject));
    else
        for i=1:length(train_subject)
            Xtrain=[Xtrain find(slabel==train_subject(i))];
        end
       
        for i=1:length(test_subject)
            Xnew=[Xnew find(slabel==test_subject(i))];
        end
        if strcmp(datasetName,'NW')
            Xtrain = Xtrain(1:550);
            Xnew = Xnew(1:250);

        end
    end
    
end

