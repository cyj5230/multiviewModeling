% give the datapath of given images
% examples of datapath: 'data/data02' 'data/data04' 'data/data06'
path='data/data02/';

%% load given dataset and light vector of corresponding images from datapath
[resampled_images,light_direction] = uniformResampling(path,1);

%% inital normal estimation
initial_normal = initial_norm(resampled_images,light_direction);
%surf = shapeFromNormal(initial_normal,2,I);
imshow((-1/sqrt(3)*initial_normal(:,:,1) + 1/sqrt(3)*initial_normal(:,:,2) + 1/sqrt(3)*initial_normal(:,:,3))/1.1);

%% refine normal from initial estimation
refined_normal = refine_norm(initial_normal,0.5,0.6);
%surf = shapeFromNormal(refined_normal,6,I);
surf = shapeFromNormal(refined_normal,6);
imshow((-1/sqrt(3)*refined_normal(:,:,1) + 1/sqrt(3)*refined_normal(:,:,2) + 1/sqrt(3)*refined_normal(:,:,3))/1.1);