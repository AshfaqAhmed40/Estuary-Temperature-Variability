close all; clc; 


%% Biases
% Define values of m for each satellite
m_L5 = -0.0167;
m_L7 = -0.1068; 
m_L8 = -0.13038;

% Define values of n for each satellite
n_L5 = 1.188;
n_L7 = 1.6711; 
n_L8 = 2.2719;


%% Load data
HOME = '/Users/aahmed78/Desktop/Journal of Climate/v3/';
cd(strcat('/Users/aahmed78/Desktop/Journal of Climate/Infilled Data/MtHopeBay'));
load Infilled_MtHopeBay.mat
load DateStamp.mat
cd(strcat(HOME))

%% Find indices for each satellites
DateCol = table2cell(DateStamp(:,3));
L5_idx = find(contains(DateCol,'landsat_5'));
L7_idx = find(contains(DateCol,'landsat_7'));
L8_idx = find(contains(DateCol,'landsat_8'));

%% Apply bias correction
MtHopeTEMPv1 = zeros(size(MtHopeTEMP)); % not bias corrected
MtHopeTEMPv2 = MtHopeTEMP;              % bias corrected by Dan
MtHopeTEMPv3 = zeros(size(MtHopeTEMP)); % bias corrected by Ashfaq 

% first, remove Dan's biases
MtHopeTEMPv1(:,:,L5_idx) = MtHopeTEMPv2(:,:,L5_idx) + (-0.45);
MtHopeTEMPv1(:,:,L7_idx) = MtHopeTEMPv2(:,:,L7_idx) + (-1.094);
MtHopeTEMPv1(:,:,L8_idx) = MtHopeTEMPv2(:,:,L8_idx) + (0.178);

% now, I apply my bias correction
MtHopeTEMPv3(:,:,L5_idx) = MtHopeTEMPv1(:,:,L5_idx) + (MtHopeTEMPv1(:,:,L5_idx).*m_L5 + n_L5);
MtHopeTEMPv3(:,:,L7_idx) = MtHopeTEMPv1(:,:,L7_idx) + (MtHopeTEMPv1(:,:,L7_idx).*m_L7 + n_L7);
MtHopeTEMPv3(:,:,L8_idx) = MtHopeTEMPv1(:,:,L8_idx) + (MtHopeTEMPv1(:,:,L8_idx).*m_L8 + n_L8);

% reduce the size
MtHopeTEMPv3 = round(MtHopeTEMPv3, 2);