%Fig9c
clear;close all
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

%% d
f_coe = sw_f(latp_grid); 
sigma = 2*pi/(12.4206012*3600);

[DHdy,DHdx] = gradient(depto_grid);
% DHdy : right(S) - left(N)
% DHdx : Down(E) - Up(W)
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
DHdl = DHdx .*cosd(alpha) + DHdy.*cosd(Beta);

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
             N2_bottom(i,j) = N2_summer(b_index(end)-1);
            ang(i,j)  = sqrt( (sigma^2 - f_coe(i,j)^2) / (N2_bottom(i,j)) - sigma^2  );

             slope(i,j) = abs(DHdl(i,j))./real(ang(i,j));
        else
            slope(i,j) = nan;
        end
    end
end

ang = real(ang);



LONLIMS = [-20.2 -16.8];
LATLIMS = [12.6 15];

LONLIMS = [-21 -15];
LATLIMS = [12.6 18.6];


%%
% LATLIMS = [min(min(latp_grid)) max(max(latp_grid))];
% LONLIMS = [min(min(lonp_grid)) max(max(lonp_grid))];
slope = abs(DHdl)./ang;

figure(3);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
set(gcf,'color','w');
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
% slope = slope/10;
% slope(slope>1) = slope(slope>1)./100;
% slope = abs(slope);
% slope(slope<1)=nan;

slope(isnan(slope)==1)=0;
% slope(slope<1)=1;
m_pcolor(lonp_grid,latp_grid,slope);shading interp;hold on;
% load('nrl_sirkes.mat');colormap(nrl_sirkes);
% load('MPL_RdGy_r.mat');colormap(MPL_RdGy_r);
% load('MPL_bwr.mat');
% for j=65:-1:1
%     MPL_bwr(j,:)=MPL_bwr(65,:);
% end
% for j=66:128
%     MPL_bwr(j,:)=MPL_bwr(110,:);
% end
% colormap(MPL_bwr);

load('precip3_16lev.mat');
for j=2:-1:1
    precip3_16lev(j,:)=precip3_16lev(1,:);
end
colormap(precip3_16lev(1:end,:));
clim([0 3])

clim([0 2])

[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
    'linewidth',1.0,'color','k');hold on;
clabel(c,h,'LabelSpacing',700,'color','w',...
    'fontsize',10,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')


bar = colorbar;set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold','linewidth',2);hold on;
set(get(bar,'Title'),'string','\alpha','fontname','Arial','fontweight','bold','linewidth',2,'fontsize',28);
% clim([-0.02 2])
% set(bar,'Ticks',[-0.02,0.5:0.5:2],'TickLabels',{'0','0.5','1','1.5','2'});


m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);

m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  

set(gca,'Layer','top');

[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
    'linewidth',1.0,'color','k');hold on;

img=getframe(gcf);
imwrite(img.cdata,['Fig9c.tiff'], 'tiff', 'Resolution', 300)
