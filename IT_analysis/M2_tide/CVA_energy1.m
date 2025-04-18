%Figure 8a
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
load('M2_flux_uh.mat')
load('M2_flux_vh.mat')
load('M2_conversion.mat');
load('M2_Flux_Divergence.mat');

R = Div_F - C;
Flux_x = Flux_x*1e-3.*depto_grid;
Flux_y = Flux_y*1e-3.*depto_grid;
F_mag = sqrt(Flux_x.^2+Flux_y.^2);
%%
load('CapeVerde_index.mat')

C_CV = C(select_indicex,select_indicey);
R_CV = R(select_indicex,select_indicey);
DIF_F_CV = Div_F(select_indicex,select_indicey);
F_mag_CV = F_mag(select_indicex,select_indicey);

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

C_CV = reshape(C_CV,[cvie*cvje,1]);
R_CV = reshape(R_CV,[cvie*cvje,1]);
DIF_F_CV = reshape(DIF_F_CV,[cvie*cvje,1]);
F_mag_CV = reshape(F_mag_CV,[cvie*cvje,1]);
% remove nan
[R_CV,inx_nan]= rmmissing(R_CV);
C_CV(inx_nan)=[];
DIF_F_CV(inx_nan)=[];

depto_CV(inx_nan)=[];
dlxp_CV(inx_nan)=[];
dlyp_CV(inx_nan)=[];

% sort
[depto_CV_x,inx] = sort(depto_CV,'ascend');

C_CV = C_CV(inx); % W/m2
R_CV = R_CV(inx); % W/m2
DIF_F_CV = DIF_F_CV(inx);  % W/m2
F_mag_CV = F_mag_CV(inx); % W/m3

dlyp_CV = dlyp_CV(inx); % W/m2
dlxp_CV = dlxp_CV(inx); % W/m2

C_CV = C_CV.*dlxp_CV.*dlyp_CV;
R_CV = R_CV.*dlxp_CV.*dlyp_CV;
DIF_F_CV = DIF_F_CV.*dlxp_CV.*dlyp_CV;




%0m-3500m
inteval = 200;
3500/50;
for iiz = 1:1:3500/inteval

    up =  (iiz-1)*inteval;
    dow = (iiz)*inteval;

    dpe(iiz) = (up+dow)./2

    C_diag(iiz,1) = nansum(C_CV(depto_CV_x<=dow & depto_CV_x>up));
    R_diag(iiz,1) = nansum(R_CV(depto_CV_x<=dow & depto_CV_x>up));
    DF_diag(iiz,1) = nansum(DIF_F_CV(depto_CV_x<=dow & depto_CV_x>up));
    % F_diag(iiz,1) = nansum(F_mag_CV(depto_CV_x<=dow & depto_CV_x>up));


    C_diag(iiz,2) = nanmean(C_CV(depto_CV_x<=dow & depto_CV_x>up));
    R_diag(iiz,2) = nanmean(R_CV(depto_CV_x<=dow & depto_CV_x>up));
    DF_diag(iiz,2) = nanmean(DIF_F_CV(depto_CV_x<=dow & depto_CV_x>up));
    % F_diag(iiz,2) = nanmean(F_mag_CV(depto_CV_x<=dow & depto_CV_x>up));

end

% 累计
inteval = 10;
3500/50;
for iiz = 1:1:3500/inteval

    up =  (iiz-1)*inteval;
    dow = (iiz)*inteval;

    dpe_continue(iiz) = (up+dow)./2;

    C_continue(iiz,1) = nansum(C_CV(depto_CV_x<=dow & depto_CV_x>up));
    R_continue(iiz,1) = nansum(R_CV(depto_CV_x<=dow & depto_CV_x>up));
    % DF_diag(iiz,1) = nansum(DIF_F_CV(depto_CV_x<=dow & depto_CV_x>up));
    % F_diag(iiz,1) = nansum(F_mag_CV(depto_CV_x<=dow & depto_CV_x>up));


    C_continue(iiz,2) = nanmean(C_CV(depto_CV_x<=dow & depto_CV_x>up));
    R_continue(iiz,2) = nanmean(R_CV(depto_CV_x<=dow & depto_CV_x>up));
    % DF_diag(iiz,2) = nanmean(DIF_F_CV(depto_CV_x<=dow & depto_CV_x>up));
    % F_diag(iiz,2) = nanmean(F_mag_CV(depto_CV_x<=dow & depto_CV_x>up));

end

C_continue = C_continue.*1e-6;
R_continue = R_continue.*1e-6;

C_continue(isnan(C_continue)==1)=0;
R_continue(isnan(R_continue)==1)=0;

C_sum = cumsum(C_continue);
R_sum = cumsum(R_continue);


C_diag(:,:) = C_diag(:,:).*1e-6;
DF_diag(:,:) = DF_diag(:,:).*1e-6;
R_diag(:,:) = R_diag(:,:).*1e-6;


% 累计 winter
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_Flux_Divergence.mat');
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_conversion.mat');
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_flux_uh.mat')
load('../../Winter_Stratification/IT_analysis/M2_tide/M2_flux_vh.mat')
C_winter = C;
Div_F_winter = Div_F;
Flux_strength_winter = sqrt(Flux_x.^2+ Flux_y.^2);
R_winter = Div_F_winter - C_winter;
clear C Div_F Flux_x Flux_y

C_CV_winter = C_winter(select_indicex,select_indicey);
R_CV_winter = R_winter(select_indicex,select_indicey);
DIF_F_CV_winter = Div_F_winter(select_indicex,select_indicey);



C_CV_winter = reshape(C_CV_winter,[cvie*cvje,1]);
R_CV_winter = reshape(R_CV_winter,[cvie*cvje,1]);
DIF_F_CV_winter = reshape(DIF_F_CV_winter,[cvie*cvje,1]);

[R_CV_winter,inx_nan]= rmmissing(R_CV_winter);
C_CV_winter(inx_nan)=[];
DIF_F_CV_winter(inx_nan)=[];

C_CV_winter = C_CV_winter(inx);
R_CV_winter = R_CV_winter(inx);
DIF_F_CV_winter = DIF_F_CV_winter(inx);

C_CV_winter = C_CV_winter.*dlxp_CV.*dlyp_CV;
R_CV_winter = R_CV_winter.*dlxp_CV.*dlyp_CV;
DIF_F_CV_winter = DIF_F_CV_winter.*dlxp_CV.*dlyp_CV;






inteval = 10;
3500/50;
for iiz = 1:1:3500/inteval

    up =  (iiz-1)*inteval;
    dow = (iiz)*inteval;

    dpe_continue(iiz) = (up+dow)./2;

    C_winter_continue(iiz,1) = nansum(C_CV_winter(depto_CV_x<=dow & depto_CV_x>up));
    R_winter_continue(iiz,1) = nansum(R_CV_winter(depto_CV_x<=dow & depto_CV_x>up));
    % DF_diag(iiz,1) = nansum(DIF_F_CV(depto_CV_x<=dow & depto_CV_x>up));
    % F_diag(iiz,1) = nansum(F_mag_CV(depto_CV_x<=dow & depto_CV_x>up));


    C_winter_continue(iiz,2) = nanmean(C_CV_winter(depto_CV_x<=dow & depto_CV_x>up));
    R_winter_continue(iiz,2) = nanmean(R_CV_winter(depto_CV_x<=dow & depto_CV_x>up));
    % DF_diag(iiz,2) = nanmean(DIF_F_CV(depto_CV_x<=dow & depto_CV_x>up));
    % F_diag(iiz,2) = nanmean(F_mag_CV(depto_CV_x<=dow & depto_CV_x>up));

end

C_winter_continue = C_winter_continue.*1e-6;
R_winter_continue = R_winter_continue.*1e-6;

C_winter_continue(isnan(C_winter_continue)==1)=0;
R_winter_continue(isnan(R_winter_continue)==1)=0;

C_winter_sum = cumsum(C_winter_continue);
R_winter_sum = cumsum(R_winter_continue);


%%




figure(3);clf;set(gcf,'color','w');
set(gcf,'position',[10 10 1200 300]);
% subplot(211);
yyaxis left;
barh = bar(dpe,[C_diag(:,1)';DF_diag(:,1)';R_diag(:,1)']);hold on;
set(barh(1),'Facecolor',[0.00,0.79,0.25],'Linewidth',2,'DisplayName','Conversion');
set(barh(2),'Facecolor',[0.30,0.75,0.93],'Linewidth',2,'DisplayName','Radiation');
set(barh(3),'Facecolor',[0.91,0.91,0.14],'Linewidth',2,'DisplayName','Dissipation');
set(barh,'Linewidth',2,'Barwidth',1);
xlim([30 3500])
ylim([-150  200])
set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3500],'XTick',[0:200:3500],'fontname','Arial','fontweight','bold',...
    'XTickLabel',{' '});
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);grid on
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2)
set(gca,'YColor','k')

ylabel([' Power\newline ' ...
    ' $(MW)$'],'Interpreter','latex','Rotation',90,'FontSize',28,'FontWeight','bold','fontname','Arial')

leg = legend('AutoUpdate','off');
set(leg,'Orientation','horizontal','Location','southeast',...
    'EdgeColor','k',...
    'Color','w','fontsize',25)

yyaxis right;
plot(dpe_continue,C_sum(:,1),'LineWidth',2,'linestyle','-','Color',[0.00,0.79,0.25]);hold on;
plot(dpe_continue,R_sum(:,1),'LineWidth',2,'linestyle','-','Color',[0.91,0.91,0.14]);hold on;
plot(dpe_continue,C_winter_sum(:,1),'LineWidth',2,'linestyle','-.','Color',[0.00,0.79,0.25]);hold on;
plot(dpe_continue,R_winter_sum(:,1),'LineWidth',2,'linestyle','-.','Color',[0.91,0.91,0.14]);hold on;

ylabel([' Cumulation  \newline ' ...
    ' $(MW)$'],'Interpreter','latex','Rotation',90,'FontSize',28,'FontWeight','bold','fontname','Arial')
ylim([-1500  2000])
set(gca,'YColor','k')

img=getframe(gcf);
imwrite(img.cdata,['BC_M2_energy_topo1.tiff'], 'tiff', 'Resolution', 300)

