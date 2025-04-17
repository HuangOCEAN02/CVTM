% Figure6left
clear;clc;close all
%% Gird
addpath ../Model_info/
addpath ./GRID_FUNCTIONS/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
zzout  = Exclude_sponge(iw,ie,jn,js,zzout);
%%
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);

ie = size(depto_grid,1);
je = size(depto_grid,2);

land = zeros(ie,je,ke);
land(weto_p==0)=1;

i_index = 132;
zzout_line(:,:) = zzout(i_index,:,:);
Depth_line(:) = depto_grid(i_index,:);
le = size(zzout_line,1);

LAT = zeros(le,ke+2);
lat_line = latp_grid(i_index,:);
for j = 1:size(LAT,2)
    LAT(:,j) = lat_line(:);
end
%% winter
load('../Winter/IT_analysis/M2_tide/M2_Flux.mat', 'Flux_x_tide','Flux_y_tide')
load('../Winter/IT_analysis/M2_tide/M2_HKE_APE.mat','APE_tide','HKE_tide');
Flux_x_tide_winter = Flux_x_tide;
Flux_y_tide_winter = Flux_y_tide;
APE_tide_winter = APE_tide;
HKE_tide_winter = HKE_tide;

clear APE_tide HKE_tide Flux_x_tide Flux_y_tide

ua_line_winter  = zeros(le,ke);
va_line_winter  = zeros(le,ke);
ape_line_winter = zeros(le,ke);
hke_line_winter = zeros(le,ke);

for k = 1:ke

         uko(:,:) = Flux_x_tide_winter(i_index,:,k)*1e-3;
         vke(:,:) = Flux_y_tide_winter(i_index,:,k)*1e-3;
         ape(:,:) = APE_tide_winter(i_index,:,k)*1e-3;
         hke(:,:) = HKE_tide_winter(i_index,:,k)*1e-3;   

     ua_line_winter(:,k) = uko;
     va_line_winter(:,k) = vke;
     ape_line_winter(:,k) = ape;
     hke_line_winter(:,k) = hke;

  
end
zzout_line(zzout_line==0)=nan;
ua_line_winter(isnan(zzout_line))=nan;
va_line_winter(isnan(zzout_line))=nan;
ape_line_winter(isnan(zzout_line))=nan;
hke_line_winter(isnan(zzout_line))=nan;
%% summer
load('../IT_analysis/M2_Flux.mat', 'Flux_x_tide')
load('../IT_analysis/M2_Flux.mat', 'Flux_y_tide')
load('../IT_analysis/M2_HKE_APE.mat','APE_tide','HKE_tide');


ua_line = zeros(le,ke);
va_line = zeros(le,ke);
ape_line= zeros(le,ke);
hke_line= zeros(le,ke);
     % uko(:,:) = orctm_interp2p(ua(:,:,k),ie,je,'u');
     % vke(:,:) = orctm_interp2p(va(:,:,k),ie,je,'v');

     for k = 1:ke
         uko(:,:) = Flux_x_tide(i_index,:,k)*1e-3;
         vke(:,:) = Flux_y_tide(i_index,:,k)*1e-3;
         ape(:,:) = APE_tide(i_index,:,k)*1e-3;
         hke(:,:) = HKE_tide(i_index,:,k)*1e-3;    
        ua_line(:,k) = uko;
        va_line(:,k) = vke;
        ape_line(:,k) = ape;
        hke_line(:,k) = hke;
     end
     
     % ua_line(isnan(zzout_line))=nan;
     % va_line(isnan(zzout_line))=nan;
     % ape_line(isnan(zzout_line))=nan;
     % hke_line(isnan(zzout_line))=nan;

%%
for i = 1:le
    if ~isnan(Depth_line(i))
        [UF(i,:),ZZ(i,:)] = Fillcolumn(zzout_line(i,:),ua_line(i,:),Depth_line(i));
        [VF(i,:),~] = Fillcolumn(zzout_line(i,:),va_line(i,:),Depth_line(i));
        [APE(i,:),~] = Fillcolumn(zzout_line(i,:),ape_line(i,:),Depth_line(i));
        [HKE(i,:),~] = Fillcolumn(zzout_line(i,:),hke_line(i,:),Depth_line(i));
    end
end
%%
ZZ = ZZ*1e-3;
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[0 60 700 800])
h1 = axes('position',[0.08 0.54 0.85 0.40]);
pcolor(LAT,ZZ,log10(HKE+APE));shading interp;hold on;
% contour(LAT,ZZ,VF,[0,0],'LineStyle','-','LineWidth',1,'color','k');hold on;
% contour(LAT,ZZ,sqrt(VF.^2+UF.^2),50,'LineStyle','-');hold on;
% contour(LAT,ZZ,VF,[0.2:0.2:1.4],'LineWidth',1,'color','k');hold on;
clim([-4.5 -2]);
area(lat_line,Depth_line*1e-3,'FaceColor',[.4 .4 .4],'BaseValue',4.5,'linewidth',1.0);hold on
xlim([15.05 16.4]);
ylim([0 4.5]);
load('MPL_RdYlBu_r.mat');colormap(h1,MPL_RdYlBu_r);hold on;
  % load('NCV_jaisnd.mat');colormap(h1,jet);hold on;
% load('hotres.mat');colormap(h1,hotres);hold on;
% clim([-0.0 0.0070001]);
% set(gca,'YScale','log');
set(gca,'fontsize',28,'LineWidth',2,'fontname','Arial',...
        'Ydir','reverse','Xaxislocation','bottom');
bar1=colorbar('location','eastOutside','fontsize',28,'fontweight','bold','LineWidth',2);
set(get(bar1,'Title'),'string','J m^-^3','fontname','Arial','fontsize',28);

set(gca,'XTickLabel',{' '});

annotation(figure(1),'textbox',...
    [0.0914285714285714 0.553042016129533 0.17582145690918 0.0464705880950479],...
    'String','$\log_{10}(HKE+APE)$',...
        'Color',[1 1 1],...
    'LineStyle','none',...
    'Interpreter', 'latex',...
    'FontSize',28,...
    'FontName','Arial',...
    'FitBoxToText','on');  


% ylabel('Depth(m)','fontsize',16,'fontname','Arial','fontweight','bold');
set(gca,'Layer','top');

%%
h2 = axes('position',[0.08 0.10 0.85 0.40]);HKE(HKE==0)=nan;
ratio = HKE./APE;
ZZ(ratio==0)=nan;
% contour(LAT,ZZ,ratio,40);hold on;
pcolor(LAT,ZZ,HKE./APE);shading interp;hold on;
clim([0 2]);
area(lat_line,Depth_line*1e-3,'FaceColor',[.4 .4 .4],'BaseValue',4.5,'linewidth',1.0);hold on
load('MPL_bwr.mat');colormap(h2,MPL_bwr);
load('NCV_blue_red.mat');colormap(h2,NCV_blue_red);
load('BlRe.mat');colormap(h2,BlRe);
xlim([15.05 16.4]);ylim([0 4.5]);
%  set(gca,'YScale','log')
set(gca,'fontsize',28,'LineWidth',2,'fontname','Arial',...
        'Ydir','reverse','Xaxislocation','bottom');
bar2=colorbar('location','eastOutside','fontsize',28,'fontweight','bold','LineWidth',2);
        % 'Position',[0.928127294239945 0.10 0.0145454545454545 0.40]);
% set(get(bar2,'Title'),'string','$\frac{HKE}{APE}$','fontname','Arial','Interpreter','latex');
set(get(bar2,'Title'),'string',' ','fontname','Arial','fontsize',28,'LineWidth',2);

ylabel('Depth(km)','fontsize',28,'fontname','Arial');
set(gca,'Layer','top');
%%
f_line = sw_f(lat_line);
T_m2 = 12.4206011981605;
sigma_m2 = 2*pi./(3600*T_m2);
ratio = (sigma_m2.^2 + f_line.^2 )./(sigma_m2.^2 - f_line.^2 );

for j = 1:size(LAT,2)
    ratio_grid(:,j) = ratio(:);
end

hold on;
[c,h] = contour(LAT,ZZ,ratio_grid,[1.0:0.01:1.2],'color','w','linewidth',1.5,'linestyle',':');hold on;
clabel(c,h,'LabelSpacing',1500,'color','w',...
    'fontsize',18,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    xlabel('Latitude (°N)','fontsize',28,'fontname','Arial')
    set(gca,'Layer','top');

annotation(figure(1),'textbox',...
    [0.0944285714285714 0.123042016129533 0.17582145690918 0.0464705880950479],...
    'String','$\frac{HKE}{APE}$',...
    'Color',[1 1 1],...
    'LineStyle','none',...
    'Interpreter', 'latex',...
    'FontSize',28,...
    'FontName','Arial',...
    'FitBoxToText','on');  


img=getframe(gcf);
imwrite(img.cdata,['Figure6left.tiff'], 'tiff', 'Resolution', 300);
