%set the frame of Poly1 and Poly2 to be 1
% [Hulls, list,color1,color2]=goSeg3D(Frame,RP,100);
% Poly1=Poly;
% Poly1(list==1)=[];
% Poly2=Poly1;
% framer=[];
% for i=1:length(Poly1)
%     Poly1(i).label=num2str(Hulls(i).ID);
%     Poly2(i).label=num2str(Hulls(i).ID);
%     Poly1(i).color=color1(i,:);
%     Poly2(i).color=color2(i,:);
%     framer(i)=Poly1(i).frame;
%     Poly1(i).frame=1;
%     Poly2(i).frame=1;
% end

for i=1:100
    i
    t=framer==i;
    D3d.Viewer('LoadPolygons',Poly1(t))
    a=D3d.Viewer('CaptureImage');
    D3d.Viewer('DeleteAllPolygons')
    D3d.Viewer('LoadPolygons',Poly2(t))
    a=D3d.Viewer('CaptureImage');
    D3d.Viewer('DeleteAllPolygons')
end
    
    