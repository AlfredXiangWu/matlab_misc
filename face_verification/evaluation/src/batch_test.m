clear all;
clc;

% config
test_data_name_idx =2;       % 1-MBGC, 2-LFW, 3-HS_Ident
iter =88:4:120;


path = 'Z:\User\wuxiang\Result\DeepFace\DeepFace_set003\DeepFace0.3.18.x';

for n = 1:size(iter, 2)
    test_iter = iter(n);
    deep_face_test_python;
    result_batch(n, :) = result;
end
