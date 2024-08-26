# Estuary temperature variability
This document contains the details of the scripts for the Narragansett Bay SST paper

## v3 dataset description

The v3 dataset has three folders - 1. Scripts, 2. Data, and 3. Figures. 

Difference between v2 and v3 dataset

When we have an unevenly sampled dataset, there is a big chance that we will minimize the error in the area with the most observations at the cost of adding errors to the other places. The more reasonable approach should be to try to get as close as you can get to collect the same number of samples from each buoy. It is more likely a balancing act. Ideally, we would like to have the same number of observations from each buoy per month, per season, per year, per location. Also, ideally, it is evenly and fairly spread out in the range of temperatures. 

So, what is the proposal for the v3 dataset? We denoted the original satellite data as Ts, the buoy data as Tb, and the bias-corrected satellite data as Ts'. We proposed that the bias consists of a mean component, n, and a temperature-dependent component, m. The error E observed after adjusting the data using the estimated values of m and n is expressed by the equation:
𝐸=𝑇𝑏−𝑇𝑠′=𝑇𝑏−(𝑇𝑠+𝑚⋅𝑇𝑠+𝑛)
For a given sample number N, our objective was to determine the optimal values of m and n such that the mean of E is zero (mean(E) = 0) and the variance of E is minimized. To estimate m and n that satisfy Equation 1, we performed a standard K-fold cross-validation (Lachenbruch and Mickey, 1968; Refaeilzadeh et al., 2009).  The algorithm for the bias correction and K-fold process is attached to this picture. (Footnote: Training is what I do to find the best-fit parameter of my model, and Testing is how I see how far that model is from the other set of data).



Table 2 (screenshot from the paper) shows important specifications for each Landsat satellite. After the bias correction, we prepared the collective temperature dataset for four decades by calibrating Landsat pixels over each satellite's lifetime. The quality-controlled buoy data covers 2003 to 2019, so the calibration was limited to this timeframe. 


Difference between v2 and v3: 
Our approach to bias correction differs from that of Benoit and Fox-Kemper (2021), where they introduced the error as E = Tbuoy - (TLandsat + σ̄). Their method involved determining the mean bias (σ̄) by repeatedly sampling both buoy and satellite temperatures and calculating the biases of the random sample ten thousand times. Using that approach, they computed mean biases for each Landsat satellite and then recalibrated the satellite temperature dataset by subtracting these mean biases from the corresponding satellite scenes.
Data

TEMPv3.mat, MtHopeTEMPv3.mat
This is the most important file. Bias corrected (using the v3 algorithm), and an in-situ calibrated temperature dataset was used for both bays. Both are 3D matrices with a size of 1130x800x764 (N. Bay) and 376x268x764 (Mt. Hope Bay). The first two dimensions are grid size, and the 3rd dimension is time (number of scenes). 

BayAnnualTrend.mat, MtHopeAnnualTrend.mat
Contain the yearly mean values, trendlines, and spatial and temporal anomalies for both bays. It plots this figure. 

BayTEMPmean_v3.mat, MtHopeTEMPmean_v3.mat
This file contains each year's area-averaged mean temperature (39 scenes because of 39 years), monthly mean temperature (12 scenes for 12 months), the spatial trend of temperature increasing in every pixel (1 scene), and the yearly deseasonalized mean (39 scenes for 39 years) for both bays. 

Desdet_Fourier_Bay_v3.mat, Desdet_Fourier_MtHopeBay_v3.mat
The files contain the deseasonalized, detrended temperature values for both bays (764 scenes). Seasons were removed using a Fourier signal. 

Desdet_Month_Bay_v3.mat, Desdet_Month_MtHopeBay_v3.mat
It was the same as the previous, except the seasons were removed by stacking individual months together. For example, the mean February temperature was removed from every February scene. 

DATE_SECTIONS.mat
It contains the indices of each scene that falls under individual tide phases. For example, one hundred fifty-six scenes were collected during the ebb tide. Similarly, the flood, high, and low tide contain 171, 202, and 235 scenes. It also includes the datestamp for each Landsat scene. This is a very important file for the tidal analysis part of this paper. 

SeasonalityTides.mat
It contains the indices of seasons and months for each Landsat scene captured. This information is important for both tidal analysis and seasonal cycle analysis. 

## Scripts

plot_decadal_mean_Bay.m
This code generates a decadal mean temperature map and computes the standard errors for each decade. 


plot_EOF_Bay.m, plot_EOF_MtHope_Bay.m
These codes calculate the EOFs and plot the first three modes of EOFs in the bays for the entire Landsat record. 

plot_HT_diagram, plot_HT_histogram
We proposed two different approaches to report the influences of tides on the SST anomalies of the bay. One method was the SNR method, and the other one was the HT test. These two codes plot the HT diagrams and the HT histograms in buoy locations 11 and 13. 




plot_interannualTrend.m 
It loads the 39-year-long temperature trend records from Narragansett Bay and Mt Hope Bay and plots their trend and associated temporal and spatial uncertainty. Also, it shows the spatial maps of the SST trends of the bay (i.e., how much the temperature is increasing per year).



plot_monthly_mean_Bay.m, plot_monthly_mean_MtHope_Bay.m
These codes generate monthly mean temperature maps and compute the standard errors associated with each month. 


plot_satellite_vs_insitu_temp.m
Shows the relationship between the in situ temperature and the corresponding satellite temperature. 




prep_SNR.m
The first approach to quantify the effect of tides as an SST anomaly in the bay is coded here. The signal-to-noise ratio map shows where in the bay and in which season the signals are relatively stronger or weaker. 

