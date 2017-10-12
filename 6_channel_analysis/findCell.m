function [bwMask,ch,r,c] = findCell(fname)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
info=imfinfo(fname);
TMAX=length(info);                                                                                                                                  
imtot6=imread(fname,'index',1);
bwtot=zeros(size(imtot6,1),size(imtot6,2));
for t=1:2:TMAX
    im6=imread(fname,'index',t);
    for i=4:6
        im=im6(:,:,i);
        level=graythresh(im);
        bw=im2bw(im,level);
        bwtot=bwtot+bw;
    end
end

rp=regionprops(bwtot,'area','PixelIdxList');
for i=1:length(rp)
    if rp(i).Area<10 && rp(i).Area~=0;
        bwtot(rp(i).PixelIdxList)=0;
        rp(i).PixelIdxList=[];
    end
end
bwtot2=bwmorph(bwtot,'dilate',5);
rp=regionprops(bwtot2,'area','PixelIdxList');
[mm, id]=max([rp.Area]);
bw=0*bwtot;
BW=0*bwtot;
bw(rp(id).PixelIdxList)=1;
% figure(1)
% imshow(bw);
BW(bw & bwtot)=1;
% figure(2)
% imshow(BW)
[r, c]=find(BW);
ch=convhull(c,r);
hold on
% plot(c(ch),r(ch))
CH = bwconvhull(BW);
% figure(3)
% imshow(CH)
bwMask=CH;

end

