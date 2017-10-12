FramesW=[];
for i=1:100
    tic
    [im,imData] = MicroscopeData.Reader('\\bioimagefs.coe.drexel.edu\Process\Images\JLS\Light Sheet\coverslip_1\cell7_timelapse\cell7.json',[i]);
    toc 
    tic
    [FramesW] = findFrameColocalization3d(FramesW,im);
    toc
    disp(i)
end
 [SetW] = findFrameSets(FramesW);