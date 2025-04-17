%Fig3b
clear;clc;close all
load('CVTM_CV_summer.mat')
figure(4);clf;set(gcf,'color','w');set(gcf,'position',[1280 160 870 800])
subplot(131)
plot(pt_summer,Depth,'r-','linewidth',1.5);hold on;
set(gca,'fontsize',24,'LineWidth',1.5,'fontname','Arial','Ydir','reverse');
set(gca,'XAxisLocation','top');
set(gca,'YScale','log');
grid on;
axis([0 30 1E+0 6.0E+3]);
title('Potential Temperature(°C)','fontsize',24,'fontname','Arial');
ylabel('Depth(m)','fontsize',24,'fontname','Arial')
% set(gcf, 'PaperPosition', [-12.0778    2.5028   45.1556   24.6944])
% img=getframe(gcf);
% imwrite(img.cdata,'温度.tiff', 'tiff', 'Resolution', 600)

figure(4);
subplot(132)
plot(Sal_summer,Depth,'r-','linewidth',1.5);hold on;
set(gca,'fontsize',24,'LineWidth',1.5,'fontname','Arial','Ydir','reverse');
set(gca,'XAxisLocation','top');
set(gca,'YScale','log');
grid on;
% set(h,'fontname','Arial','fontsize',15)
title('Salinity','fontsize',24,'fontname','Arial');
axis([34.8 36.5 1E+0 6.0E+3])



figure(4);
subplot(133)
plot(N2_summer,Depth,'r-','linewidth',1.5);hold on;
set(gca,'fontsize',24,'LineWidth',1.5,'fontname','Arial','Ydir','reverse');
set(gca,'XAxisLocation','top');grid on;
set(gca,'YScale','log');
set(gca,'XScale','log');
% set(h,'fontname','Arial','fontsize',15)
title('N^2 (s^-^2)','fontsize',24,'fontname','Arial','FontAngle','italic');
axis([0 6e-04 1E+0 6.0E+3])



%%
clear
load('CVTM_CV_winter.mat');
subplot(131)
plot(pt_winter,Depth,'b-','linewidth',1.5);hold on;
set(gca,'fontsize',24,'LineWidth',1.5,'fontname','Arial','Ydir','reverse');
set(gca,'XAxisLocation','top');
set(gca,'YScale','log');
grid on;
axis([0 30 1E+0 6.0E+3]);
title('Potential Temperature (°C)','fontsize',24,'fontname','Arial');
ylabel('Depth (m)','fontsize',24,'fontname','Arial')
% set(gcf, 'PaperPosition', [-12.0778    2.5028   45.1556   24.6944])
% img=getframe(gcf);
% imwrite(img.cdata,'温度.tiff', 'tiff', 'Resolution', 600)

figure(4);
subplot(132)
plot(Sal_winter,Depth,'b-','linewidth',1.5);hold on;
set(gca,'fontsize',24,'LineWidth',1.5,'fontname','Arial','Ydir','reverse');
set(gca,'XAxisLocation','top');
set(gca,'YScale','log');
grid on;
% set(h,'fontname','Arial','fontsize',15)
title('Salinity','fontsize',24,'fontname','Arial');
axis([34.8 36.5 1E+0 6.0E+3])



figure(4);
subplot(133)
plot(N2_winter,Depth,'b-','linewidth',1.5);hold on;
set(gca,'fontsize',24,'LineWidth',1.5,'fontname','Arial','Ydir','reverse');
set(gca,'XAxisLocation','top');grid on;
set(gca,'YScale','log');
% set(h,'fontname','Arial','fontsize',15)
title('N^2 (s^-^2)','fontsize',24,'fontname','Arial');
% title('Brunt-Vaisala Frequency squared(s^-2)','fontsize',15,'fontname','Arial');
axis([0 6e-04 1E+0 6.0E+3]);
h = legend('Summer (ASO)','Winter (FMA)');
set(h,'NumColumns',1,'Location','northeast','LineWidth',2,...
    'FontSize',18,'fontname','Arial');


set(gcf, 'PaperPosition', [-12.0778    2.5028   45.1556   24.6944])
img=getframe(gcf);
imwrite(img.cdata,['Fig3b.tiff','.tiff'], 'tiff', 'Resolution', 600)




