function [R2] = ForceCluster(R,k)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
D=zeros(numel(R.PixelIdxList),numel(R.PixelIdxList));
for i=1:numel(R.PixelIdxList)
    for j=1:numel(R.PixelIdxList)
        D(i,j)=sqrt((R.PixelList(i,1)-R.PixelList(j,1))^2+(R.PixelList(i,2)-R.PixelList(j,2))^2+(R.PixelList(i,3)-R.PixelList(j,3))^2);
    end
end

idx= SpectralCluster(D,k);
find(idx==1)
for i=1:max(idx)
    R2(i).PixelIdxList=R.PixelIdxList(idx==i);
    R2(i).PixelList=R.PixelList(idx==i,:);
end



