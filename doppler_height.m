clear; clc; close all;
%% Parameters
fs = 512;                % Sampling frequency
W = 60;                  % Time window (s)
N = fs*W;                % Length of signal
f = 80-(fs*(0:N/2-1)/N); % Prepare freq data for plot
dfrange = 60;
station = {'FBE','HCS','YLC'};
%station = {'CCU','CNU','FBE','HCS','YLC'};
para = {-34.900,-37.474,-32.862,-37.051,-34.937};
shading flat
h_init = 16;

%% 0114
p = uipanel('Position',[-0.045 -0.05 .57 1.08]);
t = tiledlayout(p,length(station)+2,1,'TileSpacing','none');
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
    %對速度積分得到高度
    deltah(1)=deltaf0114(h_init*60+1);
    for k=2:(1440-h_init*60)
        if isnan(deltaf0114(k+h_init*60)) || deltaf0114(k+h_init*60)>10000/60
            deltaf0114(k+h_init*60)=0;
        end
        deltah(k)=deltaf0114(k+h_init*60)+deltah(k-1);
    end
    %畫Δh曲線
    nexttile(t)
    x=linspace(h_init, 24,numel(deltah));
    %scatter(x,deltah*60/1000,1,"black","filled")
    plot(x,deltah*60/1000+200);
    title([station{i},' D39 2022 0114'])
    yticks(200:50:350),yticklabels(200:50:350),ylabel( 'H(km)' ),ylim([180 360])
    xticks([]),xlim([h_init 23])
end
xticks(h_init:23),xticklabels(h_init:23),xlabel( 'LT(hr)' )

%% 0115
p = uipanel('Position',[.48 -0.05 .57 1.08]);
t = tiledlayout(p,length(station)+2,1,'TileSpacing','none');
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
    %對速度積分得到高度
    deltah(1)=deltaf0115(h_init*60+1);
    for k=2:(1440-h_init*60)
        if isnan(deltaf0115(k+h_init*60)) || deltaf0115(k+h_init*60)>10000/60
            deltaf0115(k+h_init*60)=0;
        end
        deltah(k)=deltaf0115(k+h_init*60)+deltah(k-1);
    end
    %畫Δh曲線
    nexttile(t)
    x=linspace(h_init, 24,numel(deltah));
    %scatter(x,deltah*60/1000,1,"black","filled")
    plot(x,deltah*60/1000+200);
    title([station{i},' D39 2022 0115'])
    yticks(200:50:350),yticklabels(200:50:350),ylabel( 'H(km)' ),ylim([180 360])
    xticks([]),xlim([h_init 23])
end
xticks(h_init:23),xticklabels(h_init:23),xlabel( 'LT(hr)' )
