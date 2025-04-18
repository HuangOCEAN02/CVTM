clear;clc;close all
addpath ../Model_info/
load('res_uko_level1_CV.mat');
load('res_vke_level1_CV.mat');
%% Model GRID & background stratification 
load('Grid_info.mat','ke','depto_grid');
load('Grid_info_u.mat','weto_u','latu_grid','lonu_grid');
load('Grid_info_v.mat','weto_v','latv_grid','lonv_grid');

iw = 30;ie = 1;
jn = 30;js = 30;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_u  = Exclude_sponge(iw,ie,jn,js,weto_u);
weto_v  = Exclude_sponge(iw,ie,jn,js,weto_v);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
r0 = 1025;

HKE_tide = zeros(ie,je,ke);
APE_tide = zeros(ie,je,ke);

ua_bc = reshape(ua_bc,[ie+1,je,ke,5]);
ug_bc = reshape(ug_bc,[ie+1,je,ke,5]);
va_bc = reshape(va_bc,[ie,je+1,ke,5]);
vg_bc = reshape(vg_bc,[ie,je+1,ke,5]);

%
itide = 4; % M2
ua = ua_bc(:,:,:,itide);
ug = ug_bc(:,:,:,itide);
va = va_bc(:,:,:,itide);
vg = vg_bc(:,:,:,itide); 
save M2_BC_tide_velocity.mat ua ug va vg

itide = 3; % N2
ua = ua_bc(:,:,:,itide);
ug = ug_bc(:,:,:,itide);
va = va_bc(:,:,:,itide);
vg = vg_bc(:,:,:,itide); 
save N2_BC_tide_velocity.mat ua ug va vg

%
itide = 5; % S2
ua = ua_bc(:,:,:,itide);
ug = ug_bc(:,:,:,itide);
va = va_bc(:,:,:,itide);
vg = vg_bc(:,:,:,itide); 
save S2_BC_tide_velocity.mat ua ug va vg

itide = 2; % K1
ua = ua_bc(:,:,:,itide);
ug = ug_bc(:,:,:,itide);
va = va_bc(:,:,:,itide);
vg = vg_bc(:,:,:,itide); 
save K1_BC_tide_velocity.mat ua ug va vg

itide = 1; % O1
ua = ua_bc(:,:,:,itide);
ug = ug_bc(:,:,:,itide);
va = va_bc(:,:,:,itide);
vg = vg_bc(:,:,:,itide); 
save O1_BC_tide_velocity.mat ua ug va vg