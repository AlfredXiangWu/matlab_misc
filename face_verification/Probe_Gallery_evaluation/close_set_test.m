load_gallery_path = sprintf('%s\\lfw_man5pt_closeset_gallery_%d0k.mat', path, test_iter);
load(load_gallery_path);
gallery = features;
gallery_path = image_path;

load_probe_path = sprintf('%s\\lfw_man5pt_closeset_probe_%d0k.mat', path, test_iter);
load(load_probe_path)
probe = features;
probe_path = image_path;

gallery = gallery ./ repmat(sqrt(sum(gallery'.^2))', 1, size(gallery, 2));
probe = probe ./ repmat(sqrt(sum(probe'.^2))', 1, size(probe, 2));
matrix = gallery * probe';
[scores, idx] = max(matrix);

count = 0;
for i = 1:length(scores)
temp1 = regexp(gallery_path{idx(i)}, '/', 'split');
gallery_class = temp1{end - 1};
temp2 = regexp(probe_path{i}, '/', 'split');
probe_class = temp2{end - 1};

if strcmp(probe_class, gallery_class)
    count = count + 1;
end
end

rank1 = count / length(scores);