load_gallery_path = sprintf('%s\\lfw_man5pt_openset_gallery_%d0k.mat', path, test_iter);
load(load_gallery_path);
gallery = features;
gallery_path = image_path;

load_probe_path = sprintf('%s\\lfw_man5pt_openset_probe_%d0k.mat', path, test_iter);
load(load_probe_path)
probe = features;
probe_path = image_path;

load('label_openset.mat');

gallery = gallery ./ repmat(sqrt(sum(gallery'.^2))', 1, size(gallery, 2));
probe = probe ./ repmat(sqrt(sum(probe'.^2))', 1, size(probe, 2));
matrix = gallery * probe';
[scores, idx] = max(matrix);

%% DIR
neg_index = find(label==0);
neg_scores = scores(neg_index);
[temp, ~] = sort(neg_scores, 'descend');

% 1%
n = ceil(0.01*length(temp));
thr = temp(n);

pos_index = find(label==1);
pos_scores = scores(pos_index);
count = 0;
for i = 1:length(pos_scores)
    temp1 = regexp(gallery_path{idx(pos_index(i))}, '/', 'split');
    gallery_class = temp1{end - 1};
    temp2 = regexp(probe_path{pos_index(i)}, '/', 'split');
    probe_class = temp2{end - 1};
    
    if strcmp(probe_class, gallery_class) & pos_scores(i) >thr
        count = count + 1;
    end
end

DIR = count / length(pos_scores);