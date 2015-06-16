function crop_img = face_crop(face_img, face_rectangle, x_n, y_n, scale)
    
    % bounding box position and size
    face_x = face_rectangle(1);
    face_y = face_rectangle(2);
    face_width = face_rectangle(3);
    face_height = face_rectangle(4);
    
    center_x = ceil(face_x + face_width/2);
    center_y = ceil(face_y + face_height/2);
    
    % crop bounding box position and size eg. (face_x, face_y, w, h)
    crop_width = ceil(face_width/scale);
    crop_height = ceil(face_height/scale);
    center_x = ceil(center_x - crop_width*x_n);
    center_y = ceil(center_y - crop_height*y_n);
    
    face_x = center_x - crop_width/2;
    face_y = center_y - crop_height/2;
    
    % crop_img init
    crop_size = max(crop_height, crop_width);
    crop_img = zeros(crop_size, crop_size, 3);
    
    
    % point
    x = max(1, face_x);
    y = max(1, face_y);
    
    crop_x = abs(min(0, face_x));
    crop_y = abs(min(0, face_y));
    
    % size
    w = min(size(face_img, 2) - abs(face_x), crop_width);
    h = min(size(face_img, 1) - abs(face_y), crop_height);
    
    % crop
    if size(face_img, 3) ~=1
        crop_img(1+ crop_y:h, 1 + crop_x:w, :) = face_img(y:y+h-1 - crop_y, x:x+w-1 - crop_x, :);
    else
        crop_img(1+ crop_y:h, 1 + crop_x:w) = face_img(y:y+h-1 - crop_y, x:x+w-1 - crop_x);
    end
    crop_img = uint8(crop_img);
end