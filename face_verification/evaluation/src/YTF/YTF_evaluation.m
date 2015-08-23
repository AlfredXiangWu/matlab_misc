function [ap, roc] = YTF_evaluation(features, class)
    load('YTF_pairs.mat');
    features = features ./ repmat(sqrt(sum(features'.^2))', 1, size(features, 2));
    for i = 1:length(labels)
        temp1 = [];
        temp2 = [];
        
        idx1 = pairs(i, 1) - 1;
        idx2 = pairs(i, 2) - 1;
       
        temp1_idx = find(class == idx1);
        temp2_idx = find(class == idx2);
       
        temp1 = features(temp1_idx, :);
        temp2 = features(temp2_idx, :);
        temp_score = temp1*temp2';
        scores(i) = mean(mean(temp_score));
    end
    
    % ap
    ap = evaluate('ap', scores, labels);

    % roc
    roc = evaluate('roc', scores, labels);
end

function result = evaluate(config, scores, gt)

    scores = reshape(scores, 1, []);

    switch config     
        case 'ap' 
            [res, extra] =ap(scores, gt);
        case 'roc'   
            [res, extra] = roc(scores, gt);
    end
        
    % measure name
    result.meas_name = config;

    % measure value (a scalar)
    result.measure = res;

    % extra data in a struct (e.g. optimal thresh), or empty
    result.extra = extra;
end

function [res, extra] = ap(scores, gt)

    [~,~,info] = vl_pr(gt, scores);
    
    res = info.auc * 100;
    extra = info;
end

function [res, extra] = roc(scores, gt)
    
    [~,~,info] = vl_roc(gt, scores);
    
    % the accuracy at the ROC operating point where the error rates are equal (as in [Guillaumin et al., ICCV '09])
    res = (1 - info.eer) * 100;
    extra = info;
end