%% This program is used to crop the face images from IJB-A dataset for each split of verificaition tasks.
% This program is used "/face_detection/face_crop.m" program. Therefore, you should run 
% addpath('../../../face_detection/).  
function [] = face_verif_dataset_gen(img_data_path, meta_data_path, save_data_path, list_path)
    if ~exist(save_data_path)
        mkdir(sprintf('%s/%s', save_data_path, 'frame'));
        mkdir(sprintf('%s/%s', save_data_path, 'img'));
    end
    
    fid = fopen(meta_data_path);
    list = fgetl(fid);
    fid_list = fopen(list_path, 'w+');
    list = fgetl(fid);
    
    while list~=-1
       % load face image information    
       tmp = regexp(list, ',', 'split');
       img_name = tmp{3};
       label = tmp{2};
       face_xtl = round(str2num(tmp{7}));
       face_ytl = round(str2num(tmp{8}));
       face_width = round(str2num(tmp{9}));
       face_height = round(str2num(tmp{10}));
       face_size = max(face_width, face_height);
       face_rectangle = [face_xtl, face_ytl, face_size, face_size];
       
       % crop face image
       img_path = sprintf('%s/%s', img_data_path, img_name);
       img_path = strrep(img_path, '\', '/');
       img = imread(img_path);
       crop_img = face_crop(img, face_rectangle, 0, 0, 1);
       
       % save face image
       save_path = sprintf('%s/%s', save_data_path, img_name);
       save_path = strrep(save_path, '\', '/');
       imwrite(crop_img, save_path);
       fprintf(fid_list, '%s %s\n', save_path, label);
       list = fgetl(fid);
    end
    
    fclose(fid);
    fclose(fid_list);
end
