%Figure5a
clear;clc;close all
addpath ../../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')
%%
load('M2_flux_uh.mat')
load('M2_flux_vh.mat')
load('M2_conversion.mat');
load('M2_Flux_Divergence.mat');
%%
iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);

ie = size(depto_grid,1);
je = size(depto_grid,2);
mask = zeros(ie,je)+1;
mask(isnan(depto_grid)==1)=0;
%%

C = C.*mask;
C(isnan(depto_grid)==1)=nan;
Div_F(isnan(depto_grid)==1)=nan;

R = C - Div_F;
R(isnan(depto_grid)==1)=nan;  % w/m

u_flux = Flux_x;
v_flux = Flux_y;
u_flux = u_flux*1e-3.*depto_grid; % kw/m
v_flux = v_flux*1e-3.*depto_grid;
% K: kilo 10^3
% M: mega 10^6
% G: giga 10^9
% T: tera 10^12
% P: peta 10^15
% E: exa 10^18
%%
% LONLIMS = [min(min(lonp_grid)) max(max(lonp_grid))];
% LATLIMS = [min(min(latp_grid)) max(max(latp_grid))];
% save Level1_domain.mat  LATLIMS LONLIMS
LONLIMS = [-26.5 -20.5];
LATLIMS = [14 18];

figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

select_indicex = find(lonp_grid(:,1)>=-26 & lonp_grid(:,1)<=-21.6);
select_indicey = find(latp_grid(1,:)>=14.4 & latp_grid(1,:)<=17.5);
save ../../Model_info/CapeVerde_index.mat select_indicex select_indicey

C_cvs = C(select_indicex,select_indicey);
lon_cvs  = lonp_grid(select_indicex,select_indicey);
lat_cvs  = latp_grid(select_indicex,select_indicey);
dlxp_cvs = dlxp(select_indicex,select_indicey);
dlyp_cvs = dlyp(select_indicex,select_indicey);
depto_cvs = depto_grid(select_indicex,select_indicey);
Fx_cvs = u_flux(select_indicex,select_indicey);
Fy_cvs = v_flux(select_indicex,select_indicey);
R_cvs = R(select_indicex,select_indicey);
Div_F_cvs = Div_F(select_indicex,select_indicey);



%%


hold on;
m_pcolor(lon_cvs,lat_cvs,C_cvs);shading interp;hold on;
m_pcolor(lon_cvs,lat_cvs,C_cvs);shading interp;hold on;
m_plot(lon_cvs(1,:),lat_cvs(1,:),'k-','linewidth',2.0);hold on;
m_plot(lon_cvs(end,:),lat_cvs(end,:),'k-','linewidth',2.0);hold on;
m_plot(lon_cvs(:,1),lat_cvs(:,1),'k-','linewidth',2.0);hold on;
m_plot(lon_cvs(:,end),lat_cvs(:,end),'k-','linewidth',2.0);hold on;

clear select_indicey select_indicex
select_indicex = find(lonp_grid(:,1)>=-25.78 & lonp_grid(:,1)<=-23.8);
select_indicey = find(latp_grid(1,:)>=16.2 & latp_grid(1,:)<=17.4);
C_wwi = C(select_indicex,select_indicey);
lon_wwi  = lonp_grid(select_indicex,select_indicey);
lat_wwi  = latp_grid(select_indicex,select_indicey);
dlxp_wwi = dlxp(select_indicex,select_indicey);
dlyp_wwi = dlyp(select_indicex,select_indicey);
depto_wwi = depto_grid(select_indicex,select_indicey);
Fx_wwi = u_flux(select_indicex,select_indicey);
Fy_wwi = v_flux(select_indicex,select_indicey);
R_wwi = R(select_indicex,select_indicey);
Div_F_wwi = Div_F(select_indicex,select_indicey);
%pic
% m_pcolor(lon_wwi,lat_wwi,C_wwi);shading interp;hold on;
load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
clim([-0.5 0.5])
m_plot(lon_wwi(1,:),lat_wwi(1,:),'k-','linewidth',1.5);hold on;
m_plot(lon_wwi(end,:),lat_wwi(end,:),'k-','linewidth',1.5);hold on;
m_plot(lon_wwi(:,1),lat_wwi(:,1),'k-','linewidth',1.5);hold on;
m_plot(lon_wwi(:,end),lat_wwi(:,end),'k-','linewidth',1.5);hold on;



clear select_indicex select_indicey

select_indicex = find(lonp_grid(:,1)>=-23.4 & lonp_grid(:,1)<=-22.2);
select_indicey = find(latp_grid(1,:)>=15.8 & latp_grid(1,:)<=17.1);
C_ewi = C(select_indicex,select_indicey);
lon_ewi  = lonp_grid(select_indicex,select_indicey);
lat_ewi  = latp_grid(select_indicex,select_indicey);
dlxp_ewi = dlxp(select_indicex,select_indicey);
dlyp_ewi = dlyp(select_indicex,select_indicey);
depto_ewi = depto_grid(select_indicex,select_indicey);
Fx_ewi = u_flux(select_indicex,select_indicey);
Fy_ewi = v_flux(select_indicex,select_indicey);
R_ewi = R(select_indicex,select_indicey);
Div_F_ewi = Div_F(select_indicex,select_indicey);


% m_pcolor(lon_ewi,lat_ewi,C_ewi);shading interp;hold on;
m_plot(lon_ewi(1,:),lat_ewi(1,:),'k-','linewidth',1.5);hold on;
m_plot(lon_ewi(end,:),lat_ewi(end,:),'k-','linewidth',1.5);hold on;
m_plot(lon_ewi(:,1),lat_ewi(:,1),'k-','linewidth',1.5);hold on;
m_plot(lon_ewi(:,end),lat_ewi(:,end),'k-','linewidth',1.5);hold on;


clear select_indicex select_indicey

select_indicex = find(lonp_grid(:,1)>=-25.1 & lonp_grid(:,1)<=-22.75);
select_indicey = find(latp_grid(1,:)>=14.45 & latp_grid(1,:)<=15.62);

C_li = C(select_indicex,select_indicey);
lon_li  = lonp_grid(select_indicex,select_indicey);
lat_li  = latp_grid(select_indicex,select_indicey);
dlxp_li = dlxp(select_indicex,select_indicey);
dlyp_li = dlyp(select_indicex,select_indicey);
depto_li = depto_grid(select_indicex,select_indicey);
Fx_li = u_flux(select_indicex,select_indicey);
Fy_li = v_flux(select_indicex,select_indicey);
R_li = R(select_indicex,select_indicey);
Div_F_li = Div_F(select_indicex,select_indicey);

% pic
% m_pcolor(lon_li,lat_li,C_li);shading interp;hold on;
m_plot(lon_li(1,:),lat_li(1,:),'k-','linewidth',1.5);hold on;
m_plot(lon_li(end,:),lat_li(end,:),'k-','linewidth',1.5);hold on;
m_plot(lon_li(:,1),lat_li(:,1),'k-','linewidth',1.5);hold on;
m_plot(lon_li(:,end),lat_li(:,end),'k-','linewidth',1.5);hold on;


clear select_indicex select_indicey

%% standing wave

select_indicex = find(lonp_grid(:,1)>=-24.8 & lonp_grid(:,1)<=-24);
select_indicey = find(latp_grid(1,:)>=15.1 & latp_grid(1,:)<=16.45);


C_sw = C(select_indicex,select_indicey);
lon_sw  = lonp_grid(select_indicex,select_indicey);
lat_sw  = latp_grid(select_indicex,select_indicey);
dlxp_sw = dlxp(select_indicex,select_indicey);
dlyp_sw = dlyp(select_indicex,select_indicey);
depto_sw = depto_grid(select_indicex,select_indicey);
Fx_sw = u_flux(select_indicex,select_indicey);
Fy_sw = v_flux(select_indicex,select_indicey);
R_sw = R(select_indicex,select_indicey);
Div_F_sw = Div_F(select_indicex,select_indicey);


% m_plot(lon_sw(1,:),lat_sw(1,:),'k-','linewidth',1.5);hold on;
% m_plot(lon_sw(end,:),lat_sw(end,:),'k-','linewidth',1.5);hold on;
% m_plot(lon_sw(:,1),lat_sw(:,1),'k-','linewidth',1.5);hold on;
% m_plot(lon_sw(:,end),lat_sw(:,end),'k-','linewidth',1.5);hold on;



Region_energy_M2_SW = zeros(1,6);

CC_sw = C_sw.*dlxp_sw.*dlyp_sw;
Region_energy_M2_SW(1,1) = nansum(CC_sw, 'all');
% W and E
Region_energy_M2_SW(1,2) = nansum(Fx_sw(1,:).*dlyp_sw(1,:),'all');
Region_energy_M2_SW(1,3) = nansum(Fx_sw(end,:).*dlyp_sw(end,:),'all');
% N and S
Region_energy_M2_SW(1,4) = nansum(Fy_sw(:,1).*dlxp_sw(:,1),'all');
Region_energy_M2_SW(1,5) = nansum(Fy_sw(:,end).*dlxp_sw(:,end),'all');

RR_sw = R_sw.*dlxp_sw.*dlyp_sw;
Region_energy_M2_SW(1,6) = nansum(RR_sw, 'all');

disp(['generation'])
Region_energy_M2_SW(1,1)

disp(['dissipation'])
Region_energy_M2_SW(1,6)

disp(['generation - dissipation'])
Region_energy_M2_SW(1,1)-Region_energy_M2_SW(1,6)

-abs(Region_energy_M2_SW(1,2)) + abs(Region_energy_M2_SW(1,3)) ...
    + abs(Region_energy_M2_SW(1,4))+ abs(Region_energy_M2_SW(1,5))

% -abs(Region_energy_M2(1,2)) - abs(Region_energy_M2(1,3)) ...
%     - abs(Region_energy_M2(1,4))- abs(Region_energy_M2(1,5))
% 
% Region_energy_M2(1,1)-Region_energy_M2(1,6)

clear select_indicex select_indicey
%%
[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:4000],...
    'linewidth',0.4,'color',[.4 .4 .4]);hold on;
clabel(c,h,'LabelSpacing',1500,'color',[.4 .4 .4],...
    'fontsize',10,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

set(gca,'Layer','top','fontweight','bold');


bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
set(get(bar,'Title'),'string','W m^-^2','fontname','Arial','fontweight','bold');
% m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);

% lable
labelx = [-21,-20.7];labelz = [14.25,14.3];
labelu = [4,0];labelv=[0,0];

% u_flux(333:347,80:91)=nan;
% v_flux(333:347,80:91)=nan;

XX_pic = lonp_grid(2:5:end,2:5:end);
ZZ_pic = latp_grid(2:5:end,2:5:end);
UU_pic = u_flux(2:5:end,2:5:end); 
VV_pic = v_flux(2:5:end,2:5:end);

nan_indicex = find(XX_pic(:,1)>-21.2 & XX_pic(:,1)<-20);
nan_indicey = find(ZZ_pic(1,:)>14 & ZZ_pic(1,:)<14.3);
UU_pic(nan_indicex,nan_indicey) = nan;
VV_pic(nan_indicex,nan_indicey) = nan;

scale_auto = Get_Autoscale(XX_pic,ZZ_pic,UU_pic,VV_pic); 
scale_label = Get_Autoscale(labelx,labelz,labelu,labelv);
scale_factor = scale_auto/scale_label;

q_label= m_quiver(labelx,labelz,labelu,labelv,...
        2.0,'MaxHeadSize',1.5,'color','b','linewidth',1.8);
q_minus = m_quiver(XX_pic,ZZ_pic,UU_pic,VV_pic,...
        2.0/scale_factor,'MaxHeadSize',0.8,'color',[.4 .4 .4],'linewidth',1.5);
set(q_minus,'MaxHeadSize',0.8);


m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  


set(gca,'Layer','top','fontweight','bold');



annotation(figure(1),'textbox',...
    [0.769090909090909 0.127692307692308 0.09 0.0415384615384618],...
    'String','4 kW m^-^1',...
    'LineStyle','none',...
    'FontSize',20,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'EdgeColor','none') 
annotation(figure(1),'rectangle',...
    [0.770909090909091 0.12 0.0763636363636364 0.0538461538461538],...
    'LineWidth',1.5);

img=getframe(gcf);
imwrite(img.cdata,['Figure5a.tiff'], 'tiff', 'Resolution', 300)

%%
Region_energy_M2 =zeros(4,5);

% W
% First column: conversion energy

% KW
% Second column: West boundary energy flux 
% Third column: East boundary energy flux 
% Fourth column: North boundary energy flux 
% Fifth column: South boundary energy flux 

% W
% Sixed column: Residual energy

CC_wwi = C_wwi.*dlxp_wwi.*dlyp_wwi;  % W
Region_energy_M2(1,1) = nansum(CC_wwi, 'all');

% W and E
Region_energy_M2(1,2) = nansum(Fx_wwi(1,:).*dlyp_wwi(1,:),'all'); % KW
Region_energy_M2(1,3) = nansum(Fx_wwi(end,:).*dlyp_wwi(end,:),'all');
% N and S
Region_energy_M2(1,4) = nansum(Fy_wwi(:,1).*dlxp_wwi(:,1),'all');
Region_energy_M2(1,5) = nansum(Fy_wwi(:,end).*dlxp_wwi(:,end),'all');


CC_ewi = C_ewi.*dlxp_ewi.*dlyp_ewi;
Region_energy_M2(2,1) = nansum(CC_ewi, 'all');

% W and E
Region_energy_M2(2,2) = nansum(Fx_ewi(1,:).*dlyp_ewi(1,:),'all');
Region_energy_M2(2,3) = nansum(Fx_ewi(end,:).*dlyp_ewi(end,:),'all');
% N and S
Region_energy_M2(2,4) = nansum(Fy_ewi(:,1).*dlxp_ewi(:,1),'all');
Region_energy_M2(2,5) = nansum(Fy_ewi(:,end).*dlxp_ewi(:,end),'all');




CC_li = C_li.*dlxp_li.*dlyp_li;
Region_energy_M2(3,1) = nansum(CC_li, 'all');
% W and E
Region_energy_M2(3,2) = nansum(Fx_li(1,:).*dlyp_li(1,:),'all');
Region_energy_M2(3,3) = nansum(Fx_li(end,:).*dlyp_li(end,:),'all');
% N and S
Region_energy_M2(3,4) = nansum(Fy_li(:,1).*dlxp_li(:,1),'all');
Region_energy_M2(3,5) = nansum(Fy_li(:,end).*dlxp_li(:,end),'all');


CC_cvs = C_cvs.*dlxp_cvs.*dlyp_cvs;
Region_energy_M2(4,1) = nansum(CC_cvs, 'all');
% W and E
Region_energy_M2(4,2) = nansum(Fx_cvs(1,:).*dlyp_cvs(1,:),'all');
Region_energy_M2(4,3) = nansum(Fx_cvs(end,:).*dlyp_cvs(end,:),'all');
% N and S
Region_energy_M2(4,4) = nansum(Fy_cvs(:,1).*dlxp_cvs(:,1),'all');
Region_energy_M2(4,5) = nansum(Fy_cvs(:,end).*dlxp_cvs(:,end),'all');

RR_wwi = R_wwi.*dlxp_wwi.*dlyp_wwi;
RR_ewi = R_ewi.*dlxp_ewi.*dlyp_ewi;
RR_li = R_li.*dlxp_li.*dlyp_li;
RR_cvs = R_cvs.*dlxp_cvs.*dlyp_cvs;


divergence_wwi = Div_F_wwi.*dlxp_wwi.*dlyp_wwi;
divergence_ewi = Div_F_ewi.*dlxp_ewi.*dlyp_ewi;
divergence_li = Div_F_li.*dlxp_li.*dlyp_li;
divergence_cvs = Div_F_cvs.*dlxp_cvs.*dlyp_cvs;


Region_energy_M2(1,6) = nansum(RR_wwi, 'all');
Region_energy_M2(2,6) = nansum(RR_ewi, 'all');
Region_energy_M2(3,6) = nansum(RR_li, 'all');
Region_energy_M2(4,6) = nansum(RR_cvs, 'all');

Region_energy_M2(1,7) = nansum(divergence_wwi, 'all');
Region_energy_M2(2,7) = nansum(divergence_ewi, 'all');
Region_energy_M2(3,7) = nansum(divergence_li, 'all');
Region_energy_M2(4,7) = nansum(divergence_cvs, 'all');


% Unit: GW
Region_energy_M2(:,1) = Region_energy_M2(:,1)*1e-9;
Region_energy_M2(:,2:5) = Region_energy_M2(:,2:5)*1e-6;
Region_energy_M2(:,6:7) = Region_energy_M2(:,6:7)*1e-9;


disp(['inside'])
Region_energy_M2(4,2) ... % W
 - Region_energy_M2(4,3)... % E
 - Region_energy_M2(4,4) ... % N
 + Region_energy_M2(4,5) ... % S

disp(['conversion'])
Region_energy_M2(4,1)

disp(['dissipation'])
Region_energy_M2(4,6)
Region_energy_M2(4,7)-Region_energy_M2(4,1)


save CVS_Region_tide_energy.mat -append Region_energy_M2






