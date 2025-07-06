function [feature_grad_two,allFeatureName,alabel,slabel] = MHAD_stm_feature_make(xyz, joints, frames, coefficient_all)
    addpath('source/')
   
    folder = './Dataset/MHAD/';
    files = dir(fullfile(folder,'*.txt'));
    dataLength = length(files);
    
    data = zeros(xyz,joints,frames,dataLength); 
    x1 = zeros(joints * frames,xyz,dataLength); 
    x2 = zeros(frames * xyz,joints,dataLength); 
    x3 = zeros(xyz * joints,frames,dataLength); 
    
    x1_pos = zeros(joints * frames,xyz,dataLength); 
    x2_pos = zeros(frames * xyz,joints,dataLength); 
    x3_pos = zeros(xyz * joints,frames,dataLength); 
    
    x1_neg = zeros(joints * frames,xyz,dataLength); 
    x2_neg = zeros(frames * xyz,joints,dataLength); 
    x3_neg = zeros(xyz * joints,frames,dataLength); 
    
    x1_grad = zeros(joints * frames,xyz,dataLength); 
    x2_grad = zeros(frames * xyz,joints,dataLength); 
    x3_grad = zeros(xyz * joints,frames,dataLength); 
    
    x1_grad_pos = zeros(joints * frames,xyz,dataLength); 
    x2_grad_pos = zeros(frames * xyz,joints,dataLength); 
    x3_grad_pos = zeros(xyz * joints,frames,dataLength);
    
    x1_grad_neg = zeros(joints * frames,xyz,dataLength);
    x2_grad_neg = zeros(frames * xyz,joints,dataLength);
    x3_grad_neg = zeros(xyz * joints,frames,dataLength);
    
    alabel = [];
    slabel = [];
    sample_num = 0;
    ReSampleCurvelength = frames;
    for i = 1:length(files) % subject
        sample_num = sample_num + 1;
        filename = files(i).name;
        matches = regexp(filename, 'a(\d+)_s(\d+)', 'tokens');
        if isempty(matches)
            error('The file name format is incorrect, unable to extract information');
        end
        a = str2double(matches{1}{1});
        s = str2double(matches{1}{2});
        alabel = [alabel a];
        slabel = [slabel s];

        %disp(filename)
        filepath = fullfile(folder,filename);
        raw_data = dlmread(filepath);
    
        raw_data = raw_data(2:end,1:3);
        temp_data = reshape(raw_data,[xyz, joints, size(raw_data,1)/joints]);
        temp_data = reshape(temp_data,[xyz*joints, size(raw_data,1)/joints]);
        resampled_data = MSR_ReSampleCurve(temp_data,ReSampleCurvelength);
        [~,resampled_data_grad]=gradient(resampled_data);
        [~,resampled_data_grad_two]=gradient(resampled_data_grad);
        x3(:,:,sample_num) = resampled_data;
        x3_grad(:,:,sample_num) = resampled_data_grad;
        
        % new feature
        coefficient=coefficient_all(3);
        alpha=geopdf(1:ReSampleCurvelength,coefficient);
        alpha=alpha/sum(alpha)*ReSampleCurvelength;
        beta=flip(alpha);
        x3_pos(:,:,sample_num)=resampled_data*diag(alpha);
        x3_grad_pos(:,:,sample_num)=resampled_data_grad*diag(alpha);
        x3_neg(:,:,sample_num)=resampled_data*diag(beta);
        x3_grad_neg(:,:,sample_num)=resampled_data_grad*diag(beta);
        
        act=zeros(xyz,joints,ReSampleCurvelength);
        act_grad=zeros(xyz,joints,ReSampleCurvelength);
        act_grad_two=zeros(xyz,joints,ReSampleCurvelength);
        for k=1:ReSampleCurvelength % frame
            act(:,:,k) = reshape(resampled_data(1:xyz*joints,k),[xyz,joints]);
            act_grad(:,:,k) = reshape(resampled_data_grad(1:xyz*joints,k),[xyz,joints]);
            act_grad_two(:,:,k) = reshape(resampled_data_grad_two(1:xyz*joints,k),[xyz,joints]);
        end
        x1(:,:,sample_num) = reshape(permute(act,[2,3,1]),[joints * frames,xyz]);
        x1_grad(:,:,sample_num) = reshape(permute(act_grad,[2,3,1]),[joints * frames,xyz]);
        
        coefficient=coefficient_all(1);
        alpha=geopdf(1:xyz,coefficient);
        alpha=alpha/sum(alpha)*xyz;
        beta=flip(alpha);
        x1_pos(:,:,sample_num)=x1(:,:,sample_num)*diag(alpha);
        x1_grad_pos(:,:,sample_num)=x1_grad(:,:,sample_num)*diag(alpha);
        x1_neg(:,:,sample_num)=x1(:,:,sample_num)*diag(beta);
        x1_grad_neg(:,:,sample_num)=x1_grad(:,:,sample_num)*diag(beta);
        
        x2(:,:,sample_num) = reshape(permute(act,[3,1,2]),[frames * xyz,joints]);
        x2_grad(:,:,sample_num) = reshape(permute(act_grad,[3,1,2]),[frames * xyz,joints]);
        
        coefficient=coefficient_all(2);
        alpha=geopdf(1:joints,coefficient);
        alpha=alpha/sum(alpha)*joints;
        beta=flip(alpha);
        x2_pos(:,:,sample_num)=x2(:,:,sample_num)*diag(alpha);
        x2_grad_pos(:,:,sample_num)=x2_grad(:,:,sample_num)*diag(alpha);
        x2_neg(:,:,sample_num)=x2(:,:,sample_num)*diag(beta);
        x2_grad_neg(:,:,sample_num)=x2_grad(:,:,sample_num)*diag(beta);
    end


    allFeatureName ={'x1','x2','x3','x1_pos','x2_pos','x3_pos','x1_neg','x2_neg','x3_neg',...
        'x1_grad','x2_grad','x3_grad','x1_grad_pos','x2_grad_pos','x3_grad_pos','x1_grad_neg','x2_grad_neg','x3_grad_neg'};
    for name=1:length(allFeatureName)
        feature_grad_two{1,name} = eval(allFeatureName{1,name});
    end
end



