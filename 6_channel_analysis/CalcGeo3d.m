function [ Geo ] = CalcGeo3d(Mask,R,idx)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Geo=zeros(size(Mask));
UnFound=zeros(size(Mask));
for i=1:length(R.PixelIdxList)
UnFound(R.PixelList(i,1),R.PixelList(i,2),R.PixelList(i,3))=1;
end
UnFound(R.PixelList(idx,1),R.PixelList(idx,2),R.PixelList(idx,3))=0;
if any(UnFound(:))
    for x=R.PixelList(idx,1)-1:1:R.PixelList(idx,1)+1
        for y=R.PixelList(idx,2)-1:1:R.PixelList(idx,2)+1
            for z=R.PixelList(idx,3)-1:1:R.PixelList(idx,3)+1
                if x==0 || y==0 || z==0 || x==size(Mask,1) || y==size(Mask,2) || z==size(Mask,3)
                    continue
                end
                if UnFound(x,y,z)==1
                    Geo(x,y,z)=1;
                    UnFound(x,y,z)=0;
                end
            end
        end
    end
end
Num=1;
        
while any(UnFound(:))
    [X,Y,Z] = ind2sub(size(Mask),find(Geo==Num)) ;
    for i=1:numel(X)
        for x=X(i)-1:X(i)+1
            for y=Y(i)-1:Y(i)+1
                for z=Z(i)-1:Z(i)+1
                    if x==0 || y==0 || z==0 || x>size(Mask,1) || y>size(Mask,2) || z>size(Mask,3)
                        continue
                    end
                    if UnFound(x,y,z)==1
                        Geo(x,y,z)=Num+1;
                        UnFound(x,y,z)=0;
                    end
                end
            end
        end
    end
    Num=Num+1;
end
end

