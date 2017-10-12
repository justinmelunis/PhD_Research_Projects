function [G] = Sobel3d(img)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
G=zeros(size(img));
for x=2:size(img,1)-1
    for y=2:size(img,2)-1
        for z=2:size(img,3)-1
            Gx=(4*img(x-1,y,z)+2*img(x-1,y-1,z)+2*img(x-1,y+1,z)+2*img(x-1,y,z-1)+2*img(x-1,y,z+1)+img(x-1,y-1,z-1)+img(x-1,y-1,z+1)+img(x-1,y+1,z-1)+img(x-1,y+1,z+1))...
              -(4*img(x+1,y,z)+2*img(x+1,y-1,z)+2*img(x+1,y+1,z)+2*img(x+1,y,z-1)+2*img(x+1,y,z+1)+img(x+1,y-1,z-1)+img(x+1,y-1,z+1)+img(x+1,y+1,z-1)+img(x+1,y+1,z+1));
            Gy=(4*img(x,y-1,z)+2*img(x-1,y-1,z)+2*img(x+1,y-1,z)+2*img(x,y-1,z-1)+2*img(x,y-1,z+1)+img(x-1,y-1,z-1)+img(x-1,y-1,z+1)+img(x+1,y-1,z-1)+img(x+1,y-1,z+1))...
              -(4*img(x,y+1,z)+2*img(x-1,y+1,z)+2*img(x+1,y+1,z)+2*img(x,y+1,z-1)+2*img(x,y+1,z+1)+img(x-1,y+1,z-1)+img(x-1,y+1,z+1)+img(x+1,y+1,z-1)+img(x+1,y+1,z+1));
            Gz=(4*img(x,y,z-1)+2*img(x-1,y,z-1)+2*img(x+1,y,z-1)+2*img(x,y-1,z-1)+2*img(x,y+1,z-1)+img(x-1,y-1,z-1)+img(x-1,y+1,z-1)+img(x+1,y-1,z-1)+img(x+1,y+1,z-1))...
              -(4*img(x,y,z+1)+2*img(x-1,y,z+1)+2*img(x+1,y,z+1)+2*img(x,y-1,z+1)+2*img(x,y+1,z+1)+img(x-1,y-1,z+1)+img(x-1,y+1,z+1)+img(x+1,y-1,z+1)+img(x+1,y+1,z+1));
            G(x,y,z)=sqrt(Gx^2+Gy^2+Gz^2);
        end
    end
end

