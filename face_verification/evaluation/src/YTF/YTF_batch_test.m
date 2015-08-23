clear all;
clc;


iter =108:4:200;
path = 'Z:\User\wuxiang\Result\DeepFace\DeepFace_set003\DeepFace0.3.22.x';

for n = 1:size(iter, 2)
    fprintf('YTF test...\n');
    test_iter = iter(n);
    feat_path = sprintf('%s\\YTF_man5pt_%d0k.mat', path, test_iter);
    load(feat_path);
    [ap, roc] = YTF_evaluation(features, labels);
    result = [ap.measure/100 roc.measure/100  roc.extra.tpr001 roc.extra.tpr0001 roc.extra.tpr00001 roc.extra.tpr000001 roc.extra.tpr0 roc.extra.auc];
    result_batch(n, :) = result;
    
    fprintf('ap:                 %f\n', ap.measure);
    fprintf('eer:               %f\n', roc.measure);
    fprintf('tpr001:         %f\n', roc.extra.tpr001*100);
    fprintf('tpr0001:       %f\n', roc.extra.tpr0001*100);
    fprintf('tpr00001:     %f\n', roc.extra.tpr00001*100);
    fprintf('tpr000001:   %f\n', roc.extra.tpr000001*100);
    fprintf('tpr0:              %f\n', roc.extra.tpr0*100);
end