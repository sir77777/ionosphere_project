clear; clc; close all;
%% Parameters
fs = 512;                % Sampling frequency
W = 60;                  % Time window (s)
N = fs*W;                % Length of signal
f = 80-(fs*(0:N/2-1)/N); % Prepare freq data for plot
dfrange = 2;
station = {'FBE'};
tmp=f+dfrange;  lboundary=find(tmp==min(abs(tmp)), 1, 'first');%取f趨近-dfrange
tmp=f-dfrange;  uboundary=find(tmp==min(abs(tmp)), 1, 'last');%取f趨近+dfrange
F=f(uboundary:lboundary)';
shading flat
%% 0115
p = uipanel('Position',[.455 -0.05 .55 1.08]);
t = tiledlayout(p,5,1);
for i=1:length(station)
    cd(['D:\user\20220115\',station{i},'\D39'])
    deltaf=NaN(1,24*60);
    %從FFT資料提取deltaf
    for hour=0:9
        load([ station{i},'_D39_202201150' ,num2str(hour), '.dat' ])
        [maxpower,maxindex]=max(data,[],1);
        maxindex(isnan(maxpower))=nan;  %處理NAN值
        deltaf(60*hour+1:60*hour+60)=80-fs*maxindex/N;
    end
    for hour=10:23
        load([ station{i},'_D39_20220115' ,num2str(hour), '.mat' ])
        [maxpower,maxindex]=max(data,[],1);
        maxindex(isnan(maxpower))=nan;  %處理NAN值
        deltaf(60*hour+1:60*hour+60)=80-fs*maxindex/N;
    end
    %畫Δf曲線
    nexttile(t)
    x=linspace(0, 24,numel(deltaf));
    scatter(x,deltaf,1,"black","filled")
    title([station{i},' D39 2022 0115'])
    yticks(-dfrange:dfrange),yticklabels(-dfrange:dfrange),ylabel( 'Δf' ),ylim([-dfrange dfrange])
    xticks([]),xlim([0 24])
end
xticks(1:24),xticklabels(1:24),xlabel( 'LT' )
