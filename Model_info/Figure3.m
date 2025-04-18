clear;clc
figure(2);set(gcf,'position',[5 5 1500 1500])
clf;set(gcf,'color','w');

F5 = axes('position',[0.277 0.54 0.55 0.42]);
cd ../Density
run Topography_CV.m

clear;clc
% F6 = axes('position',[0.560 0.035 0.35 0.42]);
cd ../Model_info
run iniTSinfor_summer_log.m


img=getframe(gcf);
imwrite(img.cdata,'Figure3.tiff', 'tiff', 'Resolution', 600)
