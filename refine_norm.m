function [refined_normal] = refine_norm(initial_normal,lambda,sigma)

[vertices,~] = icosphere(5);
vertices = vertices(vertices(:,3)>0,:);
[image_width,image_length,~] = size(initial_normal);
normal = zeros(image_width*image_length,3);
for i = 1:3
    normal(:,i) = reshape(initial_normal(:,:,i),[image_width*image_length,1]);
end
%normal = reshape(initial_normal,[],3);
label = knnsearch(vertices,normal); % find the nearest neighbour for normal from vertices


h = GCO_Create(image_width*image_length,length(vertices)); % (NumSties, NumLabels)
GCO_SetLabeling(h,label');
datacost = int32(10000*pdist2(vertices,normal));
GCO_SetDataCost(h,datacost);
smoothnesscost = pdist2(vertices,vertices);
smoothnesscost = int32(10000*lambda*log10(1+smoothnesscost/(2*sigma*sigma)));
GCO_SetSmoothCost(h,smoothnesscost);

si = zeros((image_width-1)*image_length+(image_length-1)*image_width,1);
for i = 1:image_length
    for j = 1:image_width-1
        si(j+(i-1)*(image_width-1)) = j+(i-1)*image_width;
    end
end
for i = 1:image_length-1
    for j = 1:image_width
        si((image_width-1)*image_length+(i-1)*image_width+j) = j+(i-1)*image_width;
    end
end

sj = zeros((image_width-1)*image_length+(image_length-1)*image_width,1);
sv = ones((image_width-1)*image_length+(image_length-1)*image_width,1);

for i = 1:image_length
    for j = 1:image_width-1
        sj(j+(i-1)*(image_width-1)) = j+1+(i-1)*image_width;
    end
end
for i = 1:image_length-1
    for j = 1:image_width
        sj((image_width-1)*image_length+(i-1)*image_width+j) = j+i*image_width;
    end
end

S = sparse(si,sj,sv,image_width*image_length,image_width*image_length);
GCO_SetNeighbors(h,S);
GCO_Expansion(h);
labeling = GCO_GetLabeling(h);
GCO_Delete(h);

refined_normal = zeros(image_width,image_length,3);
for i = 1:image_width
    for j = 1:image_length
        refined_normal(i,j,:) = vertices(labeling((j-1)*image_width+i),:);
    end
end

end