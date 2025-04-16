clear;clc;close all
load data_GESLA1255.mat

load("../../Model_info/BRAVE60_topo.mat")
 lon_range = [ max(max(LON_level1_P)) min(min(LON_level1_P)) ];
 lat_range = [ max(max(LAT_level1_P)) min(min(LAT_level1_P)) ];
 LONLIMS = [min(lon_range) max(lon_range)];
 LATLIMS = [min(lat_range) max(lat_range)];
 
figure(1)
m_proj('miller','lat',[-85 85]);
m_coast('patch',[.7 1 .7],'edgecolor','none');
m_grid('box','fancy','linestyle','-','gridcolor','w','backcolor',[.2 .65 1]);
hold on
for i=1:1255
data=data_GESLA{i};
lat1(i)=data{2};lon1(i)=data{3};
end
lon1(lon1>180)=lon1(lon1>180)-360;
m_plot(lon1,lat1,'r.')


index_m = (lon1>=LONLIMS(1)) & (lon1<=LONLIMS(2)) ...
    & (lat1>=LATLIMS(1)) & (lat1<=LATLIMS(2));
index_t = find(index_m==1);
lon_level1 = lon1(index_t);
lat_level1 = lat1(index_t);
tide_M2 = cell(10,7);
tide_S2 = cell(10,7);
tide_K1 = cell(10,7);
tide_O1 = cell(10,7);

tide_K2 = cell(10,7);
tide_N2 = cell(10,7);
tide_P1 = cell(10,7);
tide_Q1 = cell(10,7);

for i = 1: length(index_t)
    data = data_GESLA{index_t(i)};
    nameu=data{1,6};amp=data{1,7};gph=data{1,9};
%% M2
    for j=1:max(size(nameu))
        if strncmp(nameu(j,:),'M2  ',4)
        break;
        end
    end
    j
    tide_M2{i,1} = data{1,1};
    tide_M2{i,2} = data{1,2};
    tide_M2{i,3} = data{1,3};
    tide_M2{i,4} = data{1,4};
    tide_M2{i,5} = data{1,5};
    tide_M2{i,6} = amp(j);
    tide_M2{i,7} = gph(j);
%% S2
    for j=1:max(size(nameu))
        if strncmp(nameu(j,:),'S2  ',4)
        break;
        end
    end
    j
    tide_S2{i,1} = data{1,1};
    tide_S2{i,2} = data{1,2};
    tide_S2{i,3} = data{1,3};
    tide_S2{i,4} = data{1,4};
    tide_S2{i,5} = data{1,5};
    tide_S2{i,6} = amp(j);
    tide_S2{i,7} = gph(j);
%% O1
    for j=1:max(size(nameu))
        if strncmp(nameu(j,:),'O1  ',4)
        break;
        end
    end
    tide_O1{i,1} = data{1,1};
    tide_O1{i,2} = data{1,2};
    tide_O1{i,3} = data{1,3};
    tide_O1{i,4} = data{1,4};
    tide_O1{i,5} = data{1,5};
    tide_O1{i,6} = amp(j);
    tide_O1{i,7} = gph(j);
%% K1
    for j=1:max(size(nameu))
        if strncmp(nameu(j,:),'K1  ',4)
        break;
        end
    end
    tide_K1{i,1} = data{1,1};
    tide_K1{i,2} = data{1,2};
    tide_K1{i,3} = data{1,3};
    tide_K1{i,4} = data{1,4};
    tide_K1{i,5} = data{1,5};
    tide_K1{i,6} = amp(j);
    tide_K1{i,7} = gph(j);
%% K2
    for j=1:max(size(nameu))
        if strncmp(nameu(j,:),'K2  ',4)
        break;
        end
    end
    j
    tide_K2{i,1} = data{1,1};
    tide_K2{i,2} = data{1,2};
    tide_K2{i,3} = data{1,3};
    tide_K2{i,4} = data{1,4};
    tide_K2{i,5} = data{1,5};
    tide_K2{i,6} = amp(j);
    tide_K2{i,7} = gph(j);
%% N2
    for j=1:max(size(nameu))
        if strncmp(nameu(j,:),'N2  ',4)
        break;
        end
    end
    tide_N2{i,1} = data{1,1};
    tide_N2{i,2} = data{1,2};
    tide_N2{i,3} = data{1,3};
    tide_N2{i,4} = data{1,4};
    tide_N2{i,5} = data{1,5};
    tide_N2{i,6} = amp(j);
    tide_N2{i,7} = gph(j);
%% P1
    for j=1:max(size(nameu))
        if strncmp(nameu(j,:),'P1  ',4)
        break;
        end
    end
    tide_P1{i,1} = data{1,1};
    tide_P1{i,2} = data{1,2};
    tide_P1{i,3} = data{1,3};
    tide_P1{i,4} = data{1,4};
    tide_P1{i,5} = data{1,5};
    tide_P1{i,6} = amp(j);
    tide_P1{i,7} = gph(j);
%% Q1
    for j=1:max(size(nameu))
        if strncmp(nameu(j,:),'Q1  ',4)
        break;
        end
    end
    tide_Q1{i,1} = data{1,1};
    tide_Q1{i,2} = data{1,2};
    tide_Q1{i,3} = data{1,3};
    tide_Q1{i,4} = data{1,4};
    tide_Q1{i,5} = data{1,5};
    tide_Q1{i,6} = amp(j);
    tide_Q1{i,7} = gph(j);
end
%% Perdict
TidePeriod.m2 =  12.4206011981605 ;
TidePeriod.s2 =  12.000000004799999;
TidePeriod.n2 =  12.658348214571882;
TidePeriod.k2 =  11.967234802522507;
TidePeriod.k1 =  23.934469605045013 ;
TidePeriod.o1 =  25.819341694366;
TidePeriod.p1 =  24.06589023189846 ;
TidePeriod.q1 =  26.868356600676353;

base_date = datenum(2011,7,1,0,0,0);
end_date = datenum(2011,8,31,23,0,0)
time = [base_date:1/24:end_date];

%% Mauritania i=6
i = 6;
Lat =tide_M2{i,2};
Lon =tide_M2{i,3};
TIDECON = [tide_M2{i,6},0,tide_M2{i,7},0;...
           tide_S2{i,6},0,tide_S2{i,7},0;...
           tide_N2{i,6},0,tide_N2{i,7},0;...
           tide_K2{i,6},0,tide_K2{i,7},0;...
           tide_K1{i,6},0,tide_K1{i,7},0;...
           tide_O1{i,6},0,tide_O1{i,7},0;...
           tide_P1{i,6},0,tide_P1{i,7},0;...
           tide_Q1{i,6},0,tide_Q1{i,7},0;];
MR_Ttide = zeros(length(time),8);

% TIDECON(TIDECON<=0)=360+TIDECON(TIDECON<=0);
% TIDECON(:,[2,4])=0;

MR_Ttide(:,1)=t_predic(time,'M2 ',1/TidePeriod.m2, TIDECON(1,:));
MR_Ttide(:,2)=t_predic(time,'S2 ',1/TidePeriod.s2, TIDECON(2,:));
MR_Ttide(:,3)=t_predic(time,'N2 ',1/TidePeriod.n2, TIDECON(3,:));
MR_Ttide(:,4)=t_predic(time,'K2 ',1/TidePeriod.k2, TIDECON(4,:));
MR_Ttide(:,5)=t_predic(time,'K1 ',1/TidePeriod.k1, TIDECON(5,:));
MR_Ttide(:,6)=t_predic(time,'O1 ',1/TidePeriod.o1, TIDECON(6,:));
MR_Ttide(:,7)=t_predic(time,'P1 ',1/TidePeriod.p1, TIDECON(7,:));
MR_Ttide(:,8)=t_predic(time,'Q1 ',1/TidePeriod.q1, TIDECON(8,:));

MR_Ttide_sum = sum(MR_Ttide,2);


%% comparision
t_mdAddress=which('tmd');
t_mdAddress(t_mdAddress=='\')='/';
tideDataAddress=[t_mdAddress(1:end-5)  'DATA/Model_atlas_v1'];
%% Timeseries
figure(1);clf;set(gcf,'color','w');
set(gcf,'position',[50 50 1100 350])
plot((time-time(1))*24,MR_Ttide_sum*1e-2,'r','linewidth',1.2);hold on

% [East_tpxo,conlist] = tmd_tide_pred_mapts(tideDataAddress,time,...
%             data{2}, data{3},'z');
% 
% East_tpxo = squeeze(East_tpxo);
% plot(squeeze(East_tpxo),'b-','linewidth',1.2);hold on;

% load('../A.2.3(ControlRun)/exp_A22_Mauritania.mat')
% plot([1:tee],exp_A22,'g','LineWidth',1.0);hold on
% load('Tide_Mauritania.mat')
load('Tide_Mauritania.mat', 'exp_MA','tee')
plot([1:tee],exp_MA,'b','LineWidth',1.0);hold on

% from Aug 1st
Mdata = exp_MA(744+1:end);
Odata = MR_Ttide_sum(744+1:end)*1e-2;
Edata = Mdata - Odata;
[Skill,Mse] = ModelSkill(Mdata,Odata);
Ostd = std(Odata);
Estd = std(Edata);

plot([744+1:1488],Edata,'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle','-');
h=legend('SSH obs','SSH Level 1','SSH error'); set(h,'fontsize',14,'fontname','Arial','Orientation','horizontal')

axis([744+1 1488+1 -1.2 1.2])
set(gca,'fontsize',8,'XTick',[744+1:24:1489],'Ytick',[-1.2:0.2:1.2]);
ydate={'01-Aug-2011','02','03','04','05','06','07','08','09','10',...
       '11','12','13','14','15','16','17','18','19','20',...
       '21','22','23','24','25','26','27','28','29','30','31',...
       '1-Sep-2011'};
set(gca,'XTicklabel',ydate);box on;
set(gca,'fontname','Arial','fontsize',12)
grid off
set(gca,'linewidth',2,'fontsize',12,'fontname','Arial','fontweight','bold');
set(gca,'Layer','top');
title(['Nouakchott Mauritnania ','(',num2str(abs(Lon)),'°W ',num2str(Lat),'°N)'],...
      'fontsize',13,'fontname','Arial','fontweight','bold');
xlabel('Time (day)','fontsize',14,'fontname','Arial','fontweight','bold');
ylabel('SSH (m)','fontsize',14,'fontname','Arial','fontweight','bold')


img=getframe(gcf);
imwrite(img.cdata,['MA_SSH.tiff'], 'tiff', 'Resolution', 300)
%%
figure(2);clf;set(gcf,'color','w');
set(gcf,'position',[50 50 500 500])
% plot(exp_A22(744+24:end),CV_Ttide_sum(744+24:end)*1e-2,'ko');
 x = MR_Ttide_sum(744+1:end)*1e-2;
 y = exp_MA(744+1:end);
p = polyfit(x,y,1);
f = polyval(p,x);

% y = exp_A25(744+24:end);
% p = polyfit(x,y,1);

plot(x,y,'b.','MarkerSize',8,'Marker','.');hold on;
plot(x,f,'k-','linewidth',2.5);
h1=legend('SSH','Linear fit')
set(h1,'fontsize',16,'fontname','Arial','Orientation','horizontal','Location','northwest')
grid on
set(gca,'linewidth',2,'fontsize',16,'fontname','Arial','fontweight','bold');

xlabel('Model','fontsize',14,'fontname','Arial','fontweight','bold');
ylabel('Observation','fontsize',14,'fontname','Arial','fontweight','bold')

% img=getframe(gcf);
% imwrite(img.cdata,['MA_SSH_LinearFit.tiff'], 'tiff', 'Resolution', 300)

save Tide_Mauritania.mat  MR_Ttide_sum MR_Ttide time TIDECON Skill Mse Ostd Estd -append
%% Amplitude (m)

MA_selct = exp_MA(97:end);
start_time = [2011,7,05,0,0,0];
[NAME_exp,FREQ_exp,TIDECON_exp,XOUT_exp] = t_tide(MA_selct,'start time',start_time,'latitude',Lat,...
            'interval',1);

NAME_exp([15,17,14,8,6,5])
TIDECON_selct = [TIDECON_exp(15,:);...
    TIDECON_exp(17,:);...
    TIDECON_exp(14,:);...
    [0,0,0,0];...
    TIDECON_exp(8,:);...
    TIDECON_exp(6,:);...
    [0,0,0,0];...
    TIDECON_exp(5,:)];
%  FREQ_exp unit(cycles/hr)
FREQ_selct = [FREQ_exp(15);...
    FREQ_exp(17);...
    FREQ_exp(14);...
    [0];...
    FREQ_exp(8);...
    FREQ_exp(6);...
    [0];...
    FREQ_exp(5)];
FREQ_selct = FREQ_selct*24;

FREQ_selct(FREQ_selct==0)=nan;
TIDECON_selct(TIDECON_selct==0)=nan;

TIDECON_gauge = TIDECON;
TIDECON_gauge(4,:)=nan;
TIDECON_gauge(7,:)=nan;
TIDECON_gauge(:,1) = TIDECON_gauge(:,1).*1e-2;



Tide_label = {'M2';'S2';'N2';' ';...
    'K1';'O1';' ';'Q1'};
figure(3);clf;set(gcf,'color','w');
set(gcf,'position',[50 50 500 500])
% plot(FREQ_selct,TIDECON_selct(:,1),'ob','MarkerFaceColor','b','LineWidth',1,'MarkerFaceColor','c',...
%     'Markersize',15);hold on;
% 
% plot(FREQ_selct,TIDECON_gauge(:,1),'or','MarkerFaceColor','b','LineWidth',1,'MarkerFaceColor','r',...
%     'Markersize',15);hold on;

text (FREQ_selct,TIDECON_gauge(:,1),Tide_label,'FontWeight','bold','FontSize',18,'fontname','Arial','Color','r',...
    'Visible','on')

text (FREQ_selct,TIDECON_selct(:,1),Tide_label,'FontWeight','bold','FontSize',18,'fontname','Arial','Color','b',...
    'Visible','on');hold on;

text (0.75,0.532,'Observation','Color',[0 0 1],...
    'FontWeight','bold',...
    'FontSize',18,...
    'FontName','Arial');hold on
text (0.75,0.5087,'     Model  ','Color','r',...
    'FontWeight','bold',...
    'FontSize',18,...
    'FontName','Arial');hold on

grid on;box on;
set(gca,'linewidth',2,'fontsize',25,'fontname','Arial','fontweight','bold');

axis([0.5 2.5 0 0.6])
set(gca,'Layer','top');
xlabel('Frequency (cycles day^-^1)','fontsize',28,'fontname','Arial','fontweight','bold');
ylabel('Amplitude (m)','fontsize',28,'fontname','Arial','fontweight','bold')

img=getframe(gcf);
imwrite(img.cdata,['MA_SSH_Amplitude.tiff'], 'tiff', 'Resolution', 300)
%% Phase (degrees)
Phase_gauge = TIDECON_gauge(:,3);
% wrapToPi(Phase_gauge)
% Phase_gauge(Phase_gauge<=0)= Phase_gauge(Phase_gauge<=0) +360;

Phase_select = TIDECON_selct(:,3);
Phase_select([1,2]) = Phase_select([1,2]) - 360;
% wrapToPi(Phase_select)



figure(4);clf;set(gcf,'color','w');
set(gcf,'position',[50 50 500 500])
% plot(FREQ_selct,TIDECON_selct(:,1),'ob','MarkerFaceColor','b','LineWidth',1,'MarkerFaceColor','c',...
%     'Markersize',15);hold on;
% plot(FREQ_selct,TIDECON_gauge(:,1),'or','MarkerFaceColor','b','LineWidth',1,'MarkerFaceColor','r',...
%     'Markersize',15);hold on;

text (FREQ_selct,Phase_gauge,Tide_label,'FontWeight','bold','FontSize',18,'fontname','Arial','Color','r',...
    'Visible','on');hold on;
text (FREQ_selct,Phase_select,Tide_label,'FontWeight','bold','FontSize',18,'fontname','Arial','Color','b',...
    'Visible','on');hold on;

% text (0.55,120,'Observation','Color',[0 0 1],...
%     'FontWeight','bold',...
%     'FontSize',18,...
%     'FontName','Arial');hold on
% text (0.55,100,'     Model  ','Color','r',...
%     'FontWeight','bold',...
%     'FontSize',18,...
%     'FontName','Arial');hold on
% 

grid on;box on;
set(gca,'linewidth',2,'fontsize',25,'fontname','Arial','fontweight','bold');
axis([0.5 2.5 -100 300]);

set(gca,'Layer','top');
xlabel('Frequency (cycles day^-^1)','fontsize',28,'fontname','Arial','fontweight','bold');
ylabel('Phase lag (°)','fontsize',28,'fontname','Arial','fontweight','bold')

img=getframe(gcf);
imwrite(img.cdata,['MA_SSH_Phase.tiff'], 'tiff', 'Resolution', 300)






