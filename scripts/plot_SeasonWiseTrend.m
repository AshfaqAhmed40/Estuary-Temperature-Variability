close all;clear all;clc;

%% Home
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data'))
load TEMPv3.mat


%% sections
SST1 = TEMPv3(1:790,:,:); % upper bay
SST2 = TEMPv3(791:end,:,:); % lower bay

clear TEMPv3

%% section by seasons
% Convert the string dates to datetime format
dateObjects = datetime(DateStamp.date, 'InputFormat', 'yyyy-MM-dd');

% Initialize cell arrays for each season
year_W = cell(1, 39);  % Winter
year_Sp = cell(1, 39); % Spring
year_Sm = cell(1, 39); % Summer
year_F = cell(1, 39);  % Fall

% Define the range of years
years = 1984:2022;

% Loop through each year and each date to sort them into the correct season and year
for i = 1:numel(years)
    year = years(i);
    % Find indices for each season
    winterIdx = find(isbetween(dateObjects, datetime([year-1, 12, 1]), datetime([year, 2, 28])));
    springIdx = find(isbetween(dateObjects, datetime([year, 3, 1]), datetime([year, 5, 31])));
    summerIdx = find(isbetween(dateObjects, datetime([year, 6, 1]), datetime([year, 8, 31])));
    fallIdx = find(isbetween(dateObjects, datetime([year, 9, 1]), datetime([year, 11, 30])));
    
    % Assign indices to the corresponding cell for the year
    year_W{i} = winterIdx;
    year_Sp{i} = springIdx;
    year_Sm{i} = summerIdx;
    year_F{i} = fallIdx;
end

% The cell arrays year_W, year_Sp, year_Sm, and year_F now contain the indices
% of the dates for each season for each year from 1984 to 2022.
clear fallIdx summerIdx winterIdx springIdx year i dateObjects

%% upper bay all season yearly TEMPv3
SST1_W = zeros(1, 39);
SST1_Sp = zeros(1, 39);
SST1_Sm = zeros(1, 39);
SST1_F = zeros(1, 39);
for i = 1:39
    winter_indices = year_W{i};  % Get the indices for the winter of year i
    SST1_W(i) = nanmean(SST1(:, :, winter_indices), 'all'); 
    spring_indices = year_Sp{i};  % Get the indices for the winter of year i
    SST1_Sp(i) = nanmean(SST1(:, :, spring_indices), 'all'); 
    summer_indices = year_Sm{i};  % Get the indices for the winter of year i
    SST1_Sm(i) = nanmean(SST1(:, :, summer_indices), 'all'); 
    fall_indices = year_F{i};  % Get the indices for the winter of year i
    SST1_F(i) = nanmean(SST1(:, :, fall_indices), 'all'); 
end

clear winter_indices spring_indices summer_indices fall_indices plot

%% plot the upper bay
close all;
years = 1984:2022;

plot(years,SST1_W,'color','#0072BD','markersize',15,'linewidth',8); hold on
plot(years,SST1_W,'k*--','markersize',6,'linewidth',1.5); 
hold on

plot(years,SST1_Sp,'color','#77AC30','markersize',15,'linewidth',8); hold on
plot(years,SST1_Sp,'k*--','markersize',6,'linewidth',1.5);  
hold on

plot(years,SST1_Sm,'color','#D95319','markersize',15,'linewidth',8); hold on
plot(years,SST1_Sm,'k*--','markersize',6,'linewidth',1.5);  
hold on

plot(years,SST1_F,'color','#EDB120','markersize',15,'linewidth',8); hold on
plot(years,SST1_F,'k*--','markersize',6,'linewidth',1.5);  
hold on

set(gca, 'XTickLabel'); set(gca, 'YTickLabel'); 
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 25, 'FontWeight', 'bold');
set(gca, 'Layer', 'top'); 
xlim([1980 2030]); ylim([-10 35])

set(gcf, 'Position', [-2509,380,2028,850]);

%% lower bay all season yearly TEMPv3
SST2_W = zeros(1, 39);
SST2_Sp = zeros(1, 39);
SST2_Sm = zeros(1, 39);
SST2_F = zeros(1, 39);
for i = 1:39
    winter_indices = year_W{i};  % Get the indices for the winter of year i
    SST2_W(i) = nanmean(SST2(:, :, winter_indices), 'all'); 
    spring_indices = year_Sp{i};  % Get the indices for the winter of year i
    SST2_Sp(i) = nanmean(SST2(:, :, spring_indices), 'all'); 
    summer_indices = year_Sm{i};  % Get the indices for the winter of year i
    SST2_Sm(i) = nanmean(SST2(:, :, summer_indices), 'all'); 
    fall_indices = year_F{i};  % Get the indices for the winter of year i
    SST2_F(i) = nanmean(SST2(:, :, fall_indices), 'all'); 
end

clear winter_indices spring_indices summer_indices fall_indices

%% plot the lower bay
plot(years,SST2_W,'b^--','markersize',16,'linewidth',2); 
hold on
plot(years,SST2_Sp,'color','#77AC30','marker','^','linestyle','--','markersize',16,'linewidth',2); 
hold on
plot(years,SST2_Sm,'r^--','markersize',16,'linewidth',2); 
hold on
plot(years,SST2_F,'color','#EDB120','marker','^','linestyle','--','markersize',16,'linewidth',2); 
hold on
set(gca, 'XTickLabel'); set(gca, 'YTickLabel'); 
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 25, 'FontWeight', 'bold');
set(gca, 'Layer', 'top');
set(gcf, 'Position', [-2509,380,2028,850]);

%% load the Mt. Hope Bay
load MtHopeTEMPv3.mat
SST3 = MtHopeTEMPv3;
clear MtHopeTEMPv3
%% Mt. Hope Bay all season yearly TEMPv3
SST3_W = zeros(1, 39);
SST3_Sp = zeros(1, 39);
SST3_Sm = zeros(1, 39);
SST3_F = zeros(1, 39);
for i = 1:39
    winter_indices = year_W{i};  % Get the indices for the winter of year i
    SST3_W(i) = nanmean(SST3(:, :, winter_indices), 'all'); 
    spring_indices = year_Sp{i};  % Get the indices for the winter of year i
    SST3_Sp(i) = nanmean(SST3(:, :, spring_indices), 'all'); 
    summer_indices = year_Sm{i};  % Get the indices for the winter of year i
    SST3_Sm(i) = nanmean(SST3(:, :, summer_indices), 'all'); 
    fall_indices = year_F{i};  % Get the indices for the winter of year i
    SST3_F(i) = nanmean(SST3(:, :, fall_indices), 'all'); 
end

clear winter_indices spring_indices summer_indices fall_indices

%% plot the Mt. Hope bay
plot(years,SST3_W,'bp-.','markersize',16,'linewidth',2); 
hold on
plot(years,SST3_Sp,'color','#77AC30','marker','p','linestyle','-.','markersize',16,'linewidth',2); 
hold on
plot(years,SST3_Sm,'rp-.','markersize',16,'linewidth',2); 
hold on
plot(years,SST3_F,'color','#EDB120','marker','p','linestyle','-.','markersize',16,'linewidth',2); 
hold on
set(gca, 'XTickLabel'); set(gca, 'YTickLabel'); 
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 25, 'FontWeight', 'bold');
set(gca, 'Layer', 'top');
xlim([1984 2025]); ylim([-5 30]);

% set(gcf, 'Position', [-4973,-223,1049,716]); % for paper
set(gcf, 'Position', [-2509,380,2028,850]);

