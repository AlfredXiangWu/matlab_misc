function res = face_db_align_patch(face_dir, ffp_dir, ec_mc_y, ec_y, img_size, patch_size, save_dir)

% center of eyes (ec), center of l&r mouth(mc), rotate and resize
% ec_mc_y: y_mc-y_ec, diff of height of ec & mc, to scale the image.
% ec_y: top of ec, to crop the face.


crop_size = img_size;
% fid_log = fopen('log.txt', 'wt');
subdir = dir(face_dir);
parfor i=1: length(subdir)
% for i=1: length(subdir)
    if ~subdir(i).isdir
        continue;
    end
    fprintf('[%.2f%%] %s\n', 100*i/length(subdir), subdir(i).name);
    
    for j = 1:5
        pathstr = [save_dir '/patch00' num2str(j) '/' subdir(i).name];
        if exist(pathstr, 'dir')  == 0
            fprintf('create %s\n', pathstr);
            mkdir(pathstr);
        end
    end
    
    img_fns = dir([face_dir '/' subdir(i).name '/*.bmp']);
    if isempty(img_fns)
         img_fns = dir([face_dir '/' subdir(i).name '/*.jpg']);
    end
    for k=1: length(img_fns)
        try
            img = imread([face_dir '/' subdir(i).name '/' img_fns(k).name]);
            ffp_fn = [ffp_dir '/' subdir(i).name '/' img_fns(k).name(1:end-3) '5pt'];
            if exist(ffp_fn, 'file') == 0
                img2 = img;
                fprintf('%s NOT exists.\n', ffp_fn);
                imgh = size(img,1);
                imgw = size(img,2);
                crop_y = floor((imgh - crop_size)/2);
                crop_x = floor((imgw - crop_size)/2);
                img_cropped = img(crop_y:crop_y+crop_size-1, crop_x:crop_x+crop_size-1,:);
                eyec = [1 1];
                fprintf('%s nonexists, cropped center\n', ffp_fn);
            else
                disp(ffp_fn);         
                f5pt = read_5pt(ffp_fn);
                img_cropped = align(img, f5pt, patch_size, ec_mc_y, ec_y);
            end
%             fprintf('%s %f\n', ffp_fn, resize_scale);
            
%             figure(1);
%             subplot(1,3,1);
%             imshow(img);
%             hold on;
%             plot(f5pt(1,1),f5pt(1,2), 'bo');
%             plot(f5pt(2,1),f5pt(2,2), 'bo');
%             hold off;
%             subplot(1,3,2);
%             imshow(img2);
%     %         rectangle('Position', [round(eyec(1)) round(eyec(2)) 10 10]);
%             hold on;
%             plot(eyec(1), eyec(2), 'ro');
%             plot(10,100, 'bx');
%             hold off;
%             subplot(1,3,3);
%             imshow(img_cropped);
%             pause;

            for num_patch = 1:length(img_cropped)

                img_final = imresize(img_cropped{num_patch}, [img_size img_size], 'Method', 'bicubic');
                if size(img_final,3)>1
                    img_final = rgb2gray(img_final);
                end
                save_fn = [save_dir '/patch00' num2str(num_patch) '/' subdir(i).name '/' img_fns(k).name(1:end-3) 'bmp'];
                imwrite(img_final, save_fn);
            end
        catch
            
%             fprintf(fid_log, '%s is error\n', ffp_fn);
            continue;
        end
    end 
end

% fclose(fid_log);
% fclose(log_fid);
end

function res = read_5pt(fn)
fid = fopen(fn, 'r');
raw = textscan(fid, '%f %f');
fclose(fid);
res = [raw{1} raw{2}];
end

function cropped = align(img, f5pt, patch_size, ec_mc_y, ec_y)
f5pt = double(f5pt);
ang_tan = (f5pt(1,2)-f5pt(2,2))/(f5pt(1,1)-f5pt(2,1));
ang = atan(ang_tan) / pi * 180;
img_rot = imrotate(img, ang, 'bicubic');
imgh = size(img,1);
imgw = size(img,2);

% eye center
x = (f5pt(1,1)+f5pt(2,1))/2;
y = (f5pt(1,2)+f5pt(2,2))/2;
% x = ffp(1);
% y = ffp(2);

ang = -ang/180*pi;
%{
x0 = x - imgw/2;
y0 = y - imgh/2;
xx = x0*cos(ang) - y0*sin(ang) + size(img_rot,2)/2;
yy = x0*sin(ang) + y0*cos(ang) + size(img_rot,1)/2;
%}
img_size =  size(img);
img_rot_size = size(img_rot);

[xx, yy] = transform(x, y, ang, img_size, img_rot_size);
eyec = round([xx yy]);
x = (f5pt(4,1)+f5pt(5,1))/2;
y = (f5pt(4,2)+f5pt(5,2))/2;
[xx, yy] = transform(x, y, ang, size(img), size(img_rot));
mouthc = round([xx yy]);

resize_scale = ec_mc_y/(mouthc(2)-eyec(2));

img_resize = imresize(img_rot, resize_scale);

res = img_resize;
% eyec2 = (eyec - [size(img_rot,2)/2 size(img_rot,1)/2]) * resize_scale + [size(img_resize,2)/2 size(img_resize,1)/2];
% eyec2 = round(eyec2);
% img_crop = zeros(crop_size, crop_size, size(img_rot,3));
% % crop_y = eyec2(2) -floor(crop_size*1/3);
% crop_y = eyec2(2) - ec_y;
% crop_y_end = crop_y + crop_size - 1;
% crop_x = eyec2(1)-floor(crop_size/2);
% crop_x_end = crop_x + crop_size - 1;
% 
% box = guard([crop_x crop_x_end crop_y crop_y_end], size(img_resize,1));
% img_crop(box(3)-crop_y+1:box(4)-crop_y+1, box(1)-crop_x+1:box(2)-crop_x+1,:) = img_resize(box(3):box(4),box(1):box(2),:);

%% crop patch
for i = 1:size(f5pt, 1)
    cropped{i} = patch_crop(img_resize, f5pt(i, :), patch_size, ang, img_size, img_rot_size, resize_scale);
end

end

function r = guard(x, N)
x(x<1)=1;
x(x>N)=N;
r = x;
end

function [xx, yy] = transform(x, y, ang, s0, s1)
% x,y position
% ang angle
% s0 size of original image
% s1 size of target image

x0 = x - s0(2)/2;
y0 = y - s0(1)/2;
xx = x0*cos(ang) - y0*sin(ang) + s1(2)/2;
yy = x0*sin(ang) + y0*cos(ang) + s1(1)/2;
end

function crop = patch_crop(img_resize, ffp, patch_size, ang, img_size, img_rot_size, resize_scale)
    x = ffp(1);
    y = ffp(2);
    [xx, yy] = transform(x, y, ang, img_size, img_rot_size);
    p = round([xx yy]);
    
    pp = (p - [img_rot_size(2)/2 img_rot_size(1)/2]) * resize_scale + [size(img_resize,2)/2 size(img_resize,1)/2];
    pp = round(pp);
    
    crop_y = pp(2) - patch_size / 2 + 1;
    crop_y_end = pp(2) + patch_size / 2;
    crop_x = pp(1) - patch_size / 2 + 1;
    crop_x_end = pp(1) + patch_size / 2;
    
    box = guard([crop_x crop_x_end crop_y crop_y_end], size(img_resize,1));
    
    crop = zeros(patch_size, patch_size, size(img_resize,3));
    crop(box(3)-crop_y+1:box(4)-crop_y+1, box(1)-crop_x+1:box(2)-crop_x+1,:) = img_resize(box(3):box(4),box(1):box(2),:);
    
    crop = crop / 255;
end