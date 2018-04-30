function [normal] = initial_norm(images,light_dir)

[img_width,img_length,num_img] = size(images);
img_ranks = zeros(img_width,img_length,num_img);

for i = 1:img_width
    for j = 1:img_length
        [~,I] = sort(images(i,j,:));
        I = reshape(I,[num_img,1]);
        img_ranks(i,j,I) = 1:num_img;
    end
end

kL = zeros(num_img,1);
rL = zeros(num_img,1);
L = 0.7*num_img;
H = 0.9*num_img;

for i = 1:num_img
    count = 0;
    total_rank = 0;
    for x = 1:img_width
        for y = 1:img_length
            s = img_ranks(x,y,i);
            if s>L
                count = count+1;
                total_rank = total_rank + s;
            end
        end
    end
    kL(i) = count;
    rL(i) = total_rank/count;
end

[~,idx] = sort(kL);
for i = 1:length(idx)
    if rL(idx(length(idx)-i+1))<H
        deno_img = images(:,:,idx(length(idx)-i+1));
        images(:,:,idx(length(idx)-i+1)) = [];
        deno_light = light_dir(idx(length(idx)-i+1),:);
        light_dir(idx(length(idx)-i+1),:) = [];
        disp(idx(length(idx)-i+1));
        break;
    end
end

normal = zeros(img_width,img_length,3);

for i = 1:img_width
    for j = 1:img_length
        I = reshape(images(i,j,:),[num_img-1,1]);
        A = deno_img(i,j).*light_dir - I*deno_light;
        [~,~,v] = svd(A,0);
        x = v(:,end);
        if x(3)<0
            x = -x;
        end
        normal(i,j,:) = x; % x is 3 by 1
    end
end

end