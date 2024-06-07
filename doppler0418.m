clear; clc; close all;
%% Parameters
fs = 512;                % Sampling frequency
W = 60;                  % Time window (s)
N = fs*W;                % Length of signal
f = 80-(fs*(0:N/2-1)/N); % Prepare freq data for plot
dfrange = 2;
station = {'CCU','CNU','FBE','HCS','YLC'};
tmp=f+dfrange;  lboundary=find(tmp==min(abs(tmp)), 1, 'first');%取f趨近-dfrange
tmp=f-dfrange;  uboundary=find(tmp==min(abs(tmp)), 1, 'last');%取f趨近+dfrange
F=f(uboundary:lboundary)';
shading flat
%colormap parula
colormap jet(100)

%% 0115
for i=1:length(station)
    cd(['C:\Users\user\Documents\MATLAB\0115\',station{i},'\0115'])
    shift=NaN(1,60);
    %從FFT資料提取deltaf
    for hour=17
        load([ station{i},'_D39_20220115' ,num2str(hour), '.mat' ])
        [maxpower,maxindex]=max(data,[],1);
        maxindex(isnan(maxpower))=nan;  %處理NAN值
        shift(60*(hour-17)+1:60*(hour-17)+60)=80-fs*maxindex/N;
    end
    shift(shift <= -2) = 0;
    [minpower,minindix]=min(shift);
    disp(minindix);
end
x=linspace(0, 60,numel(shift));
scatter(x,shift,1,"black","filled")