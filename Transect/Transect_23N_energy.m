% Figure 6 right
clear;clc;close all
%% Gird
addpath ../Model_info/
load('Grid_info.mat','ie_g','je_g','ke','lonp_grid','latp_grid','ddpo_grid');
load('Grid_info.mat','weto_p','depto_grid','zzout');
iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
zzout  = Exclude_sponge(iw,ie,jn,js,zzout);
ddpo_grid  = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
%%
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);

dlxp(:,:)= 1;
dlyp(:,:)= 1;

ie = size(depto_grid,1);
je = size(depto_grid,2);

land = zeros(ie,je,ke);
land(weto_p==0)=1;

i_index = [115:138];
% i_index = [132:132];
lonp_grid(i_index,:);
% zzout_line(:,:) = zzout(i_index,:,:);
Depth_line = depto_grid(i_index,:);
% le = size(zzout_line,1);

% LAT = zeros(le,ke+2);
lat_line = latp_grid(i_index,:);
% for j = 1:size(LAT,2)
%     LAT(:,j) = lat_line(:);
% end
%% winter
load('../Winter/IT_analysis/M2_tide/M2_conversion.mat')
load('../Winter/IT_analysis/M2_tide/M2_Flux_Divergence.mat');
load('../Winter/IT_analysis/M2_tide/M2_HKE_APE.mat','APE_h','HKE_h');

% R = C - Div_F;
C_winter = C;
Div_F_winter = Div_F;
R_winter = C - Div_F;
APE_h_winter = APE_h;
HKE_h_winter = HKE_h;

load('../Winter/IT_analysis/M2_tide/M2_Flux.mat');
u_flux = Flux_x.*depto_grid; % w/m
v_flux = Flux_y.*depto_grid;
flux = sqrt(u_flux.^2+ v_flux.^2);
E_h = HKE_h.*depto_grid + APE_h.*depto_grid;
Cg_winter = flux./E_h;

Cg_winter(isnan(Cg_winter)==1)=0;



clear C Div_F  HKE_h APE_h u_flux v_flux Flux_y Flux_x E_h Nsq



% C_line_winter  = zeros(le,1);
% R_line_winter  = zeros(le,1);
% Div_F_line_winter = zeros(le,1);

C_line_winter(:,:) = C_winter(i_index,:).*dlxp(i_index,:).*dlyp(i_index,:);
R_line_winter(:,:) = R_winter(i_index,:).*dlxp(i_index,:).*dlyp(i_index,:);
Div_F_line_winter(:,:) = Div_F_winter(i_index,:).*dlxp(i_index,:).*dlyp(i_index,:);

APE_line_winter = APE_h_winter(i_index,:).*depto_grid(i_index,:);
HKE_line_winter = HKE_h_winter(i_index,:).*depto_grid(i_index,:);
 
Cg_line_winter = Cg_winter(i_index,:);

C_line_winter(isnan(Depth_line))=nan;
Div_F_line_winter(isnan(Depth_line))=nan;
R_line_winter(isnan(Depth_line))=nan;
APE_line_winter(isnan(Depth_line))=nan;
HKE_line_winter(isnan(Depth_line))=nan;
Cg_line_winter(isnan(Depth_line))=nan;
%% summer

load('../IT_analysis/M2_conversion.mat')
load('../IT_analysis/M2_Flux.mat');
load('../IT_analysis/M2_Flux_Divergence.mat');
load('../IT_analysis/M2_HKE_APE.mat','APE_h','HKE_h');

R = C - Div_F;


u_flux = Flux_x.*depto_grid; % w/m
v_flux = Flux_y.*depto_grid;
flux = sqrt(u_flux.^2+ v_flux.^2);
E_h = HKE_h.*depto_grid + APE_h.*depto_grid;
Cg_summer = flux./E_h;

Cg_summer(isnan(Cg_summer)==1)=0;

C_line_summer(:,:) = C(i_index,:).*dlxp(i_index,:).*dlyp(i_index,:);
R_line_summer(:,:) = R(i_index,:).*dlxp(i_index,:).*dlyp(i_index,:);
Div_F_line_summer(:,:) = Div_F(i_index,:).*dlxp(i_index,:).*dlyp(i_index,:);

APE_line_summmer = APE_h(i_index,:).*depto_grid(i_index,:);
HKE_line_summmer = HKE_h(i_index,:).*depto_grid(i_index,:);
Cg_line_summer = Cg_summer(i_index,:);


C_line_summer(isnan(Depth_line))=nan;
Div_F_line_summer(isnan(Depth_line))=nan;
R_line_summer(isnan(Depth_line))=nan;
APE_line_summmer(isnan(Depth_line))=nan;
HKE_line_summmer(isnan(Depth_line))=nan;
Cg_line_summer(isnan(Depth_line))=nan;

%%

lat_line = mean(lat_line,1);
C_line_summer =  mean(C_line_summer,1);
Div_F_line_summer=  mean(Div_F_line_summer,1);
R_line_summer=  mean(R_line_summer,1);


C_line_winter =  mean(C_line_winter,1);
Div_F_line_winter=  mean(Div_F_line_winter,1);
R_line_winter=  mean(R_line_winter,1);



C_line_summer=C_line_summer; %*1e-3; %kw
C_line_winter=C_line_winter; %.*1e-3;

Div_F_line_summer = Div_F_line_summer; % .*1e-3;
Div_F_line_winter = Div_F_line_winter; %.*1e-3;

R_line_summer = R_line_summer ; %.*1e-3;
R_line_winter = R_line_winter; %.*1e-3;

figure(1);clf;set(gcf,'color','w');set(gcf,'position',[0 60 700 800])
% h1 = axes('position',[0.08 0.68 0.83 0.28]);

h1 = axes('position',[0.12 0.65 0.83 0.28]);

plot(lat_line,C_line_summer,'LineWidth',2,'LineStyle','-','color','r','DisplayName','Conversion');hold on;
plot(lat_line,Div_F_line_summer,'LineWidth',2,'LineStyle','-','color','c','DisplayName','Radiation');hold on;
plot(lat_line,-R_line_summer,'LineWidth',2,'LineStyle','-','color','b','DisplayName','Dissipation');hold on;

leg = legend('AutoUpdate','off');
set(leg,'Orientation','horizontal','Location','northeast',...
    'EdgeColor','k',...
    'Color','w','fontsize',28)
% plot(lat_line,linspace(0,0,le),'LineWidth',1.5,'LineStyle','-','color','k');hold on;

plot(lat_line,C_line_winter,'LineWidth',2,'LineStyle',':','color','r');hold on;
plot(lat_line,Div_F_line_winter,'LineWidth',2,'LineStyle',':','color','c');hold on;
plot(lat_line,-R_line_winter,'LineWidth',2,'LineStyle',':','color','b');hold on;
grid on;

xlim([15.1 16.3]);

set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2)

ylabel(['Energy rate (W m^-^2)'],'Rotation',90,'FontSize',28,'fontname','Arial')

set(gca,'Layer','top');

set(gca,'fontsize',22,'LineWidth',2,'fontname','Arial'...
        ,'Xaxislocation','bottom');
ax = gca();
% ax.YAxis.Exponent = 2;
ax.YRuler.Exponent = -2;
ax.YRuler.TickLabelFormat = '%.0f';

set(gca,'YTick',[-3e-2:1.0e-2:4e-2]);
ylim([-3e-2 3e-2])
set(gca,'Layer','top');

%%
h2 = axes('position',[0.12 0.28 0.83 0.28]);

APE_line_summmer =  mean(APE_line_summmer,1);APE_line_summmer=APE_line_summmer.*1e-3;
HKE_line_summmer=  mean(HKE_line_summmer,1);HKE_line_summmer=HKE_line_summmer.*1e-3;

APE_line_winter =  mean(APE_line_winter,1);APE_line_winter=APE_line_winter.*1e-3;
HKE_line_winter=  mean(HKE_line_winter,1);HKE_line_winter = HKE_line_winter.*1e-3;

plot(lat_line,APE_line_summmer,'LineWidth',2,'LineStyle','-','color','r','DisplayName','$APE$');hold on;
plot(lat_line,HKE_line_summmer,'LineWidth',2,'LineStyle','-','color','c','DisplayName','$HKE$');hold on;
plot(lat_line,HKE_line_summmer+APE_line_summmer,'LineWidth',2,'LineStyle','-','color','k','DisplayName','$TE$');hold on;


leg = legend('AutoUpdate','off');
set(leg,'Orientation','horizontal','Location','northwest',...
    'EdgeColor','k',...
    'Color','w','fontsize',28,...
    'Interpreter','latex')
plot(lat_line,APE_line_winter,'LineWidth',2,'LineStyle',':','color','r');hold on;
plot(lat_line,HKE_line_winter,'LineWidth',2,'LineStyle',':','color','c');hold on;
plot(lat_line,HKE_line_winter+APE_line_winter,'LineWidth',2,'LineStyle',':','color','k','DisplayName','$TE$');hold on;

xlim([15.1 16.3]);

set(gca,'fontsize',28,'LineWidth',2,'fontname','Arial',...
        'Xaxislocation','bottom');
% bar2=colorbar('location','eastOutside','fontsize',12,'fontweight','bold',...
%         'Position',[0.928127294239945 0.10 0.0145454545454545 0.40]);
% set(get(bar2,'Title'),'string','$\frac{HKE}{APE}$','fontname','Arial','Interpreter','latex');
set(gca,'fontsize',28,'LineWidth',2,'fontname','Arial'...
        ,'Xaxislocation','bottom');
set(gca,'fontsize',22,'YTick',[0:0.5:3.5],'LineWidth',1.5,'fontname','Arial',...
    'Xaxislocation','bottom','LineWidth',2)
ylim([0 3.3])

ax = gca();
% ax.YAxis.Exponent = 2;
ax.YRuler.Exponent = 0;
% ax.YRuler.TickLabelFormat = '%.1f';

grid on;
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2)

ylabel('Energy (kJ m^-^2)','fontsize',28,'fontname','Arial');
set(gca,'Layer','top');
xlabel(['Latitude (°N)'],'fontsize',28,'fontname','Arial');



img=getframe(gcf);
imwrite(img.cdata,['Figure6right.tiff'], 'tiff', 'Resolution', 300);
