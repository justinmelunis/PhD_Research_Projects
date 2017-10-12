function [poly] = Reg2Poly(R,channel,frame,color)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin<2
    channel=0;
end
if nargin<3
    frame=1;
end
C=channel*1000;
if nargin<4
    if channel==1
        color=[0 1 1];
    elseif channel==2
        color=[1 0 0];
    elseif channel==3
        color=[1 1 0];
    elseif channel==4
        color=[0 1 0];
    elseif channel==5
        color=[1 0 1];
    elseif channel==6
        color=[0 0 1];
    else
        color=[1,1,1];
    end
end
if nargin<5
    reductions=[];
for i=1:length(R)
    [ polygon ] = D3d.Polygon.Make(R(i).PixelList, C+n,'', frame, color, reductions);
    if numel(polygon.verts)>1
        poly(n)=polygon;
        n=n+1;
    end
end

