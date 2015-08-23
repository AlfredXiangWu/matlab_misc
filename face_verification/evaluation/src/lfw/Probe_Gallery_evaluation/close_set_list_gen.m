clear all;
clc;

%% probe
fid = fopen('./TIFS_SI-2014_protocols/closedset_probe_3143.txt');
fid_out = fopen('lfw_closeset_probe_list_linux.txt', 'wt');
line = fgetl(fid);
while ischar(line)
    temp = regexp(line, '_', 'split');
    name = temp{1};
    for i = 2:length(temp) - 1 
        name = sprintf('%s_%s', name, temp{i});
    end
    temp = strrep(line, '.jpg', '.bmp');
    list = sprintf('lfw/image/%s/%s', name, temp);
    fprintf(fid_out, '%s 1\n', list);
    line = fgetl(fid);
end
fclose(fid);
fclose(fid_out);


%% gallery
fid = fopen('./TIFS_SI-2014_protocols/closedset_gallery_4249.txt');
fid_out = fopen('lfw_closeset_gallery_list_linux.txt', 'wt');
line = fgetl(fid);
while ischar(line)
    temp = regexp(line, '_', 'split');
    name = temp{1};
    for i = 2:length(temp) - 1 
        name = sprintf('%s_%s', name, temp{i});
    end
    temp = strrep(line, '.jpg', '.bmp');
    list = sprintf('lfw/image/%s/%s', name, temp);
    fprintf(fid_out, '%s 1\n', list);
    line = fgetl(fid);
end
fclose(fid);
fclose(fid_out);