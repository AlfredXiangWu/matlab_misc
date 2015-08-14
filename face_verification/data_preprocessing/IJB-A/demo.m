clear all;
clc;
img_data_path = 'Z:\User\team01\data\IJB-A\IJB-A_images';
meta_path = 'Z:\User\team01\data\IJB-A\IJB-A_11_sets';
save_path = 'Z:\User\team01\data\IJB-A\IJB-A_11_face_images';
list_path = 'Z:\User\team01\data\IJB-A\IJB-A_11_face_images';

for i = 3:10
    meta_data_path = sprintf('%s\\split%d\\verify_metadata_%d.csv', meta_path, i, i);
    save_data_path = sprintf('%s\\split%d', save_path, i);
    list_data_path = sprintf('%s\\split%d.txt', list_path, i);
    face_verif_dataset_gen(img_data_path, meta_data_path, save_data_path, list_data_path);
end