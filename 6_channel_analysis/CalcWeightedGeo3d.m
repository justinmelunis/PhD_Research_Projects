function [WeightedGeo] = CalcWeightedGeo3d(Mask,W,Geo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
UnFound=Mask;
WeightedGeo=zeros(size(Mask));
[X,Y,Z] = ind2sub(size(Mask),find(Geo==1)) ;
for j=1:length(X)
    WeightedGeo(X(j),Y(j),Z(j))=W(X(j),Y(j),Z(j));
    UnFound(X(j),Y(j),Z(j))=0;
end
for i=2:max(Geo(:))
    [X,Y,Z] = ind2sub(size(Mask),find(Geo==i)) ;
    for j=1:length(X)
        Xa=X(j)-1; Ya=Y(j)-1; Za=Z(j)-1;
        Xb=X(j)+1; Yb=Y(j)+1; Zb=Z(j)+1;
        if X(j)==1; Xa=X(j); end
        if Y(j)==1; Ya=Y(j); end
        if Z(j)==1; Za=Z(j); end
        if X(j)==size(Mask,1); Xb=X(j); end
        if Y(j)==size(Mask,2); Yb=Y(j); end
        if Z(j)==size(Mask,3); Zb=Z(j); end
        path=[];
        for x=Xa:Xb
            for y=Ya:Yb
                for z=Za:Zb
                    if Geo(x,y,z)==i-1
                        path=[path WeightedGeo(x,y,z)];
                    end
                end
            end
        end
        WeightedGeo(X(j),Y(j),Z(j))=min(path)+W(X(j),Y(j),Z(j));
        UnFound(X(j),Y(j),Z(j))=0;
    end
    for j=1:length(X)
        Xa=X(j)-1; Ya=Y(j)-1; Za=Z(j)-1;
        Xb=X(j)+1; Yb=Y(j)+1; Zb=Z(j)+1;
        if X(j)==1; Xa=X(j); end
        if Y(j)==1; Ya=Y(j); end
        if Z(j)==1; Za=Z(j); end
        if X(j)==size(Mask,1); Xb=X(j); end
        if Y(j)==size(Mask,2); Yb=Y(j); end
        if Z(j)==size(Mask,3); Zb=Z(j); end
        for x=Xa:Xb
            for y=Ya:Yb
                for z=Za:Zb
                    if UnFound(x,y,z)==0 && Mask(x,y,z)==1
                        if WeightedGeo(X(j),Y(j),Z(j))+W(x,y,z) < WeightedGeo(x,y,z)
                            WeightedGeo(x,y,z)=WeightedGeo(X(j),Y(j),Z(j))+W(x,y,z);
                            [WeightedGeo] = WeightedSurroundUpdate(WeightedGeo,W,Mask,UnFound,x,y,z);
                        end
                    end
                end
            end
        end
    end
end

