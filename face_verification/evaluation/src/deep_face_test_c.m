clear all;
clc;

run('../vlfeat-master/toolbox/vl_setup.m');


%% test data
% config
test_data_name_idx = 2;       % 1-MBGC, 2-LFW, 3-HS_Ident
path = 'Z:\User\wuxiang\Result\DeepFace\DeepFace0.1.41.x-0.2.41.x\set001\50K';

% pairs
switch test_data_name_idx
    case 1
        fprintf('Test MBGC\n');
        load('../data/MBGC_test_data.mat', 'test_data');
         list_path = '../data/MBGC_list.txt';
    case 2
        fprintf('Test LFW\n');
        load('../data/LFW_test_data.mat', 'test_data');
        list_path = '../data/LFW_list.txt';
    case 3
        fprintf('Test HS_Ident\n');
        load('../data/HS_Ident_test_data.mat', 'test_data');
        list_path = '../data/HS_Ident_list.txt';
end

pairs = test_data.pairs;      
label = test_data.anno;

% feature
fid = fopen(list_path);
n = str2double(fgetl(fid));

for i = 1: n      
    tmp_path = fgetl(fid);
    tmp = regexp(tmp_path, '.bmp', 'split');
    tmp_path = sprintf('%s\\%s.feat', path, tmp{1});
    fidin = fopen(tmp_path, 'r');
    feat(:, i) = fread(fidin, 'single');
    fclose(fidin);
end

fclose(fid);

%% evaluation
for i = 1: length(pairs)
    feat1 = feat(:, pairs(1, i));
    feat2 = feat(:, pairs(2, i));
    scores(i) = distance.compute_cosine_score(feat1, feat2);
end

% ap
ap = evaluation.evaluate('ap', scores, label);

% roc
roc = evaluation.evaluate('roc', scores, label);


%% output
fprintf('ap:                 %f\n', ap.measure);
fprintf('eer:               %f\n', roc.measure);
fprintf('tpr001:         %f\n', roc.extra.tpr001*100);
fprintf('tpr0001:       %f\n', roc.extra.tpr0001*100);
fprintf('tpr00001:     %f\n', roc.extra.tpr00001*100);
fprintf('tpr000001:   %f\n', roc.extra.tpr000001*100);
fprintf('tpr0:              %f\n', roc.extra.tpr0*100);



