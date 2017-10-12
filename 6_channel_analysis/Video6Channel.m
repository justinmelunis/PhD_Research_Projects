function Video6Channel(title)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



v = VideoWriter(title,'MPEG-4');
v.Quality=100;
open(v)
for i=1:6:5040
    A='_00000.bmp';
    if i<10
    A(6)=num2str(i);
    elseif i>=10 &&i<100
    A(5:6)=num2str(i);
    elseif i>=100 &&i<1000
    A(4:6)=num2str(i);
    elseif i>1000
    A(3:6)=num2str(i);
    end
    B=imread(A);
    if i<=720
        NAME='Peroxisomes';
    elseif i<=1440
        NAME='Mitchondria';
    elseif i<=2160
        NAME='ER';
    elseif i<=2880
        NAME='Golgi';
    elseif i<=3600
        NAME='Lysosomes';
    elseif i<=4320
        NAME='Lipids';
    else
        NAME='Combined';
    end
    RGB = insertText(B,[650 640],NAME,'BoxColor','black','AnchorPoint','center','FontSize',22,'TextColor','white');
    writeVideo(v,RGB)
end
    close(v)

end

