%% non maximum suppression 
%    input: 
%       - bounding_boxes: [x, y]xn
%       - overlap_thr: threshold
%   output:
%       - box: [x1, y1, x2, y2];
%       - flag: 1 or 0
function boxes = non_maximum_suppression(bounding_boxes, overlap_thr)

    % init
    x1 = bounding_boxes(:, 1);
    y1 = bounding_boxes(:, 2);
    x2 = bounding_boxes(:, 3);
    y2 = bounding_boxes(:, 4);    
    prob = bounding_boxes(:, 5);
    
    % area
    area = (x2 - x1 + 1).*(y2 - y1 + 1);
    [~, idx] = sort(prob);
    num = 1;
   
    while length(idx)>0
        last = length(idx);
        i = idx(last);
        tmp = 1;
        boxes(num, :) = bounding_boxes(i, :);
        idx(last, :) = [];
        for pos = 1:last-1
            j = idx(pos);
            xx1 = max(x1(i), x1(j));
            xx2 = min(x2(i), x2(j));
            yy1 = max(y1(i), y1(j));
            yy2 = min(y2(i), y2(j));
            w = max(0, xx2 - xx1 + 1);
            h = max(0, yy2 - yy1 + 1);
            
            overlap = double(w * h) /area(j);
            if overlap > overlap_thr
                delete(tmp) = pos;
                tmp = tmp + 1;
            end
        end
        idx(delete(:), :) = [];
        delete = [];
        num = num + 1;
    end
end