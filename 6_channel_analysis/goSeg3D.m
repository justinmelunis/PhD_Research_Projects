%
function [Hulls, list,color1,color2]=goSeg3D(Frame,RP,nframes)
% this is for assignment optimal
 set(0,'RecursionLimit',2048);
 ALPHA=0.7;
 MF=5;
 %clear Hulls
Hulls=[];
list=[];
% %set regionprops to go with assignments
% for i=1:length(RP)
%     RP(i).num=i;
%     RP(i).color=[0,1,1]; %set to cyan
%     RP(i).label='';
% end
%Set Hulls
color1=[];
tic
for t=1:nframes
    i=Frame==t;
    num=length(i(i==1));
    R=RP(i);

    for n=1:num
        
        if R(n).Area<3
            R(n).color=[0,0,0];
            list=[list 1];
            continue
        end
        list=[list 0];
        color1(end+1,:)=[0 1 1];
        nh=[];     
        x=R(n).PixelList(:,1); y=R(n).PixelList(:,2); z=R(n).PixelList(:,3); 
        nh.t=t;
        nh.xyzCenter=[mean(x),mean(y),mean(z)];
%         %         plot(nh.xyCenter(1),nh.xyCenter(2),'r*')
        nh.area=R(n).Area;
        nh.xyzPoints=[x,y,z];
        %Added this, PixelIdxList
        nh.PixelIdxList=R(n).PixelIdxList;
        Hulls=[Hulls;nh]; 
    end
%     
%     %     drawnow
end
color2=color1;
toc

DXYZ_MAX=20;
path(path,'assign')
% 
tmax=max([Hulls.t]);
for i=1:length(Hulls)
    Hulls(i).ID=i;
end

for t=1:min(tmax,nframes)-1
    tic
    t
    Merg1=[]; %red
    Merg2=[]; %white
    Mergd=[]; %magenta
    Splt=[]; %green
    Splt1=[]; %yellow
    Splt2=[]; %darker (but still light enough to see) blue
    th=find([Hulls.t]==t);
    th1=find([Hulls.t]==t+1);
    AddV=[];
    DelV=[];
    
    if isempty(th) || isempty(th1)
        continue
    end
    
    d=[];
    %maybe assign other options here
    for i=1:length(th)
        
        for j=1:length(th1)
            d(i,j)=Inf;
            xyz=Hulls(th(i)).xyzCenter;
            xyz1=Hulls(th1(j)).xyzCenter;
            dxyz=norm([xyz-xyz1]);
            %Maximal Distance
            if dxyz>DXYZ_MAX
                continue
            end
            %adding pixel intersection infromation
            Inter=numel(intersect(Hulls(th(i)).PixelIdxList,Hulls(th1(j)).PixelIdxList));
            if Inter>0
                %if they have any intersecting pixels, their distance is based
                %off pixel intersection where D is 1 minus intersection of
                %pixels divided by union of pixels
                D=1-Inter/(numel(Hulls(th(i)).PixelIdxList)+numel(Hulls(th1(j)).PixelIdxList)-Inter);
                d(i,j)=D;
            else
                %if no intersecting pixels, we look at distnace as the distnace
                %between plus a factor due to area differences and let the old
                %guy win
                area=Hulls(th(i)).area;
                area1=Hulls(th1(j)).area;
                darea=(max(area,area1)-min(area,area1))/max(area,area1);
                lifetime=length(find([Hulls.ID]==Hulls(th(i)).ID));
                d(i,j)=dxyz ;%+ 2*darea;
                d(i,j)=d(i,j)*(t/(lifetime))^2;
             end
        end
    end
    %Assign each object in frame t to its closest object in t+1
    AssignTh=[];
    AssignTh1=[];
    for i=1:length(th)
        AssignTh(i).N=[];
    end
    for i=1:length(th1)
        AssignTh1(i).N=[];
    end
    %Assign each object in frame t to its closest object in t+1
    for i=1:length(th)
        D=d(i,:);
        [b, a]=min(D);
        if b<inf
            AssignTh1(a).N=[AssignTh1(a).N i];
        else
            DelV=[DelV i];
        end
    end
    
    %Assign each object in frame t+1 to its closest object in t-1
    for i=1:length(th1)
        D=d(:,i);
        [b, a]=min(D);
        if b<inf
            AssignTh(a).N=[AssignTh(a).N i];
        else
            AddV=[AddV i];
        end
    end
    
    Assign1to1=zeros(1,length(th1));
    AV=zeros(1,length(th));
    AV1=zeros(1,length(th1));
    Assr=zeros(1,length(th));
    Assr1=zeros(1,length(th1));
    
    for i = 1 : length(th1)
        %Set if a 1 to 1 relationship
        if length(AssignTh1(i).N)==1 && length(AssignTh(AssignTh1(i).N).N)==1 && AssignTh(AssignTh1(i).N).N==i
            %Add qualifying features
            area=Hulls(th1(i)).area; 
            area1=Hulls(th(AssignTh1(i).N)).area;
            darea=(max(area,area1)-min(area,area1))/max(area,area1);
            if darea<0.2;
                Assign1to1(i)=1;
                AV(AssignTh1(i).N)=1;
                Assr(AssignTh1(i).N)=AssignTh(AssignTh1(i).N).N;
                AV1(i)=1;
                Assr1(i)=AssignTh1(i).N;
            end
        end
    end
            
    %If all assignments are 1 to 1, accept as true tracks, skip rest of
    %code, move to next frame
%     if ~any(~Assign1to1)
%         %set tracks
%         continue
%     end
    
    for i=1:length(th)
        
        %If 2 in frame t+1 are assigned to a single object in t, look for
        %Split
        if length(AssignTh(i).N)==2 && length([AssignTh1(AssignTh(i).N(1)).N AssignTh1(AssignTh(i).N(2)).N])==1 && [AssignTh1(AssignTh(i).N(1)).N AssignTh1(AssignTh(i).N(2)).N]==i
            %look for split, add conditions here
            if abs(Hulls(th(i)).area - Hulls(th1(AssignTh(i).N(1))).area - Hulls(th1(AssignTh(i).N(2))).area) < abs(Hulls(th(i)).area - max(Hulls(th1(AssignTh(i).N(1))).area,Hulls(th1(AssignTh(i).N(2))).area))
                Splt=[Splt i]; %magenta
                %choose which track to keep (who released who)
                if Hulls(th1(AssignTh(i).N(1))).area > Hulls(th1(AssignTh(i).N(2))).area
                    %set assignment
                    Splt1=[Splt1 AssignTh(i).N(2)]; 
                    Splt2=[Splt2 AssignTh(i).N(1)]; 
                    %adad
                elseif Hulls(th1(AssignTh(i).N(1))).area < Hulls(th1(AssignTh(i).N(2))).area %% || if this is closer in distnace
                    Splt1=[Splt1 AssignTh(i).N(1)]; %th1 index
                    Splt2=[Splt2 AssignTh(i).N(2)]; 
                else
                    Splt1=[Splt1 AssignTh(i).N(2)]; 
                    Splt2=[Splt2 AssignTh(i).N(1)]; 
                end
            end
            
        %if over a 2 to 1 relationship, cant know how to handle
%         elseif length(AssignT1(i).N)>2;
%             Over2=[Over2 R(i).num];
%         elseif isempty(AssignT1(i).N);
%             PotAdd=[PotAdd R(i).num];
        end
    end
            
    for i=1:length(th1)
        
        %If 2 in frame t are assigned to a single object in t+1, look for
        %merger
        if length(AssignTh1(i).N)==2 && length([AssignTh(AssignTh1(i).N(1)).N AssignTh(AssignTh1(i).N(2)).N])==1 && [AssignTh(AssignTh1(i).N(1)).N AssignTh(AssignTh1(i).N(2)).N]==i
            %look for merger, add conditions here
            if abs(Hulls(th1(i)).area - Hulls(th(AssignTh1(i).N(1))).area - Hulls(th(AssignTh1(i).N(2))).area) < abs(Hulls(th1(i)).area - max(Hulls(th(AssignTh1(i).N(1))).area,Hulls(th(AssignTh1(i).N(2))).area))
                Mergd=[Mergd i]; %magenta
                %choose which track to keep (who eats who)
                if Hulls(th(AssignTh1(i).N(1))).area > Hulls(th(AssignTh1(i).N(2))).area
                    %set assignment
                    Merg1=[Merg1 AssignTh1(i).N(2)]; %red
                    Merg2=[Merg2 AssignTh1(i).N(1)]; %white
                    %adad
                elseif Hulls(th(AssignTh1(i).N(1))).area < Hulls(th(AssignTh1(i).N(2))).area %% || if this is closer in distnace
                    Merg1=[Merg1 AssignTh1(i).N(1)]; %red
                    Merg2=[Merg2 AssignTh1(i).N(2)]; %white
                else
                    Merg1=[Merg1 AssignTh1(i).N(2)]; %red
                    Merg2=[Merg2 AssignTh1(i).N(1)]; %white
                end
            end
            
        %if over a 2 to 1 relationship, cant know how to handle
%         elseif length(AssignT(i).N)>2;
%             Over2=[Over2 R(i).num];
%         elseif isempty(AssignT(i).N);
%             PotAdd=[PotAdd R(i).num];
         end
    end  
    %find the link between the remainders with optimal assignment
    for i=1:length(Splt)
        AV(Splt(i))=1;
        AV1(Splt1(i))=1;
        AV1(Splt2(i))=1;
        Assr(Splt(i))=Splt2(i);
        Assr1(Splt2(i))=Splt(i);
        AddV=[AddV Splt1(i)];
    end
    
    for i=1:length(Mergd)
        AV1(Mergd(i))=1;
        AV(Merg1(i))=1;
        AV(Merg2(i))=1;
        Assr(Merg2(i))=Mergd(i);
        Assr1(Mergd(i))=Merg2(i);
        DelV=[DelV Merg1(i)];
    end
    
    BV=~AV; CV=find(BV);
    BV1=~AV1; CV1=find(BV1);
    dd=d(BV,BV1);
    %build a matrix with links between each blob and the possability that
    %each blob does not contain a link to the other frame
    D=zeros(length(CV)+length(CV1),length(CV)+length(CV1));
    for i=1:length(CV)
        for j=1:length(CV1)
            D(i,j)=dd(i,j);
        end
        for j=length(CV1)+1:length(CV)+length(CV1)
            D(i,j)=1000;
        end
    end
    for i=length(CV)+1:length(CV)+length(CV1)
        for j=1:length(CV1)
            D(i,j)=1000;
        end
    end
    %Use optimal assignment
   [ass cost]=assignmentoptimal(D);   
   for i=1:length(CV)
       if ass(i)<=length(CV1)
        Assr(CV(i))=CV1(ass(i));
        AV1(CV1(ass(i)))=1;
       else
        DelV=[DelV CV(i)];  
       end
   end
   AddV=[AddV find(~AV1)];
   %set if any new objects are in DelV and AddV. Will take out the blob
   %with the least cost if there in unequal amount of th to th1 blobs which
   %can be connected with a distnace less than inf
   
   %%Assign IDs, set colors for visualizing
    %Assign the 1to1 and the mergers/splits
    %Add New assignments (set colors for new IDs and old IDs)
%     for i=1:length(Assign1to1)
%         if Assign1to1(i)==1
%             RP(Hulls(th1(i)).num).label=RP(Hulls(th(AssignV(i))).num).label;
%         end
%     end     
    
    
%     [ass cost]=assignmentoptimal(d);
    for i=1:length(Assr)
        if 0==Assr(i)
            continue
        end
        Hulls(th1(Assr(i))).ID=Hulls(th(i)).ID;
    end
    %set colors
    for i=1:length(DelV)
        color2(th(DelV(i)),:)=[1 0 0];
    end
    for i=1:length(Mergd)
        color2(th(Merg2(i)),:)=[1 1 1];
        color1(th1(Mergd(i)),:)=[1 0 1];
    end
    for i=1:length(AddV)
        color1(th1(AddV(i)),:)=[1 1 0];
    end
    for i=1:length(Splt)
        color1(th1(Splt2(i)),:)=[0.4 0.4 1];
        color2(th(Splt(i)),:)=[0 1 0];
    end
    toc
end
% 
% 
%renumber
id = unique([Hulls.ID]);
for i = 1 : length(Hulls)
    idi = find(id == Hulls(i).ID);
    Hulls(i).ID = idi;
end
% save and be donefunction [ output_args ] = Untitled( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


end

