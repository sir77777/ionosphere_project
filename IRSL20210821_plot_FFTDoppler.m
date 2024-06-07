clear; clc; close all;
%% Parameters
Fs = 512;                % Sampling frequency
W = 60;                  % Time window (s)
L = Fs*W;                % Length of signal
f = (Fs*(0:L/2-1)/L)-80; % Prepare freq data for plot
dfrange = 2;             % ±3(Hz)
%% Processed Parameters
tmp=f-dfrange; uboundary=find(tmp==min(abs(tmp)), 1, 'last');
tmp=f-(-dfrange); lboundary=find(tmp==min(abs(tmp)), 1, 'first');
clear tmp;
ftick = f(lboundary:uboundary);
% timetick = 10*3600/W:48*3600/W:564*3600/W;
% timelabel = {'0709','0711','0713','0715','0717','0719','0721','0723','0725','0727','0729','0731'};
freq = {'D39','D44','D49','D55','D61'};
%% Directory
tic % 209sec/1 frreq. file
stationdir = 'D:\大四資料\Irsl\CODE\mat\Doppler\';
dirlist = dir(strcat(stationdir));
for k=3:length(dirlist)
    station = dirlist(k).name;
    for m=1%:length(freq)
        D_freq=freq{m};
        Dir = ['D:\大四資料\Irsl\CODE\mat\Doppler\', station, '\',D_freq,'\2021\05\'];
        filelist = dir(strcat(Dir,'*.mat'));
        if isempty(filelist)
            disp(station)
            continue
        end
        nfiles = length(filelist);
        %% Data Proeessing
        allMpower=NaN(3600/W*nfiles, 1);
        alldf=NaN(3600/W*nfiles, 1);
        allPdf=NaN(uboundary-lboundary+1, 3600/W*nfiles);
        for i=1: nfiles
            filename = filelist(i).name;
            load([Dir, filename]); % Variable name: FFTdata
            rangedata = FFTdata(lboundary:uboundary, :);
            Mpower = max(rangedata, [], 1);
            allMpower(3600/W*(i-1)+1:3600/W*i) = Mpower;
            
            df=NaN(3600/W, 1);
            for j=1:3600/W
                if isnan(Mpower(j))
                    continue
                end
                df(j)=ftick(find(rangedata(:,j)==Mpower(j),1));
            end
            alldf(3600/W*(i-1)+1:3600/W*i) = df;
            allPdf(:,3600/W*(i-1)+1:3600/W*i) = rangedata;
        end
        %% Time (fill the empty)
        Amp_T=NaN(30*24*3600/W,1);
        df_T=NaN(30*24*3600/W,1);
        Amp_df_T=NaN(length(allPdf(:,1)),30*24*3600/W);
        for i=1: nfiles
            filename1 = filelist(i).name; tmp = split(filename1,'_'); tmp=tmp{3};
            Day = str2double(tmp(7:8)); Hour = str2double(tmp(9:10));
            n=(Day-1)*24+(Hour);
            Amp_T(n*3600/W+1:(n+1)*3600/W) = allMpower((i-1)*3600/W+1:i*3600/W);
            df_T(n*3600/W+1:(n+1)*3600/W) = alldf((i-1)*3600/W+1:i*3600/W);
            Amp_df_T(:,n*3600/W+1:(n+1)*3600/W) = allPdf(:,(i-1)*3600/W+1:i*3600/W);
        end
        
        save_str=['D:\大四資料\Irsl\CODE\mat\FFT_Doppler\0924\',station,'_',D_freq,'_2021_05.mat'];
        save(save_str,'Amp_T','df_T','Amp_df_T');
    end
end
toc