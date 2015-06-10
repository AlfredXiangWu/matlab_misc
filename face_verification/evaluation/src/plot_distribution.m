clear all;
clc;
load('DeepFace0.3.13.16_scores.mat');


[hp, bin1] = hist(scores(1:3000), 100);
[hn, bin2] = hist(scores(3001:6000),100);
figure,plot(bin1, hp, 'b.-'), hold on, plot(bin2, hn,'r*-'), legend('positive-pair','negtive-pair');
