function [R3] = AssignRegion(R2,R,num)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
list=R(num).PixelIdxList;
DD=[];
idx=[];
for i=1:numel(list)
    for j=1:length(R2)
        D(j).D=[];
        for k=1:length(R2(j).PixelIdxList)
            D(j).D(k)=sqrt( (R(num).PixelList(i,1)-R2(j).PixelList(k,1))^2 + (R(num).PixelList(i,2)-R2(j).PixelList(k,2))^2 + (R(num).PixelList(i,3)-R2(j).PixelList(k,3))^2); 
        end
        DD(i).D(j)=min(D(j).D);
    end
    DD(i).idx=find(DD(i).D==min(DD(i).D));
    if numel(DD(i).idx)==1
        idx=[idx DD(i).idx];
    elseif numel(DD(i).idx)==1
        continue
    else
        a=[];
        for z=1:numel(DD(i).idx)
            a=[a numel(R2(DD(i).idx(z)).PixelIdxList)];
        end
        [~,Z]=max(a);
         idx=[idx DD(i).idx(Z(1))];
    end    
end
RR=max(idx);
for i=1:RR
    R3(RR).PixelIdxList=[];
    R3(RR).PixelList=[];
end
for i=1:numel(list)
    R3(idx(i)).PixelIdxList(end+1)=list(i);
    R3(idx(i)).PixelList(length(R3(idx(i)).PixelIdxList),:)=R(num).PixelList(i,:);
end


