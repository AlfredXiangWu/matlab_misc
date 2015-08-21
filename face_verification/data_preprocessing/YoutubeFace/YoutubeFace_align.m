clear all;
clc;

%% parameters
face_dir = 'Z:\User\wuxiang\data\YotubeFace\face_image';
ffp_dir = 'Z:\User\wuxiang\data\YotubeFace\5pt';
save_dir = 'Z:\User\team01\data\YoutubeFace_align_3';
ec_mc_y = 48;
ec_y = 40;
img_size = 128;


%% process
path = dir(face_dir);

parfor i = 1:length(path)
    if strcmp(path(i).name, '.')|| strcmp(path(i).name, '..')
        continue;
    end
    subpath = sprintf('%s\\%s', face_dir, path(i).name);
    ffp_subpath = sprintf('%s\\%s', ffp_dir, path(i).name);
    save_subpath = sprintf('%s\\%s', save_dir, path(i).name);
    subsubdir = dir(subpath);
    for j = 1:length(subsubdir)
        if strcmp(subsubdir(j).name, '.')|| strcmp(subsubdir(j).name, '..')
            continue;
        end
        face_path = sprintf('%s\\%s', subpath, subsubdir(j).name);
        ffp_path = sprintf('%s\\%s', ffp_subpath, subsubdir(j).name);
        save_path = sprintf('%s\\%s', save_subpath, subsubdir(j).name)
        mkdir(save_path);
        face_db_align(face_path, ffp_path, ec_mc_y, ec_y, img_size, save_path)        
    end
end

