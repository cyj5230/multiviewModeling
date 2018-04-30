function [resampled_images,light_dir] = uniformResampling(path,pointer)

[vertices,~] = icosphere(4);
f = textscan(fopen(strcat(path,'lightvec.txt')),'%f %f %f');
light = [f{1} f{2} f{3}];

image_files = dir(fullfile(path,'*.bmp'));
num_images = length(image_files);
[m,n,~] = size(imread(fullfile(path,image_files(1).name)));

src_images = zeros(m,n,num_images); % transform source images from color to B&W

for i = 1:num_images
    I = imread(fullfile(path,image_files(i).name));
    src_images(:,:,i) = I(:,:,1)*0.299 + I(:,:,2)*0.587 + I(:,:,3)*0.114;
end

resampled_images = zeros(m,n,0);
light_dir = zeros(0,3);
re_num = 1;
idx = nearestneighbour(light',vertices');

for i = 1:length(vertices)
    index = find(idx==i);
    if ~isempty(index)
        light_dir(re_num,:) = vertices(i,:);
        Io = zeros(m,n);
        denominator = 0;
        for j = 1:length(index)
            denominator = denominator + vertices(i,:)*light(index(j),:)';
        end
        
        for j = 1:length(index)
            Io = Io + vertices(i,:)*light(index(j),:)'/denominator*src_images(:,:,index(j));
        end
        resampled_images(:,:,re_num) = Io;
        if re_num == pointer && pointer ~= 1
            disp(index(1));
        end
        re_num = re_num + 1;
    end
end

end