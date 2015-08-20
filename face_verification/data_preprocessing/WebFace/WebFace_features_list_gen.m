clear all;
clc;

fid = fopen('../../bootstrap/WebFace_triplet_image_list_bootstrap001.txt');
fid_list = fopen('WebFace_triplet_image_list_bootstrap001.txt', 'w+');
line = fgetl(fid);
while ischar(line)
   line = strrep(line, '.bmp', '.feat');
   fprintf(fid_list, '%s\n', line);
   line = fgetl(fid);
end

fclose(fid);
fclose(fid_list);