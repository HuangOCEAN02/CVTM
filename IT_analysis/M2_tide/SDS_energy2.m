% Figure12 down 2
clear;clc;close all
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

%%
load('./M2_HKE_h.mat','HKE_h')
load('./M2_APE_h.mat','APE_h')
% APE_h = APE_h.*1e-3.*depto_grid;
% HKE_h = HKE_h.*1e-3.*depto_grid;

APE_h = APE_h.*1e-3;
HKE_h = HKE_h.*1e-3;

LONLIMS = [-21 -15];
LATLIMS = [12.6 18.6];
%%
select_indicex = find(lonp_grid(:,1)>=-18.5 & lonp_grid(:,1)<=-16);
select_indicey = find(latp_grid(1,:)>=13 & latp_grid(1,:)<=15);


APE_h_CV = APE_h(select_indicex,select_indicey);
HKE_h_CV = HKE_h(select_indicex,select_indicey);


lat_CV = latp_grid(select_indicex,select_indicey);
lon_CV = lonp_grid(select_indicex,select_indicey);

dlxp_CV = dlxp(select_indicex,select_indicey);
dlyp_CV = dlyp(select_indicex,select_indicey);

depto_CV = depto_grid(select_indicex,select_indicey);

cvie = length(select_indicex);
cvje = length(select_indicey);

depto_CV = reshape(depto_CV,[cvie*cvje,1]);
dlxp_CV = reshape(dlxp_CV,[cvie*cvje,1]);
dlyp_CV = reshape(dlyp_CV,[cvie*cvje,1]);

APE_h_CV = reshape(APE_h_CV,[cvie*cvje,1]);
HKE_h_CV = reshape(HKE_h_CV,[cvie*cvje,1]);

% remove nan
[HKE_h_CV,inx_nan]= rmmissing(HKE_h_CV);
APE_h_CV(inx_nan)=[];


depto_CV(inx_nan)=[];
dlxp_CV(inx_nan)=[];
dlyp_CV(inx_nan)=[];

% sort
[depto_CV_x,inx] = sort(depto_CV,'ascend');

APE_h_CV = APE_h_CV(inx); % kJ/m2
HKE_h_CV = HKE_h_CV(inx); % kJ/m2

% APE_h_CV = APE_h_CV.*dlxp_CV.*dlyp_CV; % kJ
% HKE_h_CV = HKE_h_CV.*dlxp_CV.*dlyp_CV; % kJ

%0m-3500m
inteval = 100;
3500/50;
for iiz = 1:1:3500/inteval

    up =  (iiz-1)*inteval;
    dow = (iiz)*inteval;

    dpe(iiz) = (up+dow)./2

    APE_diag(iiz,1) = nansum(APE_h_CV(depto_CV_x<=dow & depto_CV_x>up));
    HKE_diag(iiz,1) = nansum(HKE_h_CV(depto_CV_x<=dow & depto_CV_x>up));
    APE_diag(iiz,2) = nanmean(APE_h_CV(depto_CV_x<=dow & depto_CV_x>up));
    HKE_diag(iiz,2) = nanmean(HKE_h_CV(depto_CV_x<=dow & depto_CV_x>up));

end
% 累计 summer
inteval = 10;
3500/50;
for iiz = 1:1:3500/inteval

    up =  (iiz-1)*inteval;
    dow = (iiz)*inteval;

    dpe_continue(iiz) = (up+dow)./2;

    APE_continue(iiz,1) = nansum(APE_h_CV(depto_CV_x<=dow & depto_CV_x>up));
    HKE_continue(iiz,1) = nansum(HKE_h_CV(depto_CV_x<=dow & depto_CV_x>up));
    % DF_diag(iiz,1) = nansum(DIF_F_CV(depto_CV_x<=dow & depto_CV_x>up));
    % F_diag(iiz,1) = nansum(F_mag_CV(depto_CV_x<=dow & depto_CV_x>up));


    APE_continue(iiz,2) = nanmean(APE_h_CV(depto_CV_x<=dow & depto_CV_x>up));
    HKE_continue(iiz,2) = nanmean(HKE_h_CV(depto_CV_x<=dow & depto_CV_x>up));
    % DF_diag(iiz,2) = nanmean(DIF_F_CV(depto_CV_x<=dow & depto_CV_x>up));
    % F_diag(iiz,2) = nanmean(F_mag_CV(depto_CV_x<=dow & depto_CV_x>up));

end


APE_continue(isnan(APE_continue)==1)=0;
HKE_continue(isnan(HKE_continue)==1)=0;

APE_cumu = cumsum(APE_continue);
HKE_cumu = cumsum(HKE_continue);


% 累计 winter
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_APE_h.mat','APE_h');
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_HKE_h.mat','HKE_h');
APE_h_winter = APE_h.*1e-3;
HKE_h_winter = HKE_h.*1e-3;
clear HKE_h APE_h


APE_h_CV_winter = APE_h_winter(select_indicex,select_indicey);
HKE_h_CV_winter = HKE_h_winter(select_indicex,select_indicey);

APE_h_CV_winter = reshape(APE_h_CV_winter,[cvie*cvje,1]);
HKE_h_CV_winter = reshape(HKE_h_CV_winter,[cvie*cvje,1]);

[APE_h_CV_winter,inx_nan]= rmmissing(APE_h_CV_winter);
HKE_h_CV_winter(inx_nan)=[];

APE_h_CV_winter = APE_h_CV_winter(inx);
HKE_h_CV_winter = HKE_h_CV_winter(inx);

inteval = 10;
3500/50;
for iiz = 1:1:3500/inteval

    up =  (iiz-1)*inteval;
    dow = (iiz)*inteval;

    dpe_continue(iiz) = (up+dow)./2;

    APE_winter_continue(iiz,1) = nansum(APE_h_CV_winter(depto_CV_x<=dow & depto_CV_x>up));
    HKE_winter_continue(iiz,1) = nansum(HKE_h_CV_winter(depto_CV_x<=dow & depto_CV_x>up));
    % DF_diag(iiz,1) = nansum(DIF_F_CV(depto_CV_x<=dow & depto_CV_x>up));
    % F_diag(iiz,1) = nansum(F_mag_CV(depto_CV_x<=dow & depto_CV_x>up));


    APE_winter_continue(iiz,2) = nanmean(APE_h_CV_winter(depto_CV_x<=dow & depto_CV_x>up));
    HKE_winter_continue(iiz,2) = nanmean(HKE_h_CV_winter(depto_CV_x<=dow & depto_CV_x>up));
    % DF_diag(iiz,2) = nanmean(DIF_F_CV(depto_CV_x<=dow & depto_CV_x>up));
    % F_diag(iiz,2) = nanmean(F_mag_CV(depto_CV_x<=dow & depto_CV_x>up));

end


APE_winter_continue(isnan(APE_winter_continue)==1)=0;
HKE_winter_continue(isnan(HKE_winter_continue)==1)=0;

APE_winter_cumu = cumsum(APE_winter_continue);
HKE_winter_cumu = cumsum(HKE_winter_continue);

%%
figure(3);clf;set(gcf,'color','w');
set(gcf,'position',[10 10 1200 300]);
yyaxis left;
barh = bar(dpe,[APE_diag(:,1)';HKE_diag(:,1)']);hold on;
set(barh(1),'Facecolor',[0.3,0.65,0.75],'Linewidth',1.5);
set(barh(2),'Facecolor',[0.89,0.45,0.23],'Linewidth',1.5);
set(barh,'Linewidth',1.5,'Barwidth',1);
xlim([30 3500])
ylim([0 3.5])
set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 2000],'XTick',[0:100:2000],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);grid on
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2)
% ylabel(['${kJ \cdot m^{-2}}$'],'Interpreter','latex','Rotation',0,'FontSize',18,'FontWeight','bold')
ylabel(['Energy ','$(kJ \ m^{-3})$'],'Interpreter','latex','Rotation',90,'FontSize',28,'FontWeight','bold','fontname','Arial')
% leg = legend('AutoUpdate','off');
set(gca,'YColor','k')
% set(leg,'Orientation','vertical','Location','southeast',...
%     'EdgeColor','k',...
%     'Color','w','fontsize',15,...
%     'Interpreter','latex')


yyaxis right;
plot(dpe_continue,APE_cumu(:,1),'LineWidth',2,'linestyle','-','Color',[0.3,0.65,0.75]);hold on;
% scatter(dpe_continue,APE_cumu(:,1),'LineWidth',1,'Marker','*','Color','k');hold on;
plot(dpe_continue,HKE_cumu(:,1),'LineWidth',2,'linestyle','-','Color',[0.89,0.45,0.23]);hold on;
% scatter(dpe_continue,HKE_cumu(:,1),'LineWidth',1,'Marker','*','MarkerEdgeColor','flat');hold on;

plot(dpe_continue,APE_winter_cumu(:,1),'LineWidth',2,'linestyle','-.','Color',[0.3,0.65,0.75]);hold on;
% scatter(dpe_continue,APE_cumu(:,1),'LineWidth',1,'Marker','*','Color','k');hold on;
plot(dpe_continue,HKE_winter_cumu(:,1),'LineWidth',2,'linestyle','-.','Color',[0.89,0.45,0.23]);hold on;

ylabel([' Cumulation  \newline ' ...
    ' $(kJ \ m^{-3})$'],'Interpreter','latex','Rotation',90,'FontSize',28,'FontWeight','bold','fontname','Arial')
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);grid on
set(gca,'YColor','k')

img=getframe(gcf);
imwrite(img.cdata,['BC_M2_energy_SDS_topo2.tiff'], 'tiff', 'Resolution', 300)


