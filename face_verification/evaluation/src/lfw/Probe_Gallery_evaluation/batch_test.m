clear all;
clc;

iter =100:4:100;


path = 'Z:\User\wuxiang\Result\DeepFace\DeepFace_set003\DeepFace0.3.13.x';

for niter = 1:size(iter, 2)
    test_iter = iter(niter);
    close_set_test;
    open_set_test;
%     result_batch(niter, :) = rank1;
    result_batch(niter, :) = [rank1, DIR];
end