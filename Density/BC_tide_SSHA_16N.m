clear;clc;close all
load('../IT_analysis/res_bbc_level1_CV.mat');
%%
addpath ../Model_info/
load('Grid_info.mat','ke','weto_p','depto_grid','ddpo_grid','bottom_index');
load('Grid_info.mat','latp_grid','lonp_grid');
iw = 30;ie = 1;
jn = 30;js = 30;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);

bottom_index = Exclude_sponge(iw,ie,jn,js,bottom_index);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
ddpo_grid  = Exclude_sponge(iw,ie,jn,js,ddpo_grid);

ie = size(depto_grid,1);
je = size(depto_grid,2);



%% Perdict
% TidePeriod.m2 =  12.4206011981605 ;
% TidePeriod.s2 =  12.000000004799999;
% TidePeriod.n2 =  12.658348214571882;
% TidePeriod.k2 =  11.967234802522507;
% TidePeriod.k1 =  23.934469605045013 ;
% TidePeriod.o1 =  25.819341694366;
% TidePeriod.p1 =  24.06589023189846 ;
% TidePeriod.q1 =  26.868356600676353;

TIDE={'O1 ';...
      'K1 ';...
      'N2 ';...
      'M2 ';...
      'S2 '};

TidePeriod = [25.819341694366; ...
              23.934469605045013; ...
              12.658348214571882; ...
              12.4206011981605 ;  ...
              12.000000004799999];
% snapshots at 
load('Time_info.mat', 'SDtime','LDTRUN','time_index')
Some_time = datenum(2011,08,14,18,0,0);

%%
% LONLIMS = [-21 -15];
% LATLIMS = [14.2 18.6];
% 
% LONLIMS = [-20.2 -16.8];
% LATLIMS = [12.6 15];
ba_bc = reshape(ba_bc,ie,je,ke,5);
bg_bc = reshape(bg_bc,ie,je,ke,5);
% select_indicex = find(lonp_grid(:,1)>-20.6 & lonp_grid(:,1)<-16.2);
% select_indicey = find(latp_grid(1,:)>12.2 & latp_grid(1,:)<16);

j_index_m = 210-30;


ba = ba_bc(:,j_index_m,:,:);
% M2_ba = ba(:,:,1,4);

bg = bg_bc(:,j_index_m,:,:);
mask = weto_p(:,j_index_m,:);
dep = depto_grid(:,j_index_m);
btm = bottom_index(:,j_index_m);
dz = ddpo_grid(:,j_index_m,:);
lon = lonp_grid(:,j_index_m);
lat = latp_grid(:,j_index_m);
ie = size(mask,1);
je = size(mask,2);


% LONLIMS = [-21 -15];
% LATLIMS = [14.2 18.6];

% figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
% m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
% m_grid('linestyle','none','linewidth',1.5,'fontsize',16,'fontname','Arial',...
%     'xtick',8,'tickdir','in');hold on;
% m_pcolor(lon,lat,ba(:,:,19,4));shading interp;
% clim([-2 2])
% load('BlueWhiteOrangeRed.mat');colormap(BlueWhiteOrangeRed)

%%
% SSHA_tide = zeros(ie,je);
% TIDECON = zeros(ke,4);
% 
% itide = 4 ; %M2
% for i = 1:ie
%     for j = 1:je
%         if mask(i,j,1)~=0
%             buoyancy_time(1:btm(i,j)) = 0;
%             % TIDECON(:)=0;
%             TIDECON(1:btm(i,j),1) = ba(i,j,1:btm(i,j),itide).*dz(i,j,1:btm(i,j));
%             TIDECON(1:btm(i,j),3) = bg(i,j,1:btm(i,j),itide);
% 
%             buoyancy_time = ...
%                 t_predic(Some_time,TIDE(itide),1/TidePeriod(itide),TIDECON(1:btm(i,j),:));
% 
%             SSHA_tide(i,j) =buoyancy_time./(9.8);
%         end
%     end
% end
% % for k = 1:btm(i,j)
% % ss(k)= t_predic(Some_time,TIDE(itide),1/TidePeriod(itide),TIDECON(k,:))
% % end
% 
% save M2_BC_tide_SSHA_Mau.mat lon lat SSHA_tide

SSHA_tide = zeros(ie,je,5);

TIDECON = zeros(ke,4);
for itide = 1:5
for i = 1:ie
    for j = 1:je
        if mask(i,j,1)~=0
            buoyancy_time(1:btm(i,j)) = 0;
            % TIDECON(:)=0;
            TIDECON(1:btm(i,j),1) = ba(i,j,1:btm(i,j),itide).*dz(i,j,1:btm(i,j));
            TIDECON(1:btm(i,j),3) = bg(i,j,1:btm(i,j),itide);

            % for k = 1:btm(i,j)
            % buoyancy_time(k) = ...
            %         t_predic(Some_time,TIDE(itide),1/TidePeriod(itide),TIDECON(k,:),lat(i,j));
            % end
            buoyancy_time=t_predic(Some_time,TIDE(itide),1/TidePeriod(itide),TIDECON(1:btm(i,j),:),lat(i,j));

            SSHA_tide(i,j,itide) =buoyancy_time./(9.8);
        end
    end
end
end

save BC_tide_SSHA_16N.mat lon lat SSHA_tide