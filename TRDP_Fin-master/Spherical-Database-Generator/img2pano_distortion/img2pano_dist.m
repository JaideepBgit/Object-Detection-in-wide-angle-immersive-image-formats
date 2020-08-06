function img2pano_dist(VOC_path,results_path,sphereH,sphereW,imHoriFOV,dataset_file_ext)
% img2pano_dist takes all images in a path (with the VOC structure) and
% distort all images following the distortion in a ERP projection
% Inputs:
%   VOC_path: Input path. Assumes a dir structure as the VOC (/JPEGImages,/Annotations)
%   results_path: Results path. Creates a dir structure such as the VOC (/JPEGImages,/Annotations)
%   sphereH: Height of the ERP image
%   sphereW: Width of the ERP image (must be 2 x sphereH)
%   imHoriFOV: horizontal FOV of the original images (in radians)
%   ratio_X_shift: translation of the center of original image in the ERP image (x-axis). Ratio (sphereW) from center
%   ratio_Y_shift: translation of the center of original image in the ERP image (y-axis). Ratio (sphereY) from center
% Outputs:
%   Creates results in results_path



debug_flag = 0; % show images

% shift in pixels
% dir structure in the VOC style
out_images_dir = [results_path '/dist_' num2str(dataset_file_ext) '/JPEGImages/'];
out_annotations_dir = [results_path '/dist_' num2str(dataset_file_ext) '/Annotations/'];

if ~exist(out_images_dir)
    mkdir(out_images_dir)
end
if ~exist(out_annotations_dir)
    mkdir(out_annotations_dir)
end

% read all images in VOC folder
list_imgs = dir([VOC_path '/JPEGImages/']);
bkg_img = dir([VOC_path '/background_image/']);
seg_img = dir([VOC_path '/SegmentationObject/']);
seg_img_class = dir([VOC_path '/SegmentationClass/']);
seg_obj_ids = extractfield(seg_img,'name')';
seg_cla_ods = extractfield(seg_img_class,'name')';
for ind_im = 4:size(list_imgs,1)
    im_id = list_imgs(ind_im).name(1:end-4); % remove jpg extension
    im = double(imread([VOC_path '/JPEGImages/' im_id '.jpg'])); % seems im2Sphere does not accept uint8 data
    im_sz = size(im);
    
    if debug_flag
        h_im_orig = figure(1);
        imshow(uint8(im));
        hold on
        
    end
    x_val =0;
    y_val = rand(1,1);
    while(y_val>max_val_dist)
        y_val = rand(1,1);
    end
    X_shift = round(sphereW * x_val);
    Y_shift = round(sphereH * y_val);
    % project image to panorama
    % set position of the center of the view in the panoramic image
    coords = [sphereW/2+X_shift sphereH/2+Y_shift];
    % transform to uv notation
    [ uv ] = coords2uv( coords, sphereW, sphereH );
    [sphereImg, validMap] = im2Sphere(im, imHoriFOV, sphereW, sphereH, uv(1), uv(2) );
    
    if debug_flag
        h_pano = figure(2);
        imshow(uint8(sphereImg));
        hold on
        figure(12);
        imagesc((validMap));
    end
    %% read the background image based on class
    annotations_curr = VOCreadxml([VOC_path '/Annotations/' im_id '.xml']);
    object_curr = annotations_curr.annotation.object;
    name_object = object_curr(1).name;
    
    % read the bkg image
    if (strcmp(name_object,'aeroplane')||strcmp(name_object,'train'))
        im_bkg_id = bkg_img(5).name(1:end-4);
        im_bkg = double(imread([VOC_path '/background_image/' im_bkg_id '.jpg'])); % seems im2Sphere does not accept uint8 data
    elseif(strcmp(name_object,'bicycle')||strcmp(name_object,'bus')||strcmp(name_object,'car')||strcmp(name_object,'motorbike'))
        im_bkg_id = bkg_img(5).name(1:end-4);
        im_bkg = double(imread([VOC_path '/background_image/' im_bkg_id '.jpg'])); % seems im2Sphere does not accept uint8 data
    elseif(strcmp(name_object,'bird'))
        im_bkg_id = bkg_img(4).name(1:end-4);
        im_bkg = double(imread([VOC_path '/background_image/' im_bkg_id '.jpg'])); % seems im2Sphere does not accept uint8 data
    elseif(strcmp(name_object,'boat'))
        im_bkg_id = bkg_img(4).name(1:end-4);
        im_bkg = double(imread([VOC_path '/background_image/' im_bkg_id '.jpg'])); % seems im2Sphere does not accept uint8 data
    elseif(strcmp(name_object,'bottle')||strcmp(name_object,'chair')||strcmp(name_object,'diningtable')||strcmp(name_object,'person')||strcmp(name_object,'pottedplant')||strcmp(name_object,'sofa')||strcmp(name_object,'tvmonitor'))
        im_bkg_id = bkg_img(6).name(1:end-4);
        im_bkg = double(imread([VOC_path '/background_image/' im_bkg_id '.jpg'])); % seems im2Sphere does not accept uint8 data
    elseif(strcmp(name_object,'cat')||strcmp(name_object,'cow')||strcmp(name_object,'dog')||strcmp(name_object,'horse')||strcmp(name_object,'sheep'))
        im_bkg_id = bkg_img(6).name(1:end-4);
        im_bkg = double(imread([VOC_path '/background_image/' im_bkg_id '.jpg'])); % seems im2Sphere does not accept uint8 data
    end
    
    % perform resizing of image if required
    if(size(im_bkg,1)~=1500 || size(im_bkg,1)~=3000)
        im_bkg = imresize(im_bkg,[1500,3000]);
    end
    %% segmentation mask reading
    % read the segmentation mask
    
    Index_obj = find(contains(seg_obj_ids,im_id));
    if (isequal(Index_obj,double.empty(0,1)))
        Index_cla = find(contains(seg_cla_ods,im_id));
        flag_flag=1;
    else
        flag_flag=0;
    end
    
    
    if(flag_flag==1 && ~isequal(Index_cla,double.empty(0,1)))
        im_seg_id = seg_img(Index_cla).name(1:end-4); % remoce jpg extension
    elseif(flag_flag==0 && ~isequal(Index_obj,double.empty(0,1)))
        im_seg_id = seg_img(Index_obj).name(1:end-4); % remoce jpg extension
    else
        continue;
    end
    
    im_seg = double(imread([VOC_path '/SegmentationClass/' im_seg_id '.png'])); % seems im2Sphere does not accept uint8 data
    %convert the segmentation mask to the required.
    [sphereSegImg, validSegMap] = im2Sphere(im_seg, imHoriFOV, sphereW, sphereH, uv(1), uv(2));
    if debug_flag
        h_pano = figure(3);
        imshow((sphereSegImg));
        hold on
        figure(4);
        imagesc(validSegMap);
    end
    
    im_seg_req = zeros(size(sphereSegImg));
    for i =1:size(sphereSegImg,1)
        for j=1:size(sphereSegImg,2)
            if(sphereSegImg(i,j)>0)
                im_seg_req(i,j,:) = 1;
            end
        end
    end
    %%   image stitching
    
    valid_seg = logical(im_seg_req) & validSegMap;
    valid_seg = repmat(valid_seg,1,1,3);
    im_bkg(valid_seg) = sphereImg(valid_seg);
    if debug_flag
        figure(5);imshow(uint8(im_bkg));
    end
    %%
    % check if center of image in uv coords go to original location
    [ coords_check ] = uv2coords( uv, sphereW, sphereH);
    % convert center of image in xyz
    [ xyz ] = uv2xyzN(uv);
    
    % crop valid map of panorama image
    [row,col] = find(validMap (:,:,1) == 1);
    ymin_crop = min(row);
    ymax_crop = max(row);
    xmin_crop = min(col);
    xmax_crop = max(col);
    
    
    
    % save distorted image
    imwrite(uint8(im_bkg), [out_images_dir im_id '.jpg'])
    
    % read image annotations
    annotations = VOCreadxml([VOC_path '/Annotations/' im_id '.xml']);
    
    % copy annotations to modify them
    annotations_dist = annotations;

    annotations_dist.annotation.size.width = xmax_crop-xmin_crop+1;
    annotations_dist.annotation.size.height = ymax_crop-ymin_crop+1;
    objects = annotations.annotation.object;
    
    for ind_obj = 1:size(objects,2)
        
        % bounding box coordinates
        bbox = objects(ind_obj).bndbox;
        
        % paint bbox
        if debug_flag
            figure(1),rectangle('Position', [str2num(bbox.xmin), str2num(bbox.ymin), str2num(bbox.xmax)-str2num(bbox.xmin), str2num(bbox.ymax)-str2num(bbox.ymin)],	'EdgeColor','r', 'LineWidth', 3)
        end
        
        bbx_points = [ str2num(bbox.xmin) str2num(bbox.xmax) str2num(bbox.xmin) str2num(bbox.xmax);
            str2num(bbox.ymin) str2num(bbox.ymin) str2num(bbox.ymax) str2num(bbox.ymax)];
        bbx_points = bbx_points';
        
        % extract also upper and lower medium points (to avoid problems with big distorted objects)
        upper_middle_x = round((str2num(bbox.xmin) + str2num(bbox.xmax))/2);
        upper_middle_y = str2num(bbox.ymin);
        lower_middle_x = round((str2num(bbox.xmin) + str2num(bbox.xmax))/2);
        lower_middle_y = str2num(bbox.ymax);
        bbx_points(5,:) = [upper_middle_x upper_middle_y];
        bbx_points(6,:) = [lower_middle_x lower_middle_y];
        
        % project bbox points to panorama image
        [ out3DNorm, out3DPlane ] = projectPointFromSeparateView(  bbx_points, xyz, imHoriFOV,  im_sz(2), im_sz(1));
        [ uv_bbox ] = xyz2uvN( out3DNorm);
        [ coord_bbox ] = uv2coords( uv_bbox, sphereW, sphereH);
        if debug_flag
            figure(2), plot(coord_bbox(:,1),coord_bbox(:,2),'r+', 'MarkerSize', 4);
            pause
        end
        
        % extract bounding rectangle of distorted bounding box
        xmin_brect = min(coord_bbox(:,1));
        xmax_brect = max(coord_bbox(:,1));
        ymin_brect = min(coord_bbox(:,2));
        ymax_brect = max(coord_bbox(:,2));
        
        if debug_flag
            rectangle('Position', [xmin_brect, ymin_brect, xmax_brect-xmin_brect,ymax_brect-ymin_brect],'EdgeColor','r', 'LineWidth', 3)
        end
        

        
        % save new bbox to xml data
        annotations_dist.annotation.object(ind_obj).bndbox.xmax = xmax_brect;
        annotations_dist.annotation.object(ind_obj).bndbox.xmin = xmin_brect;
        annotations_dist.annotation.object(ind_obj).bndbox.ymax = ymax_brect;
        annotations_dist.annotation.object(ind_obj).bndbox.ymin = ymin_brect;
    end
    
    % write new xml
    VOCwritexml(annotations_dist, [ out_annotations_dir im_id '.xml'])
    
    if debug_flag
        figure(1), hold off
        figure(2), hold off
        figure(3), hold off
        pause
    end
    
end

end