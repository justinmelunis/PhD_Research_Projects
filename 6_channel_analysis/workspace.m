%%if chosen, do this
num=61;
AA=A(:,:,:,1,1);

img=mat2gray(AA);
%contrast filter
tic
[img]=michel3D(img);
toc
tic
%threshold pixels >0 using Otsu's
level=graythresh(img(img>0));
IMG=zeros(size(img));
IMG(img>level)=1;
%find connected components
CC=bwconncomp(IMG);
R=regionprops(CC,'PixelList','Centroid','PixelIdxList');
W=zeros(size(img));
toc
tic
[GG] = Sobel3d(mat2gray(AA));
toc
G=[];
for i=1:length(R(num).PixelIdxList)
    G=[G GG(R(num).PixelList(i,1),R(num).PixelList(i,2),R(num).PixelList(i,3))];
end
Gmax=max(G);
Gmin=min(G);
for i=1:length(R(num).PixelIdxList)
    W(R(num).PixelList(i,1),R(num).PixelList(i,2),R(num).PixelList(i,3))=exp(1-((GG(R(num).PixelList(i,1),R(num).PixelList(i,2),R(num).PixelList(i,3))-Gmin)/(Gmax-Gmin)));
end    
 tic   
[D] = GeodesicWeightedPathDistance(R(num),W,IMG);
toc



% 
% 
% 
% AA=mat2gray(AA);
% SE=strel(ones(2,2,2));
% BB=imerode(AA,SE);
% CC=imdilate(AA,SE);
% DD=CC-BB;
% EE=michel3D(DD);
% level=graythresh(EE(EE>0));
% FF=zeros(size(EE));
% FF(EE>level)=1;
% FR=FF;
% IB=imerode(IMG,SE);
% IC=imdilate(IMG,SE);
% ID=IC-IB;
% FF(ID==1)=0;
% R3=[];
% R6=[];
% for i=1:numel(R)
%     GG=zeros(size(EE));
%     RR=zeros(size(EE));
%     RR(R(i).PixelIdxList)=1;
%     GG(RR & FF)=1;
%     RR(GG==1)=0;
%     se=strel(ones(2,2,2));
%     RR=imopen(RR,se);
%     CC2=bwconncomp(RR);
%     R2=regionprops(CC2,'PixelList','Centroid','PixelIdxList','Area');
%     N=length(R2);
%     if N>1;
%         [RR3] = AssignRegion(R2,R,i);
%     else
%         [RR3] =R(i);
%     end
%     ap=1;
%     if isempty(R3)
%         R3=RR3(1);  
%         ap=2;
%     end
%     for z=ap:N
%         R3(end+1).PixelList=RR3(z).PixelList;
%         R3(end).PixelIdxList=RR3(z).PixelIdxList;
%     end
% end
% R6=R3(1);
% for i=1:numel(R3)
%     D=[];
%     for k=1:numel(R3(i).PixelIdxList)
%         for j=1:numel(R3(i).PixelIdxList)
%             D(k,j)=sqrt((R3(i).PixelList(k,1)-R3(i).PixelList(j,1))^2+(R3(i).PixelList(k,2)-R3(i).PixelList(j,2))^2+(R3(i).PixelList(k,3)-R3(i).PixelList(j,3))^2);
%         end
%     end
%     [kGap Gap S idx] = GapSpectral(D,10);
%     R5=[];
%     for j=1:max(idx)
%         R5(j).PixelIdxList=R3(i).PixelIdxList(idx==j);
%         R5(j).PixelList=R3(i).PixelList(idx==j,:);
%         R6(end+1).Centroid=[];
%         R6(end).PixelList=R5(j).PixelList;
%         R6(end).PixelIdxList=R5(j).PixelIdxList;
%     end 
% end
% R6(1)=[];
% % for i=1:length(R6)
% % 
[ polygon ] = D3d.Polygon.Make(R6(i).PixelList, i,'', 1, [0 1 0], []);

% % poly(i)=polygon;
% % end
