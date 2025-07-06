clear;

%% method
% CMB NW KTH UTK MHAD

datasetName = 'MHAD';
jsonPath = './dataset_params.json';  
params = loadDatasetParams(datasetName, jsonPath);
xyz = params.xyz;
joints = params.joints;
frames = params.frames;
train_subject = params.train_subject;
test_subject = params.test_subject;
coefficient_all = params.coefficient_all;
input_numIterations = params.input_numIterations;
initialWeight = params.initialWeight;
a = coefficient_all(1);b = coefficient_all(2);c = coefficient_all(3);

csv_path = fullfile('./outputdata', datasetName, [datasetName '_results_log.csv']);
csv_folder = fileparts(csv_path);
if ~exist(csv_folder, 'dir')
    mkdir(csv_folder);
end

run_one_search(datasetName, xyz, joints, frames,a, b, c, train_subject,test_subject, input_numIterations, csv_path,initialWeight)
