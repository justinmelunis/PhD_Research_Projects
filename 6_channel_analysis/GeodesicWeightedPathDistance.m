function [D] = GeodesicWeightedPathDistance(R,W,BW)
%UNTITLED Summary of this function goes here
%   R=Region of interest
%   W=Weight of point. Could be a Sobel Filter
Mask=zeros(size(BW));
for i=1:length(R.PixelIdxList)
Mask(R.PixelList(i,1),R.PixelList(i,2),R.PixelList(i,3))=1;
end
D=zeros(length(R.PixelIdxList),length(R.PixelIdxList));
for i=1:length(R.PixelIdxList)
    Geo=CalcGeo3d(Mask,R,i);
    WeightedGeo=CalcWeightedGeo3d(Mask,W,Geo);
%     WeightedGeo(Mask)=WeightedGeo(Mask)+W(R.PixelIdxList(i));
    for j=i+1:length(R.PixelIdxList)
        D(i,j)=WeightedGeo(R.PixelList(j,1),R.PixelList(j,2),R.PixelList(j,3))+W(R.PixelList(i,1),R.PixelList(i,2),R.PixelList(i,3));
        D(j,i)=D(i,j);
    end
end

