% clear all;
% clc;

run('../vlfeat-master/toolbox/vl_setup.m');


%% test data
% config
% test_data_name_idx = 1;       % 1-MBGC, 2-LFW, 3-HS_Ident
% test_iter = 20;
% path = 'Z:\User\wuxiang\Result\DeepFace\DeepFace_verification\DeepFace0.1.4.x';

% pairs
% switch test_data_name_idx
%     case 1
%         
%     case 2
%         fprintf('Test LFW\n');
%         pair_path = 'Z:\Face_DB\TrainingSet_Info\caffe\lfw_6000pairs';
%         pos_pair_path = sprintf('%s\\pos_pairs.txt', pair_path);
%         neg_pair_path = sprintf('%s\\neg_pairs.txt', pair_path);
%         feat_path = sprintf('%s\\lfw_%d0k.mat', path, test_iter);
%         load(feat_path);
%     case 3
%         fprintf('Test HS_Ident\n');
%         pair_path = 'Z:\Face_DB\TrainingSet_Info\caffe\HS_Ident_pairs';
%         pos_pair_path = sprintf('%s\\pos_pairs.txt', pair_path);
%         neg_pair_path = sprintf('%s\\neg_pairs_all.txt', pair_path);
%         feat_path = sprintf('%s\\HS_Ident_%d0k.mat', path, test_iter);
%         load(feat_path);
% end

switch test_data_name_idx
    case 1
        fprintf('Test MBGC\n');
        load('../data/MBGC_pair_python.mat');
        feat_path = sprintf('%s\\MBGC110_%d0k.mat', path, test_iter);
        load(feat_path);
    case 2
        fprintf('Test LFW\n');
        load('../data/lfw_pair_python.mat');
        feat_path = sprintf('%s\\lfw_man5pt_%d0k.mat', path, test_iter);
        load(feat_path);
    case 3
        fprintf('Test HS_Ident\n');
        load('../data/HS_Ident_pair_python.mat');
        feat_path = sprintf('%s\\HSIdent_5pt_%d0k.mat', path, test_iter);
        load(feat_path);
end


%% evaluation
% pos
% fid = fopen(pos_pair_path);
% n = str2double(fgetl(fid));

% for i = 1:n
%     tmp = fgetl(fid);
%     tmp_pairs = regexp(tmp, ' ', 'split');
%     tmp_pairs = strrep(tmp_pairs, '\', '/');
%     idx1 = find(strcmp(image_path, tmp_pairs{1})==1);
%     idx2 = find(strcmp(image_path, tmp_pairs{3})==1);
%     pos_pair(1, i) = idx1;
%     pos_pair(2, i) = idx2;
%     
%     feat1 = features(idx1, :)';
%     feat2 = features(idx2, :)';
%     pos_scores(i) = distance.compute_cosine_score(feat1, feat2);
% end
% pos_label = ones(1, n);
% fclose(fid);

% neg
% fid = fopen(neg_pair_path);
% n = str2double(fgetl(fid));
% 
% for i = 1:n
%     tmp = fgetl(fid);
%     tmp_pairs = regexp(tmp, ' ', 'split');
%     tmp_pairs = strrep(tmp_pairs, '\', '/');
%     idx1 = find(strcmp(image_path, tmp_pairs{1})==1);
%     idx2 = find(strcmp(image_path, tmp_pairs{3})==1);
%     
%     neg_pair(1, i) = idx1;
%     neg_pair(2, i) = idx2;
%     
%     feat1 = features(idx1, :)';
%     feat2 = features(idx2, :)';
%     neg_scores(i) = distance.compute_cosine_score(feat1, feat2);
% end
% neg_label = -ones(1, n);
% fclose(fid);

% scores = [pos_scores, neg_scores];
% label = [pos_label neg_label];

% pos
for i = 1: length(pos_pair)
    feat1 = features(pos_pair(1, i), :)';
    feat2 = features(pos_pair(2, i), :)';
    pos_scores(i) = distance.compute_cosine_score(feat1, feat2);
end
pos_label = ones(1, length(pos_pair));

%neg
for i = 1: length(neg_pair)
    feat1 = features(neg_pair(1, i), :)';
    feat2 = features(neg_pair(2, i), :)';
    neg_scores(i) = distance.compute_cosine_score(feat1, feat2);
end
neg_label = -ones(1, length(neg_pair));

scores = [pos_scores, neg_scores];
label = [pos_label neg_label];

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
result = [ap.measure/100 roc.measure/100  roc.extra.tpr001 roc.extra.tpr0001 roc.extra.tpr00001 roc.extra.tpr000001 roc.extra.tpr0];


