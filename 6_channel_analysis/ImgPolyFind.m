function [poly] = ImgPolyFind(img,channel,frame,reductions)
%set values if input was not given
    if nargin<2
        channel=0;
    end
    if nargin<3
        frame=1;
    end
    if nargin<4
        reductions=[];
    end
    %make image a gray image
    img=mat2gray(img);
    %contrast filter
    img=michel3D(img);
%     SE=strel(ones(2,2,2));
%     img=imopen(img,SE);
    %threshold pixels >0 using Otsu's
    level=graythresh(img(img>0));
    IMG=zeros(size(img));
    IMG(img>level)=1;
    %find connected components
    CC=bwconncomp(IMG);
    R=regionprops(CC,'PixelList','Centroid','PixelIdxList');
    %Set color, label, and polygon number
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
    n=1;
    C=1000*channel;
    [poly] = Reg2Poly(R,channel,frame,color,reductions);
end

