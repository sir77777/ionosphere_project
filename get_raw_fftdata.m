clc
clear
%% variable
station = 'YiLan';
Fs = 512;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 512*60;             % Length of signal
t = (0:L-1)*T;        % Time vector
f = (Fs*(0:L/2-1)/L)-80;   %Prepare freq data for plot
%% get data
instrument_str = (['I:\0707\',station,'\']);
instrumentlist = dir(strcat(instrument_str,'*'));
for i = 3 : 7 
    file_str = (['I:\0707\',station,'\',instrumentlist(i).name,'\']);
    addpath(['I:\0707\',station,'\',instrumentlist(i).name,'\'])
    filelist = dir(strcat(file_str,'*.dat'));
    for  j = 1 : length(filelist)
        %% get data
        disp(j)
        filename = filelist(j).name;
        reshape_halfway_data=NaN(1843200,1);
        raw_data = load(filename);
        halfway_data = raw_data(2:end,1);
        for m = 1 : length(halfway_data)
            reshape_halfway_data(m,1) = halfway_data(m,1);
        end
        reshape_halfway_data = reshape(reshape_halfway_data,512,3600);
        %% fft
        fft_data = NaN(15360,60);
        for m=1:1*60
            x=reshape_halfway_data(:,(m-1)*60+1:m*60);
            X=reshape(x,512*60,1);
            Y=fft(X);
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            P1(1) = [];
            for n = 1 : 15360
                fft_data(n,m) = P1(n,1);
            end
            data = fft_data;
            save_str=['I:\0707\',station,'\fftdata\',filename,'.mat'];
            save(save_str,'data');
        end
    end
end