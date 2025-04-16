close all;clc;clear;
tic
ttide = 1;     % whether use the t_tide.
para  = 1;     % whether use the parallel.
maxNumCompThreads = 32;
if para == 1
   parpool ('local',maxNumCompThreads)
end
ie = 817; je = 619; 
spongee = 0;
spongew = 30;
spongen = 30;
sponges = 30;
S_time=datenum([2011 7 01 0 0 0]);
E_time=datenum([2011,8,31,23,0,0]);
detaT=1/24;
SDtime=[S_time:detaT:E_time];
time = datestr(SDtime);
te = size(SDtime,2);
%% GRID INFO

lono  = double(ncread('../GRID_INFO.nc','var111'));           
lato  = double(ncread('../GRID_INFO.nc','var121'));
masko = double(ncread('../GRID_INFO.nc','var301',[1 1],[(ie+1)*je 1])); 


lono = reshape(lono,[ie+1,je]);
lato = reshape(lato,[ie+1,je]);
masko = reshape(masko,[ie+1,je]);

lono([1:spongew],:)=[];
lato([1:spongew],:)=[];
masko([1:spongew],:)=[];

lono(:,[1:spongen,end-sponges+1:end])=[];
lato(:,[1:spongen,end-sponges+1:end])=[];
masko(:,[1:spongen,end-sponges+1:end])=[];
%% DATA Read 
% the first 5 days exluded
ts = 745;
tee = length([ts:te]); % New length of data to be analyzed
uuu_time = zeros(ie+1,je,tee);

Location = ['../'];
dt = 60;
Time_output = 3600;
LDTRUN = [0:Time_output/dt:(te-1)*Time_output/dt]; % Output Time Step Numbers 

for t= ts:1:te
    if (LDTRUN(t)<10)
        name = [Location,'uso/USO_0000000',num2str(LDTRUN(t)),'.nc'];
     else if(LDTRUN(t) < 100)
        name = [Location,'uso/USO_000000',num2str(LDTRUN(t)),'.nc'];
       else if(LDTRUN(t) < 1000)
           name = [Location,'uso/USO_00000',num2str(LDTRUN(t)),'.nc'];
        else if(LDTRUN(t) < 10000)
           name = [Location,'uso/USO_0000',num2str(LDTRUN(t)),'.nc'];
          else if(LDTRUN(t) < 100000)
           name = [Location,'uso/USO_000',num2str(LDTRUN(t)),'.nc'];
          else if(LDTRUN(t) < 1000000)
           name = [Location,'uso/USO_00',num2str(LDTRUN(t)),'.nc'];
          end
          end
        end
      end
     end
    end
    uuu_time(:,:,t-ts+1) = double(squeeze(ncread(name,'USO')));
end
% Extract the interior
uuu_time([1:spongew],:,:)=[];
uuu_time(:,[1:spongen,end-sponges+1:end],:)=[];

ie = ie - spongee - spongew;
je = je - sponges - spongen;

uuu = zeros(ie+1,je,tee);
uuu(:,:,:) = uuu_time;
clear uuu_time

uuu  = reshape(uuu,[(ie+1)*je,tee]);
lono = reshape(lono,[(ie+1)*je,1]);
lato = reshape(lato,[(ie+1)*je,1]);
masko = reshape(masko,[(ie+1)*je,1]);

uuu_tide = uuu;

%%
disp(['Length of the time seires: ',num2str(size(uuu_tide,2))])
disp(['Numbers of the model grid: ',num2str(size(uuu_tide,1))])
if ttide == 1
    disp(['!!! ATTENTION --> using t_tide']);
    addpath /gxfs_home/geomar/smomw557/Model_H2/t_tide_v1.3beta
    tide_names = ['O1';'K1';'M2';'S2';'Q1';'P1';'N2';'K2'];
%   t_order = [6,8,15,17,5,nan,14,nan];  %the ID, the 35 tide    
    t_order = [4,6,11,12];  %the ID , the 29 tide   
    start_time = [2011,8,1,0,0,0];
    % from outside loop.
    amph=zeros([(ie+1)*je 5]);gphh=zeros([(ie+1)*je 5]);res=zeros([4 5]);
parfor i = 1:((ie+1)*je)
    s = uuu_tide(i,:);
    if (masko(i)~=0)  % masko(ij) == 0
        [~,~,res]=t_tide(s,'start time',start_time,'latitude',lato(i),...
            'output','none','rayleigh',['M2';'S2';'K1';'O1';'N2']);
        amph(i,:)=res(:,1); %the first line is amplitude
        gphh(i,:)=res(:,3); %the third line is lag angle
    end
    disp(['the current processing Num of uuu: ',num2str(i)]); 
end
save('res_uso_level1_CV.mat','-v7.3','amph','gphh','lono','lato','masko','tide_names','t_order');
clearvars -except uuu lono lato masko

t1 = toc;
disp(['Using t_tide, the time passes by: ',num2str(t1),' s']);
end

delete(gcp('nocreate'))

