function [recsurf] = shapeFromNormal(normal,scale,I)
%function [recsurf] = shapeFromNormal(normal,scale)
[img_width,img_length,~] = size(normal);
slant = zeros(img_width,img_length);
tilt = zeros(img_width,img_length);

for i = 1:img_width
    for j = 1:img_length
        T = squeeze(normal(img_width+1-i,j,:));
        x = T(1);
        y = T(2);
        z = T(3);
%         slant(i,j) = acos(z);
%         if y>=0
%             tilt(i,j) = acos(x);
%         elseif y<0
%             tilt(i,j) = -acos(x);
%         end
        dzdx = -x / z; dzdy = -y / z;
        [slant(i,j), tilt(i,j)] = grad2slanttilt(dzdx,dzdy);
    end
end

recsurf = shapeletsurf(slant,tilt,8,1,2,'slanttilt');
recsurf = recsurf/scale;
[x,y] = meshgrid(1:img_length, 1:img_width);

figure;
%surf(x,y,recsurf,'FaceColor','cyan','EdgeColor','none');
surf(x,y,recsurf,'FaceColor','blue','EdgeColor','none');
camlight left;
lighting phong;
axis equal;
axis vis3d;
axis off;

end