close all
addpath ../../Model_info/
load('Grid_info.mat','weto_p','depto_grid')

iw = 30;ie = 1;
jn = 30;js = 30;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
j_index_m = 210-30;
depto_16N = depto_grid(:,j_index_m);

load('../../Density/BC_tide_SSHA_16N.mat','lon','SSHA_tide');
%%
SSHA_tide_m2_miost = xlsread('./internal_tide_miost/prediction/MIOST_IT_Model_16N.xlsx');
% 
SSHA_tide_m2_model(:) = SSHA_tide(:,1,4);
SSHA_tide_m2_model(isnan(depto_16N)==1)=nan;
SSHA_tide_m2_miost(isnan(depto_16N)==1)=nan;
% plot(lon,SSHA_tide_m2_model*1e+2);
[AX,H1,H2] = plotyy(-lon,-SSHA_tide_m2_model*1e+2,-lon,SSHA_tide_m2_miost);

% [AX,H1,H2] = plotyy(-lonp_grid(:,j_index_m),zao_time(:,j_index_m),-lon_grid(:,j_index),SSH_M2_BC(:,j_index));
% 

set(H1,'LineStyle','-','linewidth',2,'DisplayName','Summer');
set(H1,'color','b');
set(H2,'LineStyle','-','linewidth',2,'DisplayName','MIOST-IT');
set(H2,'color','r');

set(AX(1),'XColor','k','YColor','b');
set(AX(2),'XColor','k','YColor','r');

HH1=get(AX(1),'Ylabel');
set(HH1,'String','M2 SSHA(cm)','FontSize',18);
set(HH1,'color','b');
set(AX(1),'xlim',[17.5 26],'LineWidth',1,'XDir','reverse');
min_b = -5;
max_b = 5;
inv_b = (max_b-min_b)/5;
set(AX(1),'ylim',[min_b max_b],'YTick',[min_b:inv_b:max_b],'LineWidth',1);
% AX(1).YRuler.TickLabelFormat = '%.1f';

HH2=get(AX(2),'Ylabel');
set(HH2,'String','M2 SSHA(cm)','FontSize',28);
set(HH2,'color','r');
set(AX(2),'xlim',[17.5 26],'LineWidth',1,'XDir','reverse','FontSize',28);
%xlabel('Longtitude(°W)','FontSize',28,'FontWeight','bold')

min_b = -2.5;
max_b = +2.5;
inv_b = (max_b-min_b)/5;
set(AX(2),'ylim',[min_b max_b],'YTick',[min_b:inv_b:max_b]);
% AX(2).YRuler.TickLabelFormat = '%.1f';
% AX(2).YRuler.Exponent = -2;


load('../../Winter/IT_analysis/M2_tide/BC_tide_SSHA_16N.mat','lon','SSHA_tide');

% j_index = 67;
% j_index_m = 210;
hold on;
SSHA_tide_m2_model(:) = SSHA_tide(:,1,4);

SSHA_tide_m2_model(isnan(depto_16N)==1)=nan

[WH] = plot(-lon,-SSHA_tide_m2_model*1e+2,'DisplayName','Winter');

set(WH,'LineStyle',':','linewidth',2,'color','b');
leg = legend('show','Autoupdate','off');
set(leg,'FontSize',28,'FontWeight','bold','Orientation','horizontal')
plot(-lon,linspace(0,0,size(SSHA_tide_m2_model,1)),'-.','Color','k','LineWidth',1)
grid on;
set(gca,'Layer','top','XDir','reverse','fontsize',28,'LineWidth',2,'fontname','Arial');
%xdate={'22.5°W','22°W','21.5°W','21°W','20.5°W','20°W','19.5°W','19°W','18.5°W',...
     % '18°W','17.5°W'}
set(gca,'Xtick',[17.5:0.5:26]);


ylim = 5;
ylimdown =-5;
y_CVarea = [26 ylim; 26 ylimdown; 22.95 ylimdown; 22.95 ylim];
pp = [1 2 3 4];
hold on;
patch('Faces',pp,'Vertices',y_CVarea,'Facecolor',[0.30,0.75,0.93],'Facealpha',.2,'EdgeColor','none')


y_CVareaopensea = [22.73 ylim; 22.73 ylimdown; 18.5 ylimdown;  18.5 ylim];
patch('Faces',pp,'Vertices',y_CVareaopensea,'Facecolor','yellow','Facealpha',.2,'EdgeColor','none')

y_MDA = [ 18.5 ylim;  18.5  ylimdown; 17.5 ylimdown;  17.5 ylim];
patch('Faces',pp,'Vertices',y_MDA,'Facecolor',[0.85,0.33,0.10],'Facealpha',.2,'EdgeColor','none')

% y_eddy_COLD = [9.5 ylim; 9.5 0; 12 0; 12 ylim];
% patch('Faces',pp,'Vertices',y_eddy_COLD,'Facecolor',[0.65,0.65,0.65],'Facealpha',.2,'EdgeColor','none')
% 


