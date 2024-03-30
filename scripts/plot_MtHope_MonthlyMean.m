% this code plots monthly mean SST from the MonthlyMeanSST.mat file
% this mat file conatains detrended 1100x800x12 3D data 
% each layer contains mean SST of each month

clear all; close all; clc;

%% Call the .mat file
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data'))
load MtHopeTEMPmean_v3.mat
load MtHopeTEMPv3.mat

%% Plot
CM = (colormap(slanCM('nipy_spectral')));


%% Winter (D,J,F)
figure(1); close all;
% Create a new tiled layoutct = tiledlayout(1,3);
t = tiledlayout(4,3);
t.TileSpacing = 'tight';
t.Padding = 'compact'; 
MeanTemp = 0;

for i = [12,1,2]
    nexttile
        % Landmask
        landMask = isnan(flip(MtHopeTEMPv3mean(:,:,1)));
        contourf(gca, landMask, 5, 'edgecolor', 'none', 'FaceColor', ...
            [1 1 1]); hold on;
        C = contourc(double(landMask), [0.5 0.5]);
        while ~isempty(C)
            len = C(2, 1);
            plot(C(1, 2:1+len), C(2, 2:1+len), 'k', 'LineWidth', 1);
            C(:, 1:len+1) = []; hold on;
        end
    %pcolor(flip(TEMPv3mean(:,:,i)+MeanTemp));
    contourf(flip(MtHopeTEMPv3mean(:,:,i)),75,'edgecolor','none');
    colormap(gca,[CM]);
    PLOT();
end

% Spring (M A M)
for i = [3,4,5]
  nexttile
        % Landmask
        landMask = isnan(flip(MtHopeTEMPv3mean(:,:,1)));
        contourf(gca, landMask, 5, 'edgecolor', 'none', 'FaceColor', ...
            [1 1 1]); hold on;
        C = contourc(double(landMask), [0.5 0.5]);
        while ~isempty(C)
            len = C(2, 1);
            plot(C(1, 2:1+len), C(2, 2:1+len), 'k', 'LineWidth', 1);
            C(:, 1:len+1) = []; hold on;
        end
    %pcolor(flip(TEMPv3mean(:,:,i)+MeanTemp));
    contourf(flip(MtHopeTEMPv3mean(:,:,i)),75,'edgecolor','none');
    colormap(gca,[CM]);
    PLOT();
end


% Summer (J J A)
for i = [6,7,8]
nexttile
        % Landmask
        landMask = isnan(flip(MtHopeTEMPv3mean(:,:,1)));
        contourf(gca, landMask, 5, 'edgecolor', 'none', 'FaceColor', ...
            [1 1 1]); hold on;
        C = contourc(double(landMask), [0.5 0.5]);
        while ~isempty(C)
            len = C(2, 1);
            plot(C(1, 2:1+len), C(2, 2:1+len), 'k', 'LineWidth', 1);
            C(:, 1:len+1) = []; hold on;
        end
    %pcolor(flip(TEMPv3mean(:,:,i)+MeanTemp));
    contourf(flip(MtHopeTEMPv3mean(:,:,i)),75,'edgecolor','none');
    colormap(gca,[CM]);
    PLOT();
end


% Fall (S O N)
for i = [9,10,11]
 nexttile
        % Landmask
        landMask = isnan(flip(MtHopeTEMPv3mean(:,:,1)));
        contourf(gca, landMask, 5, 'edgecolor', 'none', 'FaceColor', ...
            [1 1 1]); hold on;
        C = contourc(double(landMask), [0.5 0.5]);
        while ~isempty(C)
            len = C(2, 1);
            plot(C(1, 2:1+len), C(2, 2:1+len), 'k', 'LineWidth', 1);
            C(:, 1:len+1) = []; hold on;
        end
    %pcolor(flip(TEMPv3mean(:,:,i)+MeanTemp));
    contourf(flip(MtHopeTEMPv3mean(:,:,i)),75,'edgecolor','none');
    colormap(gca,[CM]);
    PLOT();
end

c = colorbar;
c.FontSize = 30;
c.FontWeight = 'bold';
c.Layout.Tile = 'east';
c.Layout.Tile = 'east';
c.Label.String = '(°C)'; 
c.Label.FontWeight = 'bold';

%% Average mean for each month
clc
for i = [12,1,2,3,4,5,6,7,8,9,10,11]
   MeanSST_NB{i} = mean(squeeze(MtHopeTEMPv3mean(:,:,i)),'all','omitnan')+MeanTemp;
end
MeanSST_NB
figure(4),
clf
plot(1:12,cell2mat(MeanSST_NB),'k<','linewidth',2,'markersize',12); hold on;
plot(1:12,cell2mat(MeanSST_NB),'k-','linewidth',4,'markersize',1);
xlim([1 12]); ylim([0 25]); grid off
set(gca, 'FontSize', 15, 'FontWeight', 'bold');
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
box on; set(gca, 'GridLineStyle', '-','LineWidth', 3);
hold on; set(gca, 'Layer', 'top');
set(gca,'xtick',1:12,...
    'xticklabel',{'Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov'})
set(gcf, 'Position', [-2270,919,606,240]);

%% Histogram
[Month_Idx,YEAR] = findgroups(DateStamp.date.Month);
MONTH = arrayfun(@(x)find(x==Month_Idx), 1:max(Month_Idx), 'uni',0);
figure(5),
clf
for i = [12,1,2,3,4,5,6,7,8,9,10,11]
    ObsCount{i} = size(MONTH{i},1);
end
b = bar(1:12,cell2mat(ObsCount),0.6,'stacked','LineWidth', 2);
set(b,'FaceColor',"#4DBEEE");
set(gca, 'XTickLabel', []); ylim([0 100])
legend('Monthly Observation Count','location','northwest');
box on; 
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
set(gca, 'FontSize', 12, 'FontWeight', 'bold');
set(gcf, 'Position', [-2270,919,606,240]);
set(gca,'xtick',1:12,...
    'xticklabel',{'Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov'})
%% errorbar plotting
figure(5),
clf;
Error = [std(nanstd(MtHopeTEMPv3mean(:,:,12))), std(nanstd(MtHopeTEMPv3mean(:,:,1))),...
    std(nanstd(MtHopeTEMPv3mean(:,:,2))), std(nanstd(MtHopeTEMPv3mean(:,:,3))),...
    std(nanstd(MtHopeTEMPv3mean(:,:,4))), std(nanstd(MtHopeTEMPv3mean(:,:,5))), ...
    std(nanstd(MtHopeTEMPv3mean(:,:,6))), std(nanstd(MtHopeTEMPv3mean(:,:,7))), ...
    std(nanstd(MtHopeTEMPv3mean(:,:,8))), std(nanstd(MtHopeTEMPv3mean(:,:,9))), ...
    std(nanstd(MtHopeTEMPv3mean(:,:,10))), std(nanstd(MtHopeTEMPv3mean(:,:,11)))];

errorbar(cell2mat(MeanSST_NB), Error,"-s","MarkerSize",2,'linewidth',3,...
    "MarkerEdgeColor","blue","MarkerFaceColor",[0.65 0.85 0.90]);
set(gca, 'FontSize', 15, 'FontWeight', 'bold');
set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
box on; set(gca, 'GridLineStyle', '-','LineWidth', 3);
hold on; set(gca, 'Layer', 'top');
set(gca,'xtick',1:12,...
    'xticklabel',{'Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov'})
set(gcf, 'Position', [-2270,919,606,240]);

%% Weighted average for the seaosn
clc;
% winter
winter_average = ...
    (mean(nanmean(MtHopeTEMPv3mean(:,:,12)))*size(find(month(DateStamp.date)==12),1)+...
    mean(nanmean(MtHopeTEMPv3mean(:,:,1)))*size(find(month(DateStamp.date)==1),1)+...
    mean(nanmean(MtHopeTEMPv3mean(:,:,2)))*size(find(month(DateStamp.date)==2),1))./...
    (size(find(month(DateStamp.date)==12),1)+size(find(month(DateStamp.date)==1),1)+...
    size(find(month(DateStamp.date)==2),1))

spring_average = ...
    (mean(nanmean(MtHopeTEMPv3mean(:,:,3)))*size(find(month(DateStamp.date)==3),1)+...
    mean(nanmean(MtHopeTEMPv3mean(:,:,4)))*size(find(month(DateStamp.date)==4),1)+...
    mean(nanmean(MtHopeTEMPv3mean(:,:,5)))*size(find(month(DateStamp.date)==5),1))./...
    (size(find(month(DateStamp.date)==3),1)+size(find(month(DateStamp.date)==4),1)+...
    size(find(month(DateStamp.date)==5),1))

summer_average = ...
    (mean(nanmean(MtHopeTEMPv3mean(:,:,6)))*size(find(month(DateStamp.date)==6),1)+...
    mean(nanmean(MtHopeTEMPv3mean(:,:,7)))*size(find(month(DateStamp.date)==7),1)+...
    mean(nanmean(MtHopeTEMPv3mean(:,:,8)))*size(find(month(DateStamp.date)==8),1))./...
    (size(find(month(DateStamp.date)==6),1)+size(find(month(DateStamp.date)==7),1)+...
    size(find(month(DateStamp.date)==8),1))

fall_average = ...
    (mean(nanmean(MtHopeTEMPv3mean(:,:,9)))*size(find(month(DateStamp.date)==9),1)+...
    mean(nanmean(MtHopeTEMPv3mean(:,:,10)))*size(find(month(DateStamp.date)==10),1)+...
    mean(nanmean(MtHopeTEMPv3mean(:,:,11)))*size(find(month(DateStamp.date)==11),1))./...
    (size(find(month(DateStamp.date)==9),1)+size(find(month(DateStamp.date)==10),1)+...
    size(find(month(DateStamp.date)==11),1))

    
%% Function to plot
function PLOT()
    shading interp;
    set(gca,'Color',[192 192 192]/255)
    caxis([2.5 25]); 
    set(gca, 'FontSize', 25, 'FontWeight', 'bold');
    set(gcf, 'Position', [-2139,137,742,1063]); 
    set(gca, 'FontSize', 15, 'FontWeight', 'bold');
    set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
    box on; set(gca, 'GridLineStyle', '-','LineWidth', 3);
    hold on; set(gca, 'Layer', 'top');
    set(gca,'XTickLabel',[]); set(gca,'YTickLabel',[]);
end
