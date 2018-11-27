% script to import Argo data provided in CSV format for a certain number of months 
% from an initial time t=0. Accompanying Python file prepares the Argo
% netcdf data in this csv format

addpath('..\data');
addpath('..\dyn_lap');

nt = 36; % nt is the number of time steps (months)  

%% import data
% data in csv format - 
A = importdata('argo2015_36mnth_flow.dat', ',', 1);
A.textdata
B = A.data;
for k=2:nt+1
    [uniqueA, ind, j] = unique(A.data(:, 2*k:2*k+1), 'rows');
    indexToDupes = find(not(ismember(1:numel(A.data(:, 2*k)),ind)));
    indexToDupes = indexToDupes(:);
    B(indexToDupes, 2*k:2*k+1) = NaN;
end

%% make p
% to be used in calculation
p = {};
for i = 2:nt+1
%     p{i} = A.data(:, [2*i 2*i+1]);
    p{i-1} = B(:, [2*i 2*i+1]);
end

%% set nans equal

for k=1:nt
    nancol1 = find(isnan(p{k}(:, 1)));
    nancol2 = find(isnan(p{k}(:, 2)));
    p{k}(setdiff(nancol1, nancol2), :) = NaN;
end

%% plot world maps
worldmap world;
plotm(p{nt}(:,2), p{nt}(:,1), '.')

fprintf('yomaha data t=1: %d points\n', sum(~isnan(p{1}(:,1))))