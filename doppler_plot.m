clear; clc; close all;
%% Parameters
fs = 512;                % Sampling frequency
W = 60;                  % Time window (s)
N = fs*W;                % Length of signal
f = 80-(fs*(0:N/2-1)/N); % Prepare freq data for plot
dfrange = 60;
station = {'CCU','CNU','FBE','HCS','YLC'};
para = {-34.900,-37.474,-32.862,-37.051,-34.937};
shading flat

%% 0114
p = uipanel('Position',[-0.045 -0.05 .57 1.08]);
t = tiledlayout(p,5,1);
for i=1:length(station)
    cd(['C:\Users\user\OneDrive\Documents\MATLAB\0114\',station{i},'\0114'])
    deltaf0114=NaN(1,24*60);
    %從FFT資料提取deltaf
    for hour=0:9
        load([ station{i},'_D39_202201140' ,num2str(hour), '.mat' ])
        [maxpower,maxindex]=max(data,[],1);
        maxindex(isnan(maxpower))=nan;  %處理NAN值
        deltaf0114(60*hour+1:60*hour+60)=80-fs*maxindex/N;
    end
    for hour=10:23
        load([ station{i},'_D39_20220114' ,num2str(hour), '.mat' ])
        [maxpower,maxindex]=max(data,[],1);
        maxindex(isnan(maxpower))=nan;  %處理NAN值
        deltaf0114(60*hour+1:60*hour+60)=80-fs*maxindex/N;
    end
    deltaf0114=(deltaf0114-mean(deltaf0114(540:900),'omitnan'))*para{i};
    %畫Δf曲線
    nexttile(t)
    x=linspace(0, 24,numel(deltaf0114));
    plot(x,deltaf0114)
    title([station{i},' D39 2022 0114'])
    yticks(-dfrange:15:dfrange),yticklabels(-dfrange:15:dfrange),ylabel( 'V(m/s)' ),ylim([-dfrange dfrange])
    xticks([]),xlim([0 24])
end
xticks(1:24),xticklabels(1:24),xlabel( 'LT' )

%% 0115
p = uipanel('Position',[.48 -0.05 .57 1.08]);
t = tiledlayout(p,5,1);
for i=1:length(station)
    cd(['C:\Users\user\Documents\MATLAB\0115\',station{i},'\0115'])
    deltaf0115=NaN(1,24*60);
    %從FFT資料提取deltaf
    for hour=0:9
        load([ station{i},'_D39_202201150' ,num2str(hour), '.mat' ])
        [maxpower,maxindex]=max(data,[],1);
        maxindex(isnan(maxpower))=nan;  %處理NAN值
        deltaf0115(60*hour+1:60*hour+60)=80-fs*maxindex/N;
    end
    for hour=10:23
        load([ station{i},'_D39_20220115' ,num2str(hour), '.mat' ])
        [maxpower,maxindex]=max(data,[],1);
        maxindex(isnan(maxpower))=nan;  %處理NAN值
        deltaf0115(60*hour+1:60*hour+60)=80-fs*maxindex/N;
    end
    deltaf0115=(deltaf0115-mean(deltaf0115(540:900),'omitnan'))*para{i};
    %畫Δf曲線
    nexttile(t)
    x=linspace(0, 24,numel(deltaf0115));
    plot(x,deltaf0115)
    title([station{i},' D39 2022 0115'])
    yticks(-dfrange:15:dfrange),yticklabels(-dfrange:15:dfrange),ylabel( 'V(m/s)' ),ylim([-dfrange dfrange])
    xticks([]),xlim([0 24])
end
xticks(1:24),xticklabels(1:24),xlabel( 'LT' )
