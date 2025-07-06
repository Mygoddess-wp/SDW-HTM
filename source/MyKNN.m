function [acc,pred] = MyKNN(dist_mat,Xnew,train_label,test_label,k)
pred=[];
for distList_index=1:length(Xnew)
    distList = dist_mat(:,distList_index);
    
    [sortedValues, sortedIndices] =sort(distList,1); %
    topFourIndices =sortedIndices(1:k); 
    topFourAction = zeros(1, k); 
    for idx = 1:k
        topFourAction(idx) = train_label(topFourIndices(idx));
    end
    actionFrequency = zeros(1, k);
    for idx = 1:k
        actionFrequency(idx) = sum(topFourAction == topFourAction(idx));
    end
    maxFrequency = max(actionFrequency);
    maxFrequencyActions = unique(topFourAction(actionFrequency == maxFrequency),'stable');
    if length(maxFrequencyActions) == 1
        selectedAction = maxFrequencyActions;
    else
        totaldis = zeros(1,length(maxFrequencyActions));
        for i=1:length(maxFrequencyActions)
            action = maxFrequencyActions(i);
            totaldis(i) = sum(sortedValues(topFourAction == action));
        end
        [~,minDistanceIndex] = min(totaldis);
        selectedAction = maxFrequencyActions(minDistanceIndex);
    end
    pred=[pred selectedAction];
end
acc=sum(pred==test_label)/length(Xnew);
%cm = confusionchart(test_label,pred);
%cm.Title = 'Confusion Matrix';

end