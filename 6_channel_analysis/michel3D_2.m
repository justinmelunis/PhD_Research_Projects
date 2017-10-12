function [SharpImg,Edge] = michel3D_2(img,sigma,size,type)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if nargin<2
    sigma = [3 3 1];  % or whatever
end
if nargin<3
    size = [75 75 25];  % or whatever
end
if nargin<4 || isempty(type)
    type = 'symmetric';  % or whatever
end

BlurImg = imgaussfilt3(img,sigma,'FilterSize',size,'padding',type);
SharpImg=max(0,img-BlurImg);
Edge=abs(img-BlurImg);
end

