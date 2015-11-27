clear all;
clc;

face_dir = '/home/xiang.wu/data/CASIA-WebFace/image';
ffp_dir = '/home/xiang.wu/data/5pt/CASIA-WebFace/image';
save_dir = '/home/xiang.wu/data/CASIA-WebFace_patch/image';
ec_mc_y = 48;
ec_y = 48;
img_size = 72;
patch_size = 72;

face_db_align_patch(face_dir, ffp_dir, ec_mc_y, ec_y, img_size, patch_size, save_dir);