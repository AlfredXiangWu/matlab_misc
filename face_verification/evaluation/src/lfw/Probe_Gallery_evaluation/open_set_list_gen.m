% clear all;
% clc;

%% gallery
% fid = fopen('./TIFS_SI-2014_protocols/still_gallery.txt');
% line = fgetl(fid);
% fid_out = fopen('lfw_openset_gallery.txt', 'wt');
% 
% while ischar(line)
%     temp = regexp(line, '/', 'split');
%     if length(temp) == 3
%         line = fgetl(fid);
%         continue;
%     end
%     path = strrep(line, '.jpg', '.bmp');
%     fprintf(fid_out, 'lfw/image/%s 1\n', path);
%     
%     line = fgetl(fid);
% end
% fclose(fid);
% fclose(fid_out);
% 
% %% probe
% fid = fopen('./TIFS_SI-2014_protocols/still_probe.txt');
% line = fgetl(fid);
% fid_out = fopen('lfw_openset_probe.txt', 'wt');
% 
% while ischar(line)
%     path = strrep(line, '.jpg', '.bmp');
%     fprintf(fid_out, 'lfw/image/%s 1\n', path);
%     line = fgetl(fid);
% end
% fclose(fid);
% fclose(fid_out);

%% label
% fid = fopen('./TIFS_SI-2014_protocols/subjects_LFWYTF_596.txt');
% line = fgetl(fid);
% count = 1;
% while ischar(line)
%     subject{count} = line;
%     count = count + 1;
%     line = fgetl(fid);
% end
% fclose(fid);

fid = fopen('./TIFS_SI-2014_protocols/still_probe.txt');
line = fgetl(fid);


count = 1;
while ischar(line)
    path = regexp(line, '/', 'split');
    if ~isempty(find(strcmp(subject, path{1})))
        label(count) = 1;
    else
        label(count) = 0;
    end
    count = count + 1;
    line = fgetl(fid);
end
fclose(fid);