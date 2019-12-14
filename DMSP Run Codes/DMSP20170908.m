%% 
% Initialization

clear;
close all;
fileNameStr = 'dms_20170908_15s1.001.hdf5';
fileNameStr2 = 'dms_20170908_15s4.001.hdf5';
data1=DMSPdatafetch(fileNameStr,fileNameStr2);

fileNameStr = 'dms_20170908_16s1.001.hdf5';
fileNameStr2 = 'dms_20170908_16s4.001.hdf5';
fileNameStr3= 'dms_20170908_16e.001.hdf5';
data2=DMSPdatafetch(fileNameStr,fileNameStr2,fileNameStr3);

fileNameStr = 'dms_20170908_17s1.001.hdf5';
fileNameStr2 = 'dms_20170908_17s4.001.hdf5';
fileNameStr3= 'dms_20170908_17e.001.hdf5';
data3=DMSPdatafetch(fileNameStr,fileNameStr2,fileNameStr3);

fileNameStr = 'dms_20170908_18s1.001.hdf5';
fileNameStr2 = 'dms_20170908_18s4.001.hdf5';
fileNameStr3= 'dms_20170908_18e.001.hdf5';
data4=DMSPdatafetch(fileNameStr,fileNameStr2,fileNameStr3);

RadarStartTime = '09/08/2017 15:30:00';
RadarEndTime = '09/08/2017 15:31:00';
RadarFile = '20170905.002_lp_1min-fitcal.h5';
error=0.5;

ticks=15;

maptype='north'; %north, conical,  cylindrical
timetype='ut';
linestep=0;
ttick=120;
scale=1000;
mltvar=1;

latplot=[45 90];
lonplot=[140 -80];

mnorthlat=80.484;
mnorthlon=-72.841;

% latplot=[40 70];
% lonplot=[-120 -70];
%% Line plot time interval


% timeMinStr='09/08/2017 15:30:00';
% timeMaxStr='09/08/2017 16:30:00';
%DMSPplotsF15(timeMinStr,timeMaxStr,data1,ticks);
% DMSPplotsViNeOratio(timeMinStr,timeMaxStr,data1,ticks)
% DMSPplotsViNeOratio(timeMinStr,timeMaxStr,data2,ticks)
% DMSPplots(timeMinStr,timeMaxStr,data3,ticks)
% DMSPplotsViNeOratio(timeMinStr,timeMaxStr,data4,ticks)
% 
% DMSPplotsNeTiE(timeMinStr,timeMaxStr,data2,ticks)
 %DMSPplotsNeTiE(timeMinStr,timeMaxStr,data3,ticks)
% DMSPplotsNeTiE(timeMinStr,timeMaxStr,data4,ticks)
%% Map plot

timeMinStr='09/08/2017 00:00:00';
timeMaxStr='09/08/2017 24:00:00';

% timeMinStr='09/08/2017 14:00:00';
% timeMaxStr='09/08/2017 16:00:00';
[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data1.time1);
indexes1=initd:1:endd;

% timeMinStr='09/08/2017 15:22:00';
% timeMaxStr='09/08/2017 15:52:00';
[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data2.time1);
indexes2=initd:1:endd;
%DMSPplots(timeMinStr,timeMaxStr,data2,ticks,mltvar)


% timeMinStr='09/08/2017 12:00:00';
% timeMaxStr='09/08/2017 24:00:00';
[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data3.time1);
indexes3=initd:1:endd;
% %DMSPplots(timeMinStr,timeMaxStr,data3,ticks,mltvar)


% timeMinStr='09/08/2017 12:00:01';
% timeMaxStr='09/08/2017 24:00:00';
[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data4.time1);
indexes4=initd:1:endd;
% DMSPplots(timeMinStr,timeMaxStr,data4,ticks,mltvar)




mapgenerator(maptype,latplot,lonplot)
DMSPmvplot(latplot,lonplot,maptype,data1,timetype,linestep,ttick,[0.8 0.8 0.8],indexes1,scale,0,0,mnorthlat,mnorthlon)

RISRlat=65.12992;
RISRlon=-147.47104;
[x0,y0] = mfwdtran(RISRlat,RISRlon);
plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[0 0 0],'MarkerSize',10);

mapgenerator(maptype,latplot,lonplot)
DMSPmvplot(latplot,lonplot,maptype,data2,timetype,linestep,ttick,[0.8 0.8 0.8],indexes2,scale,0,0,mnorthlat,mnorthlon)

RISRlat=65.12992;
RISRlon=-147.47104;
[x0,y0] = mfwdtran(RISRlat,RISRlon);
plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[0 0 0],'MarkerSize',10);

mapgenerator(maptype,latplot,lonplot)
DMSPmvplot(latplot,lonplot,maptype,data3,timetype,linestep,ttick,[0.8 0.8 0.8],indexes3,scale,0,0,mnorthlat,mnorthlon)

RISRlat=65.12992;
RISRlon=-147.47104;
[x0,y0] = mfwdtran(RISRlat,RISRlon);
plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[0 0 0],'MarkerSize',10);

mapgenerator(maptype,latplot,lonplot)
DMSPmvplot(latplot,lonplot,maptype,data4,timetype,linestep,ttick,[0.8 0.8 0.8],indexes4,scale,0,0,mnorthlat,mnorthlon)
%RadarLOSmplotold(RadarFile,RadarStartTime,RadarEndTime,scale,error)

RISRlat=65.12992;
RISRlon=-147.47104;
[x0,y0] = mfwdtran(RISRlat,RISRlon);
plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[0 0 0],'MarkerSize',10);

% If linestep==0, no vectors plotted, if indexes=0, all data is used for
% plot

%% Video plot
%DMSPvideomanager(latplot,lonplot,latitude,longitude,mlt1,time1,vh,DMSPn,0,10,60)
