%對原始資料FFT轉換
N=size(data,1);
fs=39;
for h=0:9
    load([ 'CCU_D39_202201140' ,num2str(h), '.mat' ])
    for i=1:60
        p2=abs(fft(data(:,i)));
        p1=p2(1:N/2);
        [a,b]=max(p1);
        deltaf(60*h+i)=fs*b/N;
    end
end
for h=10:23
    load([ 'CCU_D39_20220114' ,num2str(h), '.mat' ])
    for i=1:60
        p2=abs(fft(data(:,i)));
        p1=p2(1:N/2);
        [a,b]=max(p1);
        deltaf(60*h+i)=fs*b/N;
    end
end

%%
%test fft
load('CCU_D39_2022011407.mat')
p2=abs(fft(data(:,45)));
p1=p2(1:N/2);

f=fs*(1:N/2)/N;
p_scaled=abs(p1)/(N/2);
plot(f,p_scaled)
title( 'test' )
xlabel( 'f (Hz)' )
ylabel( 'amplitude' )
