clear all;
clc;
% 
load('Z:\User\wuxiang\Result\DeepFace\DeepFace_set003\DeepFace0.3.13.x\trainset.mat');
% matlabpool(4);
save_path = 'Z:/User/wuxiang/data/WebFace/feat0.3.13.25'

parfor i = 1:size(features, 1)
    tmp = regexp(image_path{i}, '/', 'split');
    path = sprintf('%s/%s/%s', save_path, tmp{1}, tmp{2});
    if ~exist(path)
        mkdir(path);
    end
    name = strrep(tmp{3}, '.bmp', '.feat');
    save_feat_path = sprintf('%s/%s', path, name);
    fid_feat = fopen(save_feat_path, 'w+');
    fwrite(fid_feat, features(i, :), 'single');
    fclose(fid_feat);
end
