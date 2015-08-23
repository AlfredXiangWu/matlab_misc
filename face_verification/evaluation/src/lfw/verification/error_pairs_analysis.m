clear all;
clc;

% the MAT file contains pos/neg pairs, scores and image_path
load('DeepFace0.3.13.17_scores.mat');
debug = 0;

% save file
fid = fopen('error_log_DeepFace0.3.13.17.txt', 'w+');

% pos
pos_thr = 0.3;
path = 'Z:\User\team01\data\LFW_align_man5pt_3';
pos_num = length(pos_pair);
idx = find(scores(1:pos_num) < pos_thr);

fprintf(fid, 'Positive pairs\n');
fprintf(fid, 'positive scores <= %f, total pairs: %d\n', pos_thr, numel(idx));
fprintf('Total pairs: %d\n', numel(idx));

for i = 1:length(idx)
      
    % show image
    if debug
        img_path1 = sprintf('%s/%s', path, image_path{pos_pair(1, idx(i))});
        img_path2 = sprintf('%s/%s', path, image_path{pos_pair(2, idx(i))});
        img1 = imread(img_path1);
        img2 = imread(img_path2);
        score = sprintf('The score is %f', scores(idx(i)));
        subplot(121), imshow(img1);
        subplot(122), imshow(img2);
        title(score);
        pause;
    end
    
    fprintf(fid, '%s    %s    %0.3f\n', image_path{pos_pair(1, idx(i))}, image_path{pos_pair(2, idx(i))}, scores(idx(i)));
end

clear idx;

% neg
neg_thr = 0.3;
neg_num = length(neg_pair);
idx = find(scores(neg_num+1:6000) > neg_thr);

fprintf(fid, 'Negative pairs\n');
fprintf(fid, 'negative scores >= %f, total pairs: %d\n', neg_thr, numel(idx));
fprintf('Total pairs: %d\n', numel(idx));

for i = 1:length(idx)
      
    % show image
    if debug
        img_path1 = sprintf('%s/%s', path, image_path{neg_pair(1, idx(i))});
        img_path2 = sprintf('%s/%s', path, image_path{neg_pair(2, idx(i))});
        img1 = imread(img_path1);
        img2 = imread(img_path2);
        score = sprintf('The score is %f', scores(idx(i)));
        subplot(121), imshow(img1);
        subplot(122), imshow(img2);
        title(score);
        pause;
    end
    
    fprintf(fid, '%s    %s    %0.3f\n', image_path{neg_pair(1, idx(i))}, image_path{neg_pair(2, idx(i))}, scores(3000+idx(i)));
end

fclose(fid);
