clear;clc;close all
load('res_pbc_level1_CV.mat')
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

pa_bc = reshape(pa_bc,[ie,je,ke+1,5]);
pg_bc = reshape(pg_bc,[ie,je,ke+1,5]);

% M2
% g = sw_g(latp_grid,zzout);
% ba = -g.*ra_bc(:,:,:,itide)./r0;
% bg = rg_bc(:,:,:,itide);

pa = pa_bc(:,:,:,itide);
pg = pg_bc(:,:,:,itide); 


pa = reshape(pa,[ie*je,ke+1]);
weto_p =  reshape(weto_p,[ie*je,ke]);
zzout =  reshape(zzout,[ie*je,ke]);


save M2_BC_tide_pressure_new.mat ra rg pa pg


