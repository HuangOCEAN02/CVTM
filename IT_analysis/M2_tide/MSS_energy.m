% Figure11
clear;clc;clear;clc;close all
%% Gird
addpath ../../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

%%
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%% winter
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_Flux_Divergence.mat');
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_conversion.mat');
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_Flux.mat', 'Flux_x','Flux_y');
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_HKE_APE.mat','APE_h','HKE_h');
APE_h_winter = APE_h.*1e-3.*depto_grid;
HKE_h_winter = HKE_h.*1e-3.*depto_grid;
APE_h_winter = APE_h.*1e-3;
HKE_h_winter = HKE_h.*1e-3;
C_winter = C;
Div_F_winter = Div_F;
Flux_x_winter = Flux_x*1e-3.*depto_grid;
Flux_y_winter = Flux_y*1e-3.*depto_grid;
F_mag_winter = sqrt(Flux_x_winter.^2+ Flux_y_winter.^2);
R_winter = Div_F_winter - C_winter;
clear C Div_F Flux_x Flux_y APE_h HKE_h

% slope criticliaty
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_slope_criticality.mat');
slope_winter= slope;
depto_alpha_winter = slope_winter;
depto_alpha_winter(slope_winter==0)=nan;
clear slope
%% summer
load('./M2_Flux.mat');
load('./M2_conversion.mat');
load('./M2_Flux_Divergence.mat');
load('./M2_HKE_APE.mat','APE_h','HKE_h')
APE_h_summer = APE_h.*1e-3.*depto_grid;
HKE_h_summer = HKE_h.*1e-3.*depto_grid;
APE_h_summer = APE_h.*1e-3;
HKE_h_summer = HKE_h.*1e-3;
R_summer = Div_F - C;
Flux_x_summer = Flux_x*1e-3.*depto_grid;
Flux_y_summer = Flux_y*1e-3.*depto_grid;
F_mag_summer = sqrt(Flux_x_summer.^2+Flux_y_summer.^2);
%% slope criticliaty
load('../../Density/M2_slope_criticality.mat');
slope_summer = slope;
depto_alpha_summer = slope_summer;
depto_alpha_summer(slope_summer==0)=nan;
clear slope
%%
% select_indicex = find(lonp_grid(:,1)>=-18.5 & lonp_grid(:,1)<=-16);
% select_indicey = find(latp_grid(1,:)>=15 & latp_grid(1,:)<=18.4);
LONLIMS = [-21 -15];
LATLIMS = [12.6 18.6];
% NDS
select_indicex = find(lonp_grid(:,1)>=-18.5 & lonp_grid(:,1)<=-16);
select_indicex = find(lonp_grid(:,1)>=-21 & lonp_grid(:,1)<=-16);
select_indicey = find(latp_grid(1,:)>=13.0 & latp_grid(1,:)<=18.6);

C_CV_winter = C_winter(select_indicex,select_indicey);
R_CV_winter = R_winter(select_indicex,select_indicey);
DIF_F_CV_winter = Div_F_winter(select_indicex,select_indicey);
F_CV_mag_winter = F_mag_winter(select_indicex,select_indicey);
Alpha_CV_winter = depto_alpha_winter(select_indicex,select_indicey);
APE_h_CV_winter = APE_h_winter(select_indicex,select_indicey);
HKE_h_CV_winter = HKE_h_winter(select_indicex,select_indicey);
Flux_x_CV_winter =  Flux_x_winter(select_indicex,select_indicey);

C_CV_summer = C(select_indicex,select_indicey);
R_CV_summer = R_summer(select_indicex,select_indicey);
DIF_F_CV_summer = Div_F(select_indicex,select_indicey);
F_CV_mag_summer = F_mag_summer(select_indicex,select_indicey);
Alpha_CV_summer = depto_alpha_summer(select_indicex,select_indicey);
APE_h_CV_summer = APE_h_summer(select_indicex,select_indicey);
HKE_h_CV_summer = HKE_h_summer(select_indicex,select_indicey);
Flux_x_CV_summer = Flux_x_summer(select_indicex,select_indicey);

lat_CV = latp_grid(select_indicex,select_indicey);
lon_CV = lonp_grid(select_indicex,select_indicey);

dlxp_CV = dlxp(select_indicex,select_indicey);
dlyp_CV = dlyp(select_indicex,select_indicey);

depto_CV = depto_grid(select_indicex,select_indicey);

% C_CV_summer = C_CV_summer.*dlxp_CV.*dlyp_CV;
% R_CV_summer = R_CV_summer.*dlxp_CV.*dlyp_CV;
% DIF_F_CV_summer = DIF_F_CV_summer.*dlxp_CV.*dlyp_CV;

APE_h_CV_summer = APE_h_CV_summer.*depto_CV; %.*dlxp_CV.*dlyp_CV.*depto_CV;
HKE_h_CV_summer = HKE_h_CV_summer.*depto_CV; %.*dlxp_CV.*dlyp_CV.*depto_CV;

% C_CV_winter = C_CV_winter.*dlxp_CV.*dlyp_CV;
% R_CV_winter = R_CV_winter.*dlxp_CV.*dlyp_CV;
% DIF_F_CV_winter = DIF_F_CV_winter.*dlxp_CV.*dlyp_CV;

APE_h_CV_winter = APE_h_CV_winter.*depto_CV; %.*dlxp_CV.*dlyp_CV.*depto_CV;
HKE_h_CV_winter = HKE_h_CV_winter.*depto_CV; %.*dlxp_CV.*dlyp_CV.*depto_CV;
%%
cvie = length(select_indicex);
cvje = length(select_indicey);

Relative_LON = zeros(cvie,cvje);

% New coordinate
for j = 1:cvje
     depto_line = depto_CV(:,j);
     depto_line = depto_line(~isnan(depto_line));
     Relative_LON(1:length(depto_line),j) = [length(depto_line):-1:1]./length(depto_line);
end
Relative_LON(Relative_LON==0)=nan;

HKE_h_CV_summer(isnan(HKE_h_CV_summer))=0;
HKE_h_CV_winter(isnan(HKE_h_CV_winter))=0;


APE_h_CV_summer(isnan(APE_h_CV_summer))=0;
APE_h_CV_winter(isnan(APE_h_CV_winter))=0;




figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1200 650]);
h1 = axes('position',[0.05 0.10 0.20 0.75]);
% 
% pcolor(Relative_LON,lat_CV,Flux_x_CV_summer);shading interp; hold on;
% clim([-0.5 0.5]);
% load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;


pcolor(Relative_LON,lat_CV,(APE_h_CV_summer));shading interp; hold on;

[c,h] = contour(Relative_LON,lat_CV,depto_CV,[250,1000,2000,3000],'color','k','LineWidth',0.5,'LineStyle','--');hold on;
clabel(c,h,'LabelSpacing',1000,'fontsize',8,'color','k','fontname','Arial' ,'fontSmoothing','on');      

plot([0,1],[14.76,14.76],'LineStyle','-.','LineWidth',2,'Color','k');hold on;
xlim([0.1 1]);ylim([13 18.6]);
set(gca,'XDir','reverse','XTick',[0:0.2:1]);
% set(gca,'XScale','log')
clim([-15 -5]);
clim([0 1.2]);
% colormap("turbo");hold on;
load('hotres.mat');colormap(h1,hotres)
cbar = colorbar;
set(cbar,'Location','northoutside','Ticks',[0:0.2:1.2]);
set(cbar,'fontsize',20,'fontname','Arial' );hold on;
set(get(cbar,'Title'),'string','$APE \ (kJ \ m^{-2})$','Interpreter','latex');

xlabel([' Relative grid '],'fontname','Arial','FontSize',14 ,'fontname','Arial')
ylabel([' Latitude (°N) '],'fontname','Arial','FontSize',14 ,'fontname','Arial')

set(gca, 'fontsize',20,'LineWidth',2,'fontname','Arial',...
        'YTick',[13:0.5:18.5],'Xaxislocation','bottom' ); 
set(gca,'Layer','top' );


h3 = axes('position',[0.50 0.10 0.20 0.75]);
pcolor(Relative_LON,lat_CV,HKE_h_CV_summer);shading interp; hold on;
[c,h] = contour(Relative_LON,lat_CV,depto_CV,[250,500,1000,2000,3000],'color','k','LineWidth',0.5,'LineStyle','--');hold on;
  % clabel(c,h,'LabelSpacing',1000, 'fontsize',20,'color','k','fontname','Arial' ,'fontSmoothing','on');      
plot([0,1],[14.76,14.76],'LineStyle','-.','LineWidth',2,'Color','k');hold on;

xlim([0.1 1]);ylim([13 18.6]);
set(gca,'XDir','reverse','XTick',[0:0.2:1]);
% set(gca,'XScale','linear')
clim([0 1.2])
clim([0 0.5]);
% colormap("turbo");hold on;
load('GMT_seis_r.mat');colormap(h3,GMT_seis_r)
cbar = colorbar;
set(cbar,'Location','northoutside');
set(cbar,'fontsize',20,'fontname','Arial' );hold on;
set(cbar,'Ticks',[0:0.1:0.5])
set(get(cbar,'Title'),'string','$HKE \ (kJ \ m^{-2})$','Interpreter','latex');
xlabel([' Relative grid '],'fontname','Arial','FontSize',14 ,'fontname','Arial')
set(gca, 'fontsize',20,'LineWidth',2,'fontname','Arial','YTickLabel',{' '},...
        'YTick',[13:0.5:18.5],'Xaxislocation','bottom' );  
% 
set(gca,'Layer','top' );
%%
HKE_latitude_summer  = zeros(cvje,1);
HKE_latitude_winter  = zeros(cvje,1);
for j =1:cvje

    A_line = Alpha_CV_summer(:,j);
    A_winter_line  = Alpha_CV_winter(:,j);
    
    % 
    HKE_line = HKE_h_CV_summer(:,j);
    HKE_winter_line = HKE_h_CV_winter(:,j);

    APE_line = APE_h_CV_summer(:,j);
    APE_winter_line = APE_h_CV_winter(:,j);


    % HKE_line = C_CV_summer(:,j);
    % HKE_winter_line = C_CV_winter(:,j);
    % 
    % APE_line = R_CV_summer(:,j);
    % APE_winter_line = R_CV_winter(:,j);

    depto_line = depto_CV(:,j);
   

    inx = find(depto_line<=600 & depto_line>=400);
    A_latitude_summer(j,1) = nanmean(A_line(inx));
    A_latitude_winter(j,1) = nanmean(A_winter_line(inx));

    % slope
    inx = find(depto_line<=2000 & depto_line>250);
    HKE_latitude_summer(j,1) = nansum(HKE_line(inx));
    HKE_latitude_summer(j,2) = nanmean(HKE_line(inx));

    HKE_latitude_winter(j,1) = nansum(HKE_winter_line(inx));
    HKE_latitude_winter(j,2) = nanmean(HKE_winter_line(inx));

    APE_latitude_summer(j,1) = nansum(APE_line(inx));
    APE_latitude_summer(j,2) = nanmean(APE_line(inx));

    APE_latitude_winter(j,1) = nansum(APE_winter_line(inx));
    APE_latitude_winter(j,2) = nanmean(APE_winter_line(inx));

    % shelf
    inx = find(depto_line<=250);
    HKE_latitude_summer_shelf(j,1) = nansum(HKE_line(inx));
    HKE_latitude_summer_shelf(j,2) = nanmean(HKE_line(inx));

    HKE_latitude_winter_shelf(j,1) = nansum(HKE_winter_line(inx));
    HKE_latitude_winter_shelf(j,2) = nanmean(HKE_winter_line(inx));

    APE_latitude_summer_shelf(j,1) = nansum(APE_line(inx));
    APE_latitude_summer_shelf(j,2) = nanmean(APE_line(inx));

    APE_latitude_winter_shelf(j,1) = nansum(APE_winter_line(inx));
    APE_latitude_winter_shelf(j,2) = nanmean(APE_winter_line(inx));


end
y = lat_CV(1,:);
% h3 = axes('position',[0.50 0.10 0.20 0.7823]);

h4 = axes('position',[0.72 0.10 0.20 0.6823]);
plot(HKE_latitude_summer(:,2),y,'r','LineWidth',1);hold on;
plot(HKE_latitude_summer_shelf(:,2),y,'r','LineWidth',1,'LineStyle','--');hold on;


% scatter(0.35.*A_latitude_summer(A_latitude_summer>=1)./A_latitude_summer(A_latitude_summer>=1), ...
%     y(A_latitude_summer>=1),'Marker','diamond','LineWidth',0.9,'MarkerFaceColor','r','MarkerEdgeColor','k','SizeData',36)

plot(HKE_latitude_winter(:,2),y,'b','LineWidth',1);hold on;
plot(HKE_latitude_winter_shelf(:,2),y,'b','LineWidth',1,'LineStyle','--');hold on;
% scatter(0.35.*A_latitude_summer(A_latitude_summer>=1)./A_latitude_summer(A_latitude_summer>=1), ...
    % y(A_latitude_summer>=1),'Marker','diamond','LineWidth',0.9,'MarkerFaceColor',[0.5294, 0.8078, 0.9216],'MarkerEdgeColor','k','SizeData',36)

leg = legend('Slope (250–2000 m)','Shelf (0–250 m)','Slope (250–2000 m)','Shelf (0–250 m)');
set(leg,'Orientation','vertical',...
 'Position',[0.6925 0.00462890625000001 0.295194240989113 0.0607692307692308],...
    'NumColumns',2,...
    'FontSize',15,...
    'EdgeColor','w',...
    'Color','w', 'fontsize',15,'AutoUpdate','off');
grid on;
set(gca,'GridLineWidth',1.5,'GridLineStyle',':','GridAlpha',0.5)

% scatter(0.35.*A_latitude_summer(A_latitude_summer>=1)./A_latitude_summer(A_latitude_summer>=1), ...
    % y(A_latitude_summer>=1),'Marker','diamond','LineWidth',0.9,'MarkerFaceColor','r','MarkerEdgeColor','k','SizeData',36)



set(gca, 'fontsize',20,'LineWidth',2,'fontname','Arial','YTickLabel',{' '},...
        'YTick',[13:0.5:18.5],'Xaxislocation','top' );  
ylim([13 18.6]);xlim([0 0.35]);
% set(gca,'XScale','log')
xlabel(['Latitude distribution'],'fontname','Arial', 'fontsize',20 ,'fontname','Arial')



% h4 = axes('position',[0.72 0.10 0.20 0.7823]);
h2 = axes('position',[0.28 0.10 0.20 0.6823]);
plot(APE_latitude_summer(:,2),lat_CV(1,:),'r','LineWidth',1);hold on;
plot(APE_latitude_summer_shelf(:,2),lat_CV(1,:),'r','LineWidth',1,'LineStyle','--');hold on;
plot(APE_latitude_winter(:,2),y,'b','LineWidth',1);hold on;
plot(APE_latitude_winter_shelf(:,2),y,'b','LineWidth',1,'LineStyle','--');hold on;

% scatter(0.5.*A_latitude_winter(A_latitude_winter>=1)./A_latitude_winter(A_latitude_winter>=1), ...
    % y(A_latitude_winter>=1),'Marker','diamond','LineWidth',0.9,'MarkerFaceColor',[0.5294, 0.8078, 0.9216],'MarkerEdgeColor','k','SizeData',36)
set(gca, 'fontsize',20,'LineWidth',2,'fontname','Arial','YTickLabel',{' '},...
        'YTick',[13:0.5:18.5],...
        'Xaxislocation','top' );  
ylim([13 18.6]);xlim([0 0.5]);
xlabel(['Latitude distribution'],'fontname','Arial', 'fontsize',20 ,'fontname','Arial')
% set(gca,'XScale','log')
grid on;
set(gca,'GridLineWidth',1.5,'GridLineStyle',':','GridAlpha',0.5)

img=getframe(gcf);
imwrite(img.cdata,['Figure11.tiff'], 'tiff', 'Resolution', 300)


