% clear all;
% clc;
rng(7610);

% load('Z:\User\wuxiang\Result\DeepFace\DeepFace_set003\DeepFace0.3.13.x\trainset.mat');

% normalization
features = features ./ repmat(sqrt(sum(features.^2, 2)), 1, size(features, 2));

nclass = 200;
neg_seed = 200;
alpha = 0.5;
fid_pair_list = fopen('triplet_pairs.txt', 'wt');
fid_score = fopen('triplet_pairs_scores.txt', 'wt');

idx = find(labels < nclass);
feat = features(idx, :);
label = labels(idx);
path = image_path(idx);

fid_list = fopen('WebFace_triplet_image_list_bootstrap001.txt', 'w+');
for i = 1:length(path)
    fprintf(fid_list, '%s %d\n', path{i}, label(i));
end
fclose(fid_list);

for i = 1:nclass
    pos_feat = [];
    neg_feat = [];
    idx_class = find(label == i - 1);
    pos_feat = feat(idx_class, :);
    pos_path = path(idx_class);
    neg_feat = feat;
    neg_feat(idx_class, :) = [];
    neg_path = path;
    neg_path(idx_class, :) = [];
    
    % select negative samples
    idx_neg = randperm(size(neg_feat, 1));
    neg_feat = neg_feat(idx_neg(1:neg_seed), :);
    neg_path = neg_path(idx_neg(1:neg_seed));
    
    % compute distance
    for m = 1:size(pos_feat, 1) - 1
%         anchor = find(path{:} == pos_path{m});
        anchor = strmatch(pos_path{m}, path, 'exact');
        for n = m+1:size(pos_feat, 1)
%             pos = find(path == pos_path(n));
            pos = strmatch(pos_path{n}, path, 'exact');
            feat1 = pos_feat(m, :);
            feat2 = pos_feat(n, :);
            pos_score = sum((feat1 - feat2).^2);
            for k = 1:size(neg_feat, 1)
                feat3 = neg_feat(k, :);
                neg_score = sum((feat1 - feat3).^2);
                neg = strmatch(neg_path{k}, path, 'exact');
%                 neg = find(path == neg_path(k));
                line_scores = sprintf('%d %d %d %f %f\n', anchor, pos, neg, pos_score, neg_score);
                fprintf(fid_score, '%s', line_scores);
                fprintf('%s', line_scores);
                if pos_score < neg_score && pos_score + alpha > neg_score
                    line = sprintf('%d %d %d\n', anchor, pos, neg);
                    fprintf(fid_pair_list, '%s', line);
                end
            end
        end
    end  
end
fclose(fid_pair_list);
fclose(fid_score);