clc
clear
%% variable
station = 'FBE';
Fs = 512;            % Sampling frequency
W = 60;                  % Time window (s)
L = Fs*W;             % Length of signal
%T = 1/Fs;             % Sampling period
%t = (0:L-1)*T;        % Time vector
%f = (Fs*(0:L/2-1)/L)-80;   %Prepare freq data for plot
%% get data
instrument_str = (['D:\user\20220115\',station,'\']);
instrumentlist = dir(strcat(instrument_str,'*'));

for i = 3 %: 7 %不同頻率
    file_str = (['D:\user\20220115\',station,'\',instrumentlist(i).name,'\']);
    addpath(['D:\user\20220115\',station,'\',instrumentlist(i).name,'\'])
    filelist = dir(strcat(file_str,'*.dat'));
    for  j = 17% : length(filelist)  %00時~23時
        %% get data
        disp(j)
        filename = filelist(j).name;
        raw_data = load(filename);
        full_data=NaN(Fs*3600+1,1);
        full_data(1:length(raw_data)) = raw_data(1:length(raw_data));
%{
        halfway_data = raw_data(2:end,1);
        for m = 1 : length(halfway_data)
            reshape_halfway_data(m,1) = halfway_data(m,1);
        end
        reshape_halfway_data = reshape(reshape_halfway_data,512,3600);
%}
        %% fft
        fft_data = NaN(L/2,3600/W);
        for m=1%:(3600/W)  %第1個window~第(3600/W)個window
            %x=reshape_halfway_data(:,(m-1)*60+1:m*60);
            %X=reshape(x,512*60,1);
            X = full_data((m-1)*L+2:m*L+1,1);
            Y=fft(X);
            P2 = abs(Y/L);
            P1 = 2*P2(2:L/2+1);
            for n = 1 : 15360
                fft_data(n,m) = P1(n,1);
            end
            save_str=['D:\dopplerfftdata\',station,'\',filename,'.mat'];
            %save(save_str,'fft_data');
        end
    end
end
