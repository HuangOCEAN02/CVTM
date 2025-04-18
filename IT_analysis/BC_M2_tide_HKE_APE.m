clear;clc;close all
addpath ../Model_info/
load('M2_BC_tide_velocity.mat')
load('M2_BC_tide_buoyancy.mat')
% load('Average_stratification.mat', 'Nsq')
load('CVTM_CV_summer.mat','N2_summer','z','Depth');
Nsq = interp1(z,N2_summer,Depth);
Nsq(end)=Nsq(end-1);
%%
load('Grid_info.mat','ke','weto_p','depto_grid','ddpo_grid','zzout','bottom_index');
load('Grid_info_u.mat','weto_u','latu_grid','lonu_grid');
load('Grid_info_v.mat','weto_v','latv_grid','lonv_grid');

iw = 30;ie = 1;
jn = 30;js = 30;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
ddpo_grid = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
zzout = Exclude_sponge(iw,ie,jn,js,zzout);
bottom_index =  Exclude_sponge(iw,ie,jn,js,bottom_index);

weto_u  = Exclude_sponge(iw,ie,jn,js,weto_u);
weto_v  = Exclude_sponge(iw,ie,jn,js,weto_v);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);

ie = size(depto_grid,1);
je = size(depto_grid,2);

r0 = 1025;
HKE_tide = zeros(ie,je,ke);
APE_tide = zeros(ie,je,ke);
HKE_tide_500= zeros(ie,je,10);
APE_tide_500= zeros(ie,je,10);
% NsqNsq = zeros(ie,je,ke);
% 
% 
% for i =1:ie
%    for j = 1:je
%        if (weto_p(i,j,1) ~= 0)
%          clear zm N_sb
%         zm(:) = zzout(i,j,1:bottom_index(i,j));
%         [~,N_sb] = modify_N2(depto_grid(i,j),zm,N2_summer,z);
%         NsqNsq(i,j,1:bottom_index(i,j))= N_sb(2:end-1);
%        end
%    end
% end
% 
% NsqNsq = NsqNsq.*weto_p;
% NsqNsq = Nsq;
% NsqNsq = NsqNsq.*weto_p;

HKE_h = zeros(ie,je);
APE_h = zeros(ie,je);
HKE_500m = zeros(ie,je);
APE_500m = zeros(ie,je);


for k = 1 : ke
   HKE_tide(:,:,k)  = (r0/4).* ...
       ( ((ua(1:1:end-1,:,k)+ua(2:1:end,:,k))/2).^2 + ...
         ((va(:,1:1:end-1,k)+va(:,2:1:end,k))/2).^2); % J/m^3
   % APE_tide(:,:,k)  = (r0/4).* ...
   %     (ba(:,:,k).^2)./ NsqNsq(:,:,k); % J/m^3
      APE_tide(:,:,k)  = (r0/4).* ...
       (ba(:,:,k).^2)./ Nsq(k); % J/m^3
end

for k = 1 : 10
   HKE_tide_500(:,:,k)  = (r0/4).* ...
       ( ((ua(1:1:end-1,:,k)+ua(2:1:end,:,k))/2).^2 + ...
         ((va(:,1:1:end-1,k)+va(:,2:1:end,k))/2).^2); % J/m^3
   APE_tide_500(:,:,k)  = (r0/4).* ...
       (ba(:,:,k).^2)./ Nsq(k); % J/m^3

end

APE_tide(weto_p==0)=0;

% APE_tide(NsqNsq<=5e-5)=0;

% vertical intergration
HKE_h = ((sum(HKE_tide.*ddpo_grid,3))./depto_grid);
APE_h = ((sum(APE_tide.*ddpo_grid,3))./depto_grid);

HKE_500m = (sum(HKE_tide_500.*ddpo_grid(:,:,1:10),3));
APE_500m = (sum(APE_tide_500.*ddpo_grid(:,:,1:10),3));

save ./M2_tide/M2_HKE_APE.mat HKE_tide APE_tide HKE_h APE_h HKE_500m APE_500m