function [WeightedGeo] = WeightedSurroundUpdate(WeightedGeo,W,Mask,UnFound,X,Y,Z)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Xa=X-1; Ya=Y-1; Za=Z-1;
Xb=X+1; Yb=Y+1; Zb=Z+1;
if X==1; Xa=X; end
if Y==1; Ya=Y; end
if Z==1; Za=Z; end
if X==size(Mask,1); Xb=X; end
if Y==size(Mask,2); Yb=Y; end
if Z==size(Mask,3); Zb=Z; end
for x=Xa:Xb
    for y=Ya:Yb
        for z=Za:Zb
           if UnFound(x,y,z)==0 && Mask(x,y,z)==1
              if WeightedGeo(X,Y,Z)+W(x,y,z) < WeightedGeo(x,y,z)
                WeightedGeo(x,y,z)=WeightedGeo(X,Y,Z)+W(x,y,z);
                [WeightedGeo] = WeightedSurroundUpdate(WeightedGeo,W,Mask,UnFound,x,y,z);
              end
           end
        end
    end
end

