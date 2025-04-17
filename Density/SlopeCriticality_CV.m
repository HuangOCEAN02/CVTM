% Figure5c
clear;
close all
addpath ../Model_info/
load('Grid_info.mat','ke','latp_grid','lonp_grid','depto_grid','zzout','weto_p');
load('Grid_resolution.mat', 'dlxu')
load('Grid_resolution.mat', 'dlyv')

iw = 30;ie = 1;
jn = 30;js = 30;
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
zzout  = Exclude_sponge(iw,ie,jn,js,zzout);
weto_p = Exclude_sponge(iw,ie,jn,js,weto_p);

dlxu  = Exclude_sponge(iw+1,ie,jn,js,dlxu);
dlyv  = Exclude_sponge(iw,ie,jn+1,js,dlyv);

ie = size(depto_grid,1);
je = size(depto_grid,2);

% load('Density_coordinates.mat', 'poo_ini')
% poo_ini = poo_ini.*1025;
load('Density_coordinates.mat', 'rao_ini')
% rao_ini  = Exclude_sponge(15,1,15,15,rao_ini);
rao_ini  = Exclude_sponge(30,1,30,30,rao_ini);
%%
bottom_index = zeros(ie,je);
for i = 1:ie
    for j = 1:je
        if(weto_p(i,j,1) == 1)
            bottom_index(i,j) = sum(weto_p(i,j,:));
        else
            bottom_index(i,j) = nan;
        end
    end
end

%%
f_coe1 = sw_f(latp_grid); %[rad/s-1]
% omega  = 1./86164;
% 
% f_coe = 2*omega*sind(latp_grid); %[s-1]
f_coe =f_coe1;

sigma = 2*pi/(12.4206012*3600);  %[rad/s-1]
[DHdy,DHdx] = gradient(depto_grid);
DHdy= -DHdy./dlyv;
DHdx= DHdx./dlxu;

%% tidal elipse
% DH_max = sqrt(DHdy.^2+ DHdx.^2);
load('../Tide/BT_analysis/M2_inc.mat')
alpha = INC_grid;
Beta = zeros(ie,je);

Beta(alpha>90) = alpha(alpha>90)-90;
Beta(alpha<=90) = 90-alpha(alpha<=90);
%%
% 
DHdl = DHdy.*cosd(Beta) + DHdx.*cosd(alpha);

% Buoyancy frequency
N2_bottom = zeros(ie,je);
ang = zeros(ie,je);
slope = zeros(ie,je);
RRR = zeros(ie,je,ke+1);
ZZZ = zeros(ie,je,ke+1);
RRR(:,:,1) = rao_ini(:,:,1);
RRR(:,:,2:end) = rao_ini;
ZZZ(:,:,2:end) = zzout;
%% Maximum N
load('BRAVE60_CV_summer.mat', 'N2_summer','z');
N2_max = max(N2_summer);
%%

for i = 1:ie
    for j =1:je
        if (weto_p(i,j,1) == 1)

             b_index = find(z <= depto_grid(i,j));
             N2_bottom(i,j) = N2_summer(b_index(end)-1);  %[rad/s]^2
            ang(i,j)  = sqrt( (sigma.^2 - f_coe(i,j).^2) / (N2_bottom(i,j)- sigma.^2) );
                slope(i,j) = abs(DHdl(i,j))./real(ang(i,j));

        else
            slope(i,j) = nan;
        end
    end
end

ang = real(ang);

% slope(slope>=2)=2;
% slope(slope<1)=0;

LONLIMS = [-26.5 -20.5];
LATLIMS = [14 18];
%%
slope = abs(DHdl)./ang;
LONLIMS = [-26.5 -20.5];
LATLIMS = [14 18];

figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
%% area

clear select_indicey select_indicex
select_indicex = find(lonp_grid(:,1)>=-25.78 & lonp_grid(:,1)<=-23.8);
select_indicey = find(latp_grid(1,:)>=16.2 & latp_grid(1,:)<=17.4);
lon_wwi  = lonp_grid(select_indicex,select_indicey);
lat_wwi  = latp_grid(select_indicex,select_indicey);

%pic
% m_pcolor(lon_wwi,lat_wwi,C_wwi);shading interp;hold on;

m_plot(lon_wwi(1,:),lat_wwi(1,:),'k--','linewidth',1.5);hold on;
m_plot(lon_wwi(end,:),lat_wwi(end,:),'k--','linewidth',1.5);hold on;
m_plot(lon_wwi(:,1),lat_wwi(:,1),'k--','linewidth',1.5);hold on;
m_plot(lon_wwi(:,end),lat_wwi(:,end),'k--','linewidth',1.5);hold on;



clear select_indicex select_indicey

select_indicex = find(lonp_grid(:,1)>=-23.4 & lonp_grid(:,1)<=-22.2);
select_indicey = find(latp_grid(1,:)>=15.8 & latp_grid(1,:)<=17.1);
lon_ewi  = lonp_grid(select_indicex,select_indicey);
lat_ewi  = latp_grid(select_indicex,select_indicey);

% m_pcolor(lon_ewi,lat_ewi,C_ewi);shading interp;hold on;
m_plot(lon_ewi(1,:),lat_ewi(1,:),'k--','linewidth',1.5);hold on;
m_plot(lon_ewi(end,:),lat_ewi(end,:),'k--','linewidth',1.5);hold on;
m_plot(lon_ewi(:,1),lat_ewi(:,1),'k--','linewidth',1.5);hold on;
m_plot(lon_ewi(:,end),lat_ewi(:,end),'k--','linewidth',1.5);hold on;


clear select_indicex select_indicey

select_indicex = find(lonp_grid(:,1)>=-25.1 & lonp_grid(:,1)<=-22.75);
select_indicey = find(latp_grid(1,:)>=14.45 & latp_grid(1,:)<=15.62);

lon_li  = lonp_grid(select_indicex,select_indicey);
lat_li  = latp_grid(select_indicex,select_indicey);

% pic
% m_pcolor(lon_li,lat_li,C_li);shading interp;hold on;
m_plot(lon_li(1,:),lat_li(1,:),'k--','linewidth',1.5);hold on;
m_plot(lon_li(end,:),lat_li(end,:),'k--','linewidth',1.5);hold on;
m_plot(lon_li(:,1),lat_li(:,1),'k--','linewidth',1.5);hold on;
m_plot(lon_li(:,end),lat_li(:,end),'k--','linewidth',1.5);hold on;


clear select_indicex select_indicey





%%
% slope = slope/10;
% slope(slope>1) = slope(slope>1)./100;
% slope = abs(slope);
% slope(slope<1)=nan;
% slope(slope<1)=0;
m_pcolor(lonp_grid,latp_grid,slope);shading interp;hold on;
load('hotcold_18lev.mat');colormap(hotcold_18lev);
% m=colormap(m_colmap('blue','step'));colormap(m(end:-1:1,:));
load('nrl_sirkes.mat');colormap(nrl_sirkes);
load('MPL_RdGy_r.mat');colormap(MPL_RdGy_r);
bar = colorbar;
set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
set(get(bar,'Title'),'string','\alpha','fontname','Arial','fontweight','bold','fontsize',28);
set(bar,'LineWidth',2)

% load('MPL_bwr.mat');
% for j=65:-1:1
%     MPL_bwr(j,:)=MPL_bwr(65,:);
% end
% for j=66:128
%     MPL_bwr(j,:)=MPL_bwr(110,:);
% end
% colormap(MPL_bwr);
% % load('sunshine 9lev.mat');colormap(sunshine_9lev)
% clim([-0.02 2])
% set(bar,'Ticks',[-0.02,0.5:0.5:2],'TickLabels',{'0','0.5','1','1.5','2'});

% load('spread_15lev.mat');colormap(spread_15lev);
load('precip3_16lev.mat');
for j=2:-1:1
    precip3_16lev(j,:)=precip3_16lev(1,:);
end
colormap(precip3_16lev(1:end,:));
clim([0 3])

[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:4000],...
    'linewidth',1.2,'color',[.4 .4 .4]);hold on;
% clabel(c,h,'LabelSpacing',1500,'color','k',...
%      'fontsize',15,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.5);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

clear select_indicey select_indicex
select_indicex = find(lonp_grid(:,1)>=-25.78 & lonp_grid(:,1)<=-23.8);
select_indicey = find(latp_grid(1,:)>=16.2 & latp_grid(1,:)<=17.4);
lon_wwi  = lonp_grid(select_indicex,select_indicey);
lat_wwi  = latp_grid(select_indicex,select_indicey);

%pic
% m_pcolor(lon_wwi,lat_wwi,C_wwi);shading interp;hold on;

m_plot(lon_wwi(1,:),lat_wwi(1,:),'k--','linewidth',1.5);hold on;
m_plot(lon_wwi(end,:),lat_wwi(end,:),'k--','linewidth',1.5);hold on;
m_plot(lon_wwi(:,1),lat_wwi(:,1),'k--','linewidth',1.5);hold on;
m_plot(lon_wwi(:,end),lat_wwi(:,end),'k--','linewidth',1.5);hold on;



clear select_indicex select_indicey

% select_indicex = find(lonp_grid(:,1)>=-23.4 & lonp_grid(:,1)<=-22.2);
% select_indicey = find(latp_grid(1,:)>=15.8 & latp_grid(1,:)<=17.1);

select_indicex = find(lonp_grid(:,1)>=-23.4 & lonp_grid(:,1)<=-21.7);
select_indicey = find(latp_grid(1,:)>=15.62 & latp_grid(1,:)<=17.4);

lon_ewi  = lonp_grid(select_indicex,select_indicey);
lat_ewi  = latp_grid(select_indicex,select_indicey);

% m_pcolor(lon_ewi,lat_ewi,C_ewi);shading interp;hold on;
m_plot(lon_ewi(1,:),lat_ewi(1,:),'k--','linewidth',1.5);hold on;
m_plot(lon_ewi(end,:),lat_ewi(end,:),'k--','linewidth',1.5);hold on;
m_plot(lon_ewi(:,1),lat_ewi(:,1),'k--','linewidth',1.5);hold on;
m_plot(lon_ewi(:,end),lat_ewi(:,end),'k--','linewidth',1.5);hold on;


clear select_indicex select_indicey

select_indicex = find(lonp_grid(:,1)>=-25.1 & lonp_grid(:,1)<=-22.75);
select_indicey = find(latp_grid(1,:)>=14.45 & latp_grid(1,:)<=15.62);

lon_li  = lonp_grid(select_indicex,select_indicey);
lat_li  = latp_grid(select_indicex,select_indicey);

% pic
% m_pcolor(lon_li,lat_li,C_li);shading interp;hold on;
m_plot(lon_li(1,:),lat_li(1,:),'k--','linewidth',1.5);hold on;
m_plot(lon_li(end,:),lat_li(end,:),'k--','linewidth',1.5);hold on;
m_plot(lon_li(:,1),lat_li(:,1),'k--','linewidth',1.5);hold on;
m_plot(lon_li(:,end),lat_li(:,end),'k--','linewidth',1.5);hold on;


clear select_indicex select_indicey

img=getframe(gcf);
imwrite(img.cdata,['Fig5c.tiff'], 'tiff', 'Resolution', 300)




%%