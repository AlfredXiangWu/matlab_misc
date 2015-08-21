clear all
close all
clc

fid = fopen('result.bin', 'rb');
imageNum = fread(fid, 1, 'int32');
pointNum = fread(fid, 1, 'int32');
assert(pointNum == 5);
valid = fread(fid, imageNum, 'int8');
assert(all(valid) == 1);
point = reshape(fread(fid, 2 * pointNum * imageNum, 'float64'), [2 * pointNum, imageNum])';
fclose(fid);

img_size = [200 200];

% fid = fopen('bbox.txt', 'r');
% for i = 1:imageNum
%     imageName{i} = fscanf(fid, '%s', 1);
%     box(i, :) = fscanf(fid, '%d', 4);
% end
% fclose(fid);
load('face_box.mat');


parfor n1 = 1 : imageNum
    name = imageName{n1};
    bbox = box(n1, :);
    I = imread(['Z:/User/team01/data/YouTubeFaces/YouTubeFaces/frame_images_DB/' name]);
    if size(I, 3) == 1
        I = repmat(I, [1 1 3]);
    end
    
    % path
    tmp = regexp(name, '/', 'split');
    save_img_path = sprintf('Z:/User/wuxiang/data/YotubeFace/face_image/%s/%s', tmp{1}, tmp{2});
    if ~exist(save_img_path)
        mkdir(save_img_path);
    end
    save_5pt_path = sprintf('Z:/User/wuxiang/data/YotubeFace/5pt/%s/%s', tmp{1}, tmp{2});
    if ~exist(save_5pt_path)
        mkdir(save_5pt_path);
    end
    
    
    step = ceil(0.08*min(size(I, 1), size(I, 2)));
    xtl = max(bbox(1) - step, 1);
    ytl = max(bbox(3) - step, 1);
    xbr = min(bbox(2) + step, size(I, 2));
    ybr = min(bbox(4) + step, size(I, 1));
    img = I(ytl:ybr, xtl:xbr, :);
    [h, w, ~] = size(img);
    img = imresize(img, img_size);
    scale = img_size(1) / h;
    imwrite(img, sprintf('%s/%s', save_img_path, tmp{3}));
    temp = strrep(tmp{3}, '.jpg', '.5pt');
    save_5pt_path = sprintf('%s/%s', save_5pt_path, temp);
    fid_5pt = fopen(save_5pt_path, 'wt');
    
    pt = point(n1, :);
    pt = round(pt) + 1;

    for n2 = 1 : pointNum
        p = pt(n2 * 2 - 1 : n2 * 2);
        p1 = p(1) - xtl;
        p2 = p(2) - ytl;
        fprintf(fid_5pt, '%d\t%d\n', round(scale*p1), round(scale*p2));
    end
    fclose(fid_5pt);
    
%     % debug
%     imshow(img);
%     hold on;
%     for n2 = 1 : pointNum
%         
%         p = pt(n2 * 2 - 1 : n2 * 2);
%         p1 = p(1) - xtl;
%         p2 = p(2) - ytl;
%         plot(round(scale*p1), round(scale*p2), 'b*');
%     end
%     pause;
    fprintf('%s..\n', name);
end
