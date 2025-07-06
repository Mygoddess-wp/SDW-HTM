function [] = run_one_search(datasetName, xyz, joints, frames,a, b, c, train_subject,test_subject, input_numIterations, csv_path,initialWeight)

if ~isfile(csv_path)
    fid = fopen(csv_path, 'w');
    fprintf(fid, 'Dataset,c1,c2,c3,meanACC,finalACC,final_weight\n');
    fclose(fid);
end

if check_record_exist(csv_path, datasetName, a, b, c)
    fprintf('  Already exists, skipping...\n');
    return;
end

try
    mean_ACC = fun_meanWeight_classify(datasetName, xyz, joints, frames, [a b c],train_subject,test_subject);
    disp('begin mcmc');
    [finalACC, final_weight] = fun_MCMCWeight_classify(datasetName, input_numIterations, [a b c],train_subject,test_subject,initialWeight);

    fid = fopen(csv_path, 'a');
    fprintf(fid, '%s,%.3f,%.3f,%.3f,%.6f,%.6f,"%s"\n', ...
        datasetName, a, b, c, mean_ACC, finalACC, mat2str(final_weight));
    fclose(fid);

    fprintf('  Done: mean_ACC=%.6f, finalACC=%.6f\n', mean_ACC, finalACC);

catch ME
    fprintf('  Error: %s\n', ME.message);
end
end



function exists = check_record_exist(csv_path, datasetName, a, b, c)
exists = false;
if ~isfile(csv_path)
    return;
end
fid = fopen(csv_path,'r');
lines = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);

pattern = sprintf('%s,%.3f,%.3f,%.3f', datasetName, a, b, c);
for i = 2:length(lines{1})
    if contains(lines{1}{i}, pattern, 'IgnoreCase', true)
        exists = true;
        break;
    end
end

end

