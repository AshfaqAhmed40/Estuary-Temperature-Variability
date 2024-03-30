% This code creates a 2x4 size box where in each column in shows four tide
% stages and in each row it shows JJA and DJF

clear all; close all; clc;

%% Calling the data
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data'))
%load TEMPv3.mat
load DATE_SECTIONS.mat
load Desdet_Month_Bay_v3.mat
load SeasonalityTides.mat

%% Work with real temeprature!
SST = Desdet_Month_Bay_v3;

clear Desdet_Month_Bay_v3 LAT1 LON1

%% Summer and winter masks
summer_mask = false(size(SST, 3), 1); summer_mask(summer) = true;
winter_mask = false(size(SST, 3), 1); winter_mask(winter) = true;

%% Low, flood, high, and ebb tide masks
low_mask = false(size(SST, 3), 1); low_mask(idx_low) = true;
flood_mask = false(size(SST, 3), 1); flood_mask(idx_flood) = true;
high_mask = false(size(SST, 3), 1); high_mask(idx_high) = true;
ebb_mask = false(size(SST, 3), 1); ebb_mask(idx_ebb) = true;


%% Intersection
summer_low_mask = summer_mask & low_mask; summer_low = SST(:, :, summer_low_mask);
winter_low_mask = winter_mask & low_mask; winter_low = SST(:, :, winter_low_mask);

summer_flood_mask = summer_mask & flood_mask; summer_flood = SST(:, :, summer_flood_mask);
winter_flood_mask = winter_mask & flood_mask; winter_flood = SST(:, :, winter_flood_mask);

summer_high_mask = summer_mask & high_mask; summer_high = SST(:, :, summer_high_mask);
winter_high_mask = winter_mask & high_mask; winter_high = SST(:, :, winter_high_mask);

summer_ebb_mask = summer_mask & ebb_mask; summer_ebb = SST(:, :, summer_ebb_mask);
winter_ebb_mask = winter_mask & ebb_mask; winter_ebb = SST(:, :, winter_ebb_mask);

%% Signal to Noise Ratio (SNR)
MAP = cell(8,1);    
Count = cell(8,1);
MAP{1} = mean(summer_low,3);    Count{1} = size(summer_low,3);
MAP{2} = mean(summer_flood,3);  Count{2} = size(summer_flood,3);
MAP{3} = mean(summer_high,3);   Count{3} = size(summer_high,3);
MAP{4} = mean(summer_ebb,3);    Count{4} = size(summer_ebb,3);
MAP{5} = mean(winter_low,3);    Count{5} = size(winter_low,3);
MAP{6} = mean(winter_flood,3);  Count{6} = size(winter_flood,3);
MAP{7} = mean(winter_high,3);   Count{7} = size(winter_high,3);
MAP{8} = mean(winter_ebb,3);    Count{8} = size(winter_ebb,3);


%% Calculate SNR
SNR = cell(8,1);
logSNR = cell(8,1);

for i = 1:8
    SNR{i} = ((MAP{i}).^2).*(Count{i})./(nanstd(MAP{i}(:))).^2;
    logSNR{i} = log10(SNR{i});
end

%% Clear variables

%% Plot 2x4 graph with the JJA and DJF with the tides
% figure(1), close all;
% 
% Cmap = flip(colormap(slanCM('RdYlBu')));
% min = -2; max = 2;
% plot_style = 1
% 
% tiledlayout(2, 4, 'TileSpacing', 'tight', 'Padding', 'compact');
% nexttile
% if plot_style == 1
% pcolor(flip(mean(summer_low,3))); shading flat;
% else
% contourf(flip(mean(summer_low,3)),25,'edgecolor','none'); shading flat;
% end
% set(gca,'Color',[0.15 0.15 0.15]); colormap(gca, Cmap);
% caxis([min max]);  PLOT();
% 
% nexttile
% if plot_style == 1
% pcolor(flip(mean(summer_flood,3))); shading flat;
% else
% contourf(flip(mean(summer_flood,3)),25,'edgecolor','none'); shading flat;
% end
% set(gca,'Color',[0.15 0.15 0.15]); colormap(gca, Cmap);
% caxis([min max]);  PLOT();
% 
% nexttile
% if plot_style == 1
% pcolor(flip(mean(summer_high,3))); shading flat;
% else
% contourf(flip(mean(summer_high,3)),25,'edgecolor','none'); shading flat;
% end
% set(gca,'Color',[0.15 0.15 0.15]); colormap(gca, Cmap);
% caxis([min max]);  PLOT();
% 
% nexttile
% if plot_style == 1
% pcolor(flip(mean(summer_ebb,3))); shading flat;
% else
% contourf(flip(mean(summer_ebb,3)),25,'edgecolor','none'); shading flat; 
% end
% set(gca,'Color',[0.15 0.15 0.15]); colormap(gca, Cmap);
% caxis([min max]);  PLOT();
% 
% nexttile
% if plot_style == 1
% pcolor(flip(mean(winter_low,3))); shading flat;
% else
% contourf(flip(mean(winter_low,3)),25,'edgecolor','none'); shading flat;
% end
% set(gca,'Color',[0.15 0.15 0.15]); colormap(gca, Cmap);
% caxis([min max]);  PLOT();
% 
% nexttile
% if plot_style == 1
% pcolor(flip(mean(winter_flood,3))); shading flat;
% else
% contourf(flip(mean(winter_flood,3)),25,'edgecolor','none'); shading flat; 
% end
% set(gca,'Color',[0.15 0.15 0.15]); colormap(gca, Cmap);
% caxis([min max]);  PLOT();
% 
% nexttile
% if plot_style == 1
% pcolor(flip(mean(winter_high,3))); shading flat;
% else
% contourf(flip(mean(winter_high,3)),25,'edgecolor','none'); shading flat; 
% end
% set(gca,'Color',[0.15 0.15 0.15]); colormap(gca, Cmap);
% caxis([min max]);  PLOT();
% 
% nexttile
% if plot_style == 1
% pcolor(flip(mean(winter_ebb,3))); shading flat;
% else
% contourf(flip(mean(winter_ebb,3)),25,'edgecolor','none'); shading flat;
% end
% set(gca,'Color',[0.15 0.15 0.15]); colormap(gca, Cmap);
% caxis([min max]);  PLOT();
% 
% c = colorbar;
% c.FontSize = 35;
% c.FontWeight = 'bold';
% c.Layout.Tile = 'east';
% set(gcf, 'Position', [265,421,1103,722]);


%% Function to plot
function PLOT()
    set(gca,'Color',[0.25 0.25 0.25])
    hold on; box on;
    set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
    set(gca, 'FontSize', 25, 'FontWeight', 'bold');
    set(gca,'XTickLabel',[]);set(gca,'YTickLabel',[]);
    set(gca, 'Layer', 'top');
    set(gcf, 'Position', [265,421,1103,722]);
end