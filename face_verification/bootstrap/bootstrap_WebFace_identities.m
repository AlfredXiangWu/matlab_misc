clear all;
clc;

rng(7610);
num_seed = 100;
num_select = 200;
load('../data/trainset.mat');
num_identity = numel(unique(labels));

% compute center of identities
for i = 1:num_identity
    idx = find(labels == i-1);
    tmp = features(idx, :);
    center(i, :) = mean(tmp);
end

% compute inter-class
dist = pdist2(center, center);
idx_identity = randperm(num_identity);
idx_select = [];

% select identities
for i = 1:num_seed
    scores = dist(:, idx_identity(i));
    [~, idx] = sort(scores, 'ascend');
    idx_select = [idx_select idx(2:1+num_select)];
end

% output
idx_final = unique(idx_select);


fid = fopen('CASIA_WebFace_align3_bootstrap_identities_train_list.txt', 'w+');
for i = 1:length(idx_final)
    idx = find(labels == idx_final(i)-1);
    for j = 1:length(idx)
        fprintf(fid, '%s %d\n', image_path{idx(j)}, i - 1);
    end
end
fclose(fid);