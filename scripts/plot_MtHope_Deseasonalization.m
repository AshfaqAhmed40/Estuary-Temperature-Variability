clear all;close all; clc;

%% all data
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat(HOME,'data'));
load MtHopeTEMPv3.mat

% Flag to see if figures will be drawn
drawing=0;

%% Massage the dates into a more meaningful measure--
% just take the date column
datestring=string(table2cell(DateStamp(:,1)));

% split the datestring into year-month-day-hour-minute-second
datevector=datevec(datestring);

% All of the observations are at 10AM
datevector(:,4)=10;

% create a datetime column in 02-May-1984 10:00:00 format
datet=datetime(datevector);

% 122 days between 01-Jan-1984 00:00:00 to 02-May-1984 10:00:00
% day_gap = 122;
day_gap = days(datet(1)-datetime([1984,1,1,10,0,0])); 

% 1984 is a leap year, and we actually start our count from year 1984.333
y0=year(datet(1))+(day_gap)/366; 

% difference of hours since 02-May-1984 (y0) till the last date 29-Sep-2022
dur_hour = hours(datet-datet(1));

% difference of year since y0
dur=hours(datet-datet(1))/24/365.2425; 

% This is time in a suitable form for calculating frequencies 
% (i.e., accounting for leap years)
% as we have the starting time, and a suitable year gap, we can create a
% synthetic time column to later use for calculating frequencies
t=y0+dur; 

clear day_gap dur_hour

%% Fit a sinusoid (pointwise) and linear trend (globally, to annual mean)
MtHopeTEMPv3m=nan*zeros(size(MtHopeTEMPv3(:,:,1:39)));

%% Make Annual Means
for yy=1984:2022
   ndx=find(yy==year(datet));
   tm(yy-1983)=mean(t(ndx));
   MtHopeTEMPv3m(:,:,yy-1983)=mean(MtHopeTEMPv3(:,:,ndx),3);
end
% MtHopeTEMPv3m = composite of every year's mean MtHopeTEMPv3erature
% t = 764x1 size. 
% tm = 39x1 size, mean of t for any given year 

%% Plot Annual Means
if drawing==1
for yy=1984:2022
  figure(3)
  pcolor(LON2,LAT2,flip(MtHopeTEMPv3m(:,:,yy-1983)));shading('flat');
  caxis([10 15])
  colorbar
  drawnow
end
end

%% Find the non-nan locations
% ii = all rows that has SST values
% jj = all columns that has SST values
[ii,jj]=find(~isnan(MtHopeTEMPv3(:,:,1)));

polyparams=nan*zeros(size(MtHopeTEMPv3(:,:,1:2)));
MtHopeTEMPv3det=nan*MtHopeTEMPv3;

% Fit and plot the annual means
for ll=1:length(ii)
   
   % Polynomial fit to extract mean and trend.  
   % Use mean(t) as the midpoint.
   [p,S]=polyfit(tm(:)-mean(t),squeeze(MtHopeTEMPv3m(ii(ll),jj(ll),:)),1);
   [ym,DELTA] = polyval(p,tm-mean(t),S);  % Predict annual mean trend values
   [y,DELTA] = polyval(p,t-mean(t),S);  % Predict trend values on every scene
   %plot(tm,squeeze(MtHopeTEMPv3m(ii(ll),jj(ll),:)),'o:',tm,ym-2*DELTA,'r--',tm,ym+2*DELTA,'r--',tm,ym,'r-');
   
   % Save the linear fits!
   polyparams(ii(ll),jj(ll),1)=p(1);  
   polyparams(ii(ll),jj(ll),2)=p(2);
   
   % Detrend the data
   MtHopeTEMPv3det(ii(ll),jj(ll),:)=squeeze(MtHopeTEMPv3(ii(ll),jj(ll),:))-y;
   
   if floor(100*ll./length(ii))==100*ll./length(ii)
       100*ll./length(ii)
   end
   if drawing==1
     figure(2)
     plot(tm,squeeze(MtHopeTEMPv3m(ii(ll),jj(ll),:)),'o:',tm,ym-2*DELTA,'r--',tm,ym+2*DELTA,'r--',tm,ym,'r-');
     %plot(t,squeeze(MtHopeTEMPv3det(ii(ll),jj(ll),:)),'.')
     title(sprintf('pixel %d',ll))
     drawnow
  
   end
   
   slope(ll,1) = p(1);
   intercept(ll,1) = p(2);
end

MtHopeTEMPv3avg=polyparams(:,:,2);
MtHopeTEMPv3trnd=polyparams(:,:,1);

%% How does the same pixel without detrend look like?
% close all;
% figure(1),
% for ll = 1:10
%    plot(squeeze(MtHopeTEMPv3(ii(ll),jj(ll),:)),'-'); hold on
%    plot(squeeze(MtHopeTEMPv3(ii(ll),jj(ll),:)),'.'); hold on
%    ylim([-20 40]);
%       line([1,length(squeeze(MtHopeTEMPv3(ii(ll),jj(ll),:)))], [10, 10],...
%           'Color', 'k', 'LineWidth', 3); % 'k' denotes black color
%          line([1,length(squeeze(MtHopeTEMPv3(ii(ll),jj(ll),:)))], [0 0],...
%           'Color', 'r', 'LineWidth', 2,'linestyle','--'); % 'k' denotes black color
%          line([1,length(squeeze(MtHopeTEMPv3(ii(ll),jj(ll),:)))], [20 20],...
%           'Color', 'r', 'LineWidth', 2,'linestyle','--'); % 'k' denotes black color
%    
% set(gca, 'YTickLabel'); set(gca, 'XTickLabel');
% set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
% set(gca, 'FontSize', 16, 'FontWeight', 'bold');
% set(gca, 'Layer', 'top');
% title(sprintf('MtHopeTEMPerature of random %d pixels', ll));
% ylabel('MtHopeTEMPv3erature (°C)'); xlabel('Number of days')
% set(gcf, 'Position', [-2456,807,1829,500]);
% end
% clc; 

%% How does the detrended MtHopeTEMPv3erature look for any random 100 pixels?
% figure(2),
% clf;
% for ll = 1:10
%    plot(squeeze(MtHopeTEMPv3det(ii(ll),jj(ll),:)),'-'); hold on
%    plot(squeeze(MtHopeTEMPv3det(ii(ll),jj(ll),:)),'.'); hold on
%    ylim([-30 30]);
%    line([1,length(squeeze(MtHopeTEMPv3det(ii(ll),jj(ll),:)))], [0, 0],...
%        'Color', 'k', 'LineWidth', 3); % 'k' denotes black color
%       line([1,length(squeeze(MtHopeTEMPv3det(ii(ll),jj(ll),:)))], [-10 -10],...
%        'Color', 'r', 'LineWidth', 2,'linestyle','--'); % 'k' denotes black color
%       line([1,length(squeeze(MtHopeTEMPv3det(ii(ll),jj(ll),:)))], [10 10],...
%        'Color', 'r', 'LineWidth', 2,'linestyle','--'); % 'k' denotes black color
%    
% set(gca, 'YTickLabel'); set(gca, 'XTickLabel');
% set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
% set(gca, 'FontSize', 16, 'FontWeight', 'bold');
% set(gca, 'Layer', 'top');
% title('The same pixels after detrending');
% ylabel('MtHopeTEMPv3erature (°C)'); xlabel('Number of days')
% set(gcf, 'Position', [-2456,807,1829,500]);
% end
% clc; 



%% plot trend at every pixel
% figure(100),
% clf;
% pcolor(flip(MtHopeTEMPv3trnd));
% colorbar; caxis([-0.02 0.07])
% shading flat
% set(gca, 'YTickLabel'); set(gca, 'XTickLabel');
% set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
% set(gca, 'FontSize', 16, 'FontWeight', 'bold');
% set(gca, 'Layer', 'top');
% title('Pixel wise average MtHopeTEMPerature trend');
% set(gca,'XTickLabel',[]);set(gca,'YTickLabel',[]);
% set(gcf, 'Position', [-1702,462,711,807]);

%% Deseasonlize the data by Fourier transform
% Now deseasonalize on top of the detrended data by Fourier
ac=nan*MtHopeTEMPv3det(:,:,1);
as=ac;
% This is where the seasonal cycles will be stored
MtHopeTEMPv3detFour=nan*MtHopeTEMPv3det;

for ll=1:length(ii)

   % Multiply by the seasonal basis vectors
   ac(ii(ll),jj(ll))=mean(2*squeeze(MtHopeTEMPv3det(ii(ll),jj(ll),:)).*cos(t.*2.*pi));
   as(ii(ll),jj(ll))=mean(2*squeeze(MtHopeTEMPv3det(ii(ll),jj(ll),:)).*sin(t.*2.*pi));
   
   MtHopeTEMPv3detFour(ii(ll),jj(ll),:)= ac(ii(ll),jj(ll)).*cos(t.*2.*pi)+as(ii(ll),jj(ll)).*sin(t.*2.*pi);
end

% This is where the deseasoned, detrended data is formed
MtHopeTEMPv3detdes=MtHopeTEMPv3det-MtHopeTEMPv3detFour;
MtHopeTEMPv3des=MtHopeTEMPv3-MtHopeTEMPv3detFour; % deseasoned, but has the trend

% yearly mean for the Des 
for yy=1984:2022
   ndx=find(yy==year(datet));
   tm(yy-1983)=mean(t(ndx));
   YearlyMeanDes(:,:,yy-1983)=mean(MtHopeTEMPv3des(:,:,ndx),3);
end

clc
%% test
% clc;
% figure(1),
% clf;
% for i = 1:36
% subplot(6,6,i)
% pcolor(flip(MtHopeTEMPv3des(:,:,i))); colorbar; caxis([-10 10]); shading flat
% title([datestring(i)]);
% end

%% Deseasonlize the data by monthly means
for mm=1:12
    MtHopeTEMPv3detmnth(:,:,mm)=mean(MtHopeTEMPv3det(:,:,month(datet)==mm),3);
    MtHopeTEMPv3detdesmnth(:,:,month(datet)==mm)=MtHopeTEMPv3det(:,:,month(datet)==mm)-MtHopeTEMPv3detmnth(:,:,mm);
    MtHopeTEMPv3mean(:,:,mm)=mean(MtHopeTEMPv3(:,:,month(datet)==mm),3);
  
  if drawing==1
    figure(5); clf
    subplot(221)
     pcolor(LON2,LAT2,MtHopeTEMPv3detmnth(:,:,mm));shading('flat');
     caxis([min(MtHopeTEMPv3det(:)) max(MtHopeTEMPv3det(:))])
     colorbar
     title(['Detrended, Mean Removed, Average of Month ',mm]);
    subplot(222)
     pcolor(LON2,LAT2,MtHopeTEMPv3detmnth(:,:,mm)+MtHopeTEMPv3avg(:,:));shading('flat');
     caxis([min(MtHopeTEMPv3det(:)) max(MtHopeTEMPv3det(:))])
     colorbar
     title(['Detrended, Mean Restored, Average of Month ',num2str(mm)]);
     drawnow
     pause
  end
end

%% Comparison
% figure(3),
% clf;
% for ll = 1:300
%     subplot(4,2,1)
%     plot(squeeze(MtHopeTEMPv3(ii(ll),jj(ll),:)),'-','linewidth',2); hold on
%     ylim([-50 50])
%     legend('Raw MtHopeTEMPerature')
%     set(gca, 'XTickLabel',[]);
%     
%     
%     subplot(4,2,3)
%     plot(squeeze(MtHopeTEMPv3det(ii(ll),jj(ll),:)),'-','linewidth',2); hold on
%     ylim([-30 30])
%     legend('Detrended, demeaned MtHopeTEMPerature')
%     set(gca, 'XTickLabel',[]);
%     
%     
%     subplot(4,2,5)
%     plot(squeeze(MtHopeTEMPv3detFour(ii(ll),jj(ll),:)),'-','linewidth',2); hold on
%     ylim([-20 20])
%     legend('Fourier series')
%     set(gca, 'XTickLabel',[]);
%     
%     subplot(4,2,7)
%     plot(squeeze(MtHopeTEMPv3detdesmnth(ii(ll),jj(ll),:)),'-','linewidth',2); hold on
%     ylim([-30 30])
%     legend('Detrended, demeaned, deseasoned MtHopeTEMPerature')
%     set(gca, 'XTickLabel',[]);
%     
%     subplot(4,2,[2,4,6,8])
%     histogram(MtHopeTEMPv3detdesmnth(ii(ll),jj(ll),:)); hold on
%     set(gcf, 'Position', [-2480,227,1877,1101]);
% end
% clc; 

%% mask outliers in both type of deseasned matrix
Desdet_Fourier = filloutliers(MtHopeTEMPv3detdes, 'linear',3);
Desdet_Month = filloutliers(MtHopeTEMPv3detdesmnth, 'linear',3);

%% Comparison after masking
% figure(4),
% clf;
% for ll = 1:100
%     subplot(4,1,1)
%     plot(squeeze(MtHopeTEMPv3(ii(ll),jj(ll),:)),'-','linewidth',2); hold on
%     ylim([-50 50])
%     legend('Raw MtHopeTEMPerature')
%     set(gca, 'XTickLabel',[]);
%     
%     
%     subplot(4,1,2)
%     plot(squeeze(MtHopeTEMPv3det(ii(ll),jj(ll),:)),'-','linewidth',2); hold on
%     ylim([-30 30])
%     legend('Detrended, demeaned MtHopeTEMPerature')
%     set(gca, 'XTickLabel',[]);
%     
%     
%     subplot(4,1,3)
%     plot(squeeze(Desdet_Fourier(ii(ll),jj(ll),:)),'-','linewidth',2); hold on
%     ylim([-20 20])
%     legend('Fourier series')
%     set(gca, 'XTickLabel',[]);
%     
%     subplot(4,1,4)
%     plot(squeeze(Desdet_Month(ii(ll),jj(ll),:)),'-','linewidth',2); hold on
%     ylim([-20 20])
%     legend('Detrended, demeaned, deseasoned MtHopeTEMPerature')
%     set(gca, 'XTickLabel',[]);
%     set(gcf, 'Position', [-2480,234,1686,1094]);
% end
% 
% figure(5),
% clf
% for ll = 1:1000
%     subplot(2,1,1)
%     histogram(Desdet_Fourier(ii(ll),jj(ll),:),'facecolor','b'); hold on
%     title('Fourier deseason')
%     
%     subplot(2,1,2)
%     histogram(Desdet_Month(ii(ll),jj(ll),:),'facecolor','r'); hold on
%     set(gcf, 'Position', [-2183,154,680,1131]);
%     title('Monthly deseason')
% end
% clc; 

%% reduce the size of the deseasonalizers
Desdet_Fourier_MtHopeBay_v3 = round(Desdet_Fourier, 2);
Desdet_Month_MtHopeBay_v3 = round(Desdet_Month, 2);
Des_Fourier_MtHopeBay_v3 = round(MtHopeTEMPv3des);

%% save the deseasonalizers
save('Desdet_Fourier_MtHopeBay_v3.mat', 'Desdet_Fourier_MtHopeBay_v3', '-v7.3');
save('Desdet_Month_MtHopeBay_v3.mat', 'Desdet_Month_MtHopeBay_v3', '-v7.3');