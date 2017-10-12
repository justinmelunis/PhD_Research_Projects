function [Frames] = findFrameColocalization3d(Frames,im)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
T=numel(Frames)+1;
Frames(T).missing=0;
for j=1:6
 ima=im(:,:,:,j);
 ima=mat2gray(ima);
 %if you want to segment im any better or differently, etc
 ima=michel3D(ima);
 thresh=graythresh(ima(ima>0));
 IMG(j).img=zeros(size(ima));
 IMG(j).img(ima>thresh)=1;
 %if you wish to dilate
 se=strel(ones(2,2,2));
 IMG(j).img = imdilate(IMG(j).img,se);
end
for j=1:6
     A=find(IMG(j).img);
     a=numel(A);
     for k=1:6
         B=find(IMG(k).img);
         b=numel(B);
            if a>0 && b>0
                Inter=numel(intersect(A,B));
                Frames(T).D(j,k)=Inter/min(a,b);
            else 
                Frames(T).D(j,k)=0;
                Frames(T).missing=1;
            end
     end
end

end

