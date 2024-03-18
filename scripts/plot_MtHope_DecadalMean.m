% want to plot the evolution of the seasonal SST
clear all; close all; clc;
tic
%% HOME
%loading file
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data'))
load MtHopeTEMPv3.mat
load SeasonalityTides.mat

%% Customize DateStamp to categorize the months
dates = datetime(DateStamp.date);
months = month(dates);
Jan = find(months == 1);
Feb = find(months == 2);
Mar = find(months == 3);
Apr = find(months == 4);
May = find(months == 5);
Jun = find(months == 6);
Jul = find(months == 7);
Aug = find(months == 8);
Sep = find(months == 9);
Oct = find(months == 10);
Nov = find(months == 11);
Dec = find(months == 12);

%% Remove monthly mean from the 764 scenes
% for k = 1:size(MtHopeTEMP, 3)
%     currentSlice = MtHopeTEMP(:,:,k);
%     
%     % Compute the mean of the current slice ignoring NaN values
%     sliceMean = nanmean(currentSlice(:));
%     
%     % Subtract the mean from the current slice
%     SST(:,:,k) = currentSlice - sliceMean;
% end
SST = MtHopeTEMPv3;
clear MtHopeTEMPv3

%% Prepare monthly mean with the help of index
Season{1} = mean(SST(:,:,winter),3);
Season{2} = mean(SST(:,:,spring),3);
Season{3} = mean(SST(:,:,summer),3);
Season{4} = mean(SST(:,:,fall),3);

Decade = {[1:71],[72:213],[214:463],[464:764]};
% just sorting
winter = sort(winter);
spring = sort(spring);
summer = sort(summer);
fall = sort(fall);


%% Categorize all winter
WINTER{1} = intersect(Decade{1},winter); %winter (1984-1990)
WINTER{2} = intersect(Decade{2},winter); %winter (1991-2000)
WINTER{3} = intersect(Decade{3},winter); %winter (2001-2010)
WINTER{4} = intersect(Decade{4},winter); %winter (2010-2022)


%% Categorize all spring
SPRING{1} = intersect(Decade{1},spring); %spring (1984-1990)
SPRING{2} = intersect(Decade{2},spring); %spring (1991-2000)
SPRING{3} = intersect(Decade{3},spring); %spring (2001-2010)
SPRING{4} = intersect(Decade{4},spring); %spring (2010-2022)


%% Categorize all summer
SUMMER{1} = intersect(Decade{1},summer); %summer (1984-1990)
SUMMER{2} = intersect(Decade{2},summer); %summer (1991-2000)
SUMMER{3} = intersect(Decade{3},summer); %summer (2001-2010)
SUMMER{4} = intersect(Decade{4},summer); %summer (2010-2022)


%% Categorize all fall
FALL{1} = intersect(Decade{1},fall); %fall (1984-1990)
FALL{2} = intersect(Decade{2},fall); %fall (1991-2000)
FALL{3} = intersect(Decade{3},fall); %fall (2001-2010)
FALL{4} = intersect(Decade{4},fall); %fall (2010-2022)


%% Plot each season's climatology
close all;
clr1= brewermap(15,'RdYlBu');
clri1=interp1(1:1:15,clr1,1:0.25:15,'linear');
clri1 = flip(clri1);
clf; 

%% Plot WINTER climatology
fig=figure(1);
t = tiledlayout(1,4);
t.TileSpacing = 'tight';t.Padding = 'compact';
contourHandles = gobjects(4, 1);
for i = 1:size(Decade,2)
    nexttile
    contourf(flip(mean(SST(:,:,WINTER{i}),3))-mean(mean(nanmean(SST(:,:,WINTER{1})))),linspace(-3,3,16),'edgecolor','none');  
    colormap(gca,[clri1]); shading interp;
    caxis([-3 3]); box on;
    PLOT()
end
% Set colorbar properties
c = colorbar;
c.FontSize = 20;
c.FontWeight = 'bold';
c.Layout.Tile = 'east';
%c.Ticks = [14 15 16 17]; % Manually setting round numbers

%% Plot SPRING climatology
fig=figure(2);
t = tiledlayout(1,4);
t.TileSpacing = 'tight';t.Padding = 'compact';
contourHandles = gobjects(4, 1);
for i = 1:size(Decade,2)
    nexttile
    pcolor(flip(mean(SST(:,:,SPRING{i}),3))-mean(mean(nanmean(SST(:,:,SPRING{1})))));  
    colormap(gca,[clri1]); shading interp;
    caxis([-3 3]); box on;
    PLOT()
end
% Set colorbar properties
c = colorbar;
c.FontSize = 20;
c.FontWeight = 'bold';
c.Layout.Tile = 'east';
%c.Ticks = [14 15 16 17]; % Manually setting round numbers

%% Plot SUMMER climatology
fig=figure(3);
t = tiledlayout(1,4);
t.TileSpacing = 'tight';t.Padding = 'compact';
contourHandles = gobjects(4, 1);
for i = 1:size(Decade,2)
    nexttile
    pcolor(flip(mean(SST(:,:,SUMMER{i}),3))-mean(mean(nanmean(SST(:,:,SUMMER{1}))))); 
    colormap(gca,[clri1]); shading interp;
    caxis([-3 3]); box on;
    PLOT()
end
% Set colorbar properties
c = colorbar;
c.FontSize = 20;
c.FontWeight = 'bold';
c.Layout.Tile = 'east';
%c.Ticks = [14 15 16 17]; % Manually setting round numbers

%% Plot FALL climatology
fig=figure(4);
t = tiledlayout(1,4);
t.TileSpacing = 'tight';t.Padding = 'compact';
contourHandles = gobjects(4, 1);
for i = 1:size(Decade,2)
    nexttile
    pcolor(flip(mean(SST(:,:,FALL{i}),3))-mean(mean(nanmean(SST(:,:,FALL{1})))));  
    colormap(gca,[clri1]); shading interp;
    caxis([-3 3]); box on;
    PLOT()
end
% Set colorbar properties
c = colorbar;
c.FontSize = 20;
c.FontWeight = 'bold';
c.Layout.Tile = 'east';
%c.Ticks = [14 15 16 17]; % Manually setting round numbers

%% Sampling uncertainty
clc;
% Winter
W1 = std(mean(mean(SST(:,:,WINTER{1,1}),'omitnan')))./sqrt(size(WINTER{1,1},1))
W2 = std(mean(mean(SST(:,:,WINTER{1,2}),'omitnan')))./sqrt(size(WINTER{1,2},1))
W3 = std(mean(mean(SST(:,:,WINTER{1,3}),'omitnan')))./sqrt(size(WINTER{1,3},1))
W4 = std(mean(mean(SST(:,:,WINTER{1,4}),'omitnan')))./sqrt(size(WINTER{1,4},1))

% Spring
Sp1 = std(mean(mean(SST(:,:,SPRING{1,1}),'omitnan')))./sqrt(size(SPRING{1,1},1))
Sp2 = std(mean(mean(SST(:,:,SPRING{1,2}),'omitnan')))./sqrt(size(SPRING{1,2},1))
Sp3 = std(mean(mean(SST(:,:,SPRING{1,3}),'omitnan')))./sqrt(size(SPRING{1,3},1))
Sp4 = std(mean(mean(SST(:,:,SPRING{1,4}),'omitnan')))./sqrt(size(SPRING{1,4},1))

% Summer
Sm1 = std(mean(mean(SST(:,:,SUMMER{1,1}),'omitnan')))./sqrt(size(SUMMER{1,1},1))
Sm2 = std(mean(mean(SST(:,:,SUMMER{1,2}),'omitnan')))./sqrt(size(SUMMER{1,2},1))
Sm3 = std(mean(mean(SST(:,:,SUMMER{1,3}),'omitnan')))./sqrt(size(SUMMER{1,3},1))
Sm4 = std(mean(mean(SST(:,:,SUMMER{1,4}),'omitnan')))./sqrt(size(SUMMER{1,4},1))

% Fall
F1 = std(mean(mean(SST(:,:,FALL{1,1}),'omitnan')))./sqrt(size(FALL{1,1},1))
F2 = std(mean(mean(SST(:,:,FALL{1,2}),'omitnan')))./sqrt(size(FALL{1,2},1))
F3 = std(mean(mean(SST(:,:,FALL{1,3}),'omitnan')))./sqrt(size(FALL{1,3},1))
F4 = std(mean(mean(SST(:,:,FALL{1,4}),'omitnan')))./sqrt(size(FALL{1,4},1))



clc;

Winter_Uncertainty = [W1;W2;W3;W4]
Spring_Uncertainty = [Sp1;Sp2;Sp3;Sp4]
Summer_Uncertainty = [Sm1;Sm2;Sm3;Sm4]
Fall_Uncertainty = [F1;F2;F3;F4]

%% Function to plot
function PLOT()
    set(gca,'Color',[0.15 0.15 0.15])
    hold on; box on;
    set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
    set(gca, 'FontSize', 15, 'FontWeight', 'bold');
    set(gca,'XTickLabel',[]);set(gca,'YTickLabel',[]);
    set(gca, 'Layer', 'top');
    set(gcf, 'Position', [-1776,735,1174,405]);
end