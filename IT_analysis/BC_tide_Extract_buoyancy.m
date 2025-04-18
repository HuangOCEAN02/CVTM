clear;clc;close all
load('res_bbc_level1_CV.mat')
%% Model GRID & background stratification 
addpath ../Model_info/
load('Grid_info.mat','ke','depto_grid','weto_p','latp_grid','lonp_grid','zzout');

iw = 30;ie = 1;
jn = 30;js = 30;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
latp_grid = Exclude_sponge(iw,ie,jn,js,latp_grid);
zzout = Exclude_sponge(iw,ie,jn,js,zzout);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
r0 = 1025;
itide = 4; % M2
ba_bc = reshape(ba_bc,[ie,je,ke,5]);
bg_bc = reshape(bg_bc,[ie,je,ke,5]);

% M2
ba = ba_bc(:,:,:,itide);
bg = bg_bc(:,:,:,itide);

save M2_BC_tide_buoyancy.mat ba bg
%

itide = 3; % N2
ba = ba_bc(:,:,:,itide);
bg = bg_bc(:,:,:,itide);
save N2_BC_tide_buoyancy.mat ba bg

%
itide = 5; % S2
ba = ba_bc(:,:,:,itide);
bg = bg_bc(:,:,:,itide); 
save S2_BC_tide_buoyancy.mat ba bg