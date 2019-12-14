%% 
% Initialization

clear;
close all;

fileNameStr = 'dms_20120124_15s1.001.hdf5';
fileNameStr2 = 'dms_20120124_15s4.001.hdf5';
data1=DMSPdatafetchMAD(fileNameStr,fileNameStr2);

fileNameStr = 'dms_20120124_16s1.001.hdf5';
fileNameStr2 = 'dms_20120124_16s4.001.hdf5';
fileNameStr3= 'dms_20120124_16e.001.hdf5';
data2=DMSPdatafetchMAD(fileNameStr,fileNameStr2,fileNameStr3);

fileNameStr = 'dms_20120124_17s1.001.hdf5';
fileNameStr2 = 'dms_20120124_17s4.001.hdf5';
fileNameStr3= 'dms_20120124_17e.001.hdf5';
data3=DMSPdatafetchMAD(fileNameStr,fileNameStr2,fileNameStr3);

fileNameStr = 'dms_20120124_18s1.001.hdf5';
fileNameStr2 = 'dms_20120124_18s4.001.hdf5';
fileNameStr3= 'dms_20120124_18e.001.hdf5';
data4=DMSPdatafetchMAD(fileNameStr,fileNameStr2,fileNameStr3);

RadarStartTime = '01/24/2012 12:05:00';
RadarEndTime = '01/24/2012 12:10:00';
RadarFile = '20120122.001_lp_5min.h5';
error=0.25;

ticks=15;

maptype='north'; %north, conical or cylindrical
timetype='ut';
linestep=1;
ttick=120;
scale=200;
mltvar=0;


latplot=[40 90];
lonplot=[-120 60];

mnorthlat=80.199;
mnorthlon=-72.373;

%% Line plot time interval
% timeMinStr='01/24/2012 11:30:00';
% timeMaxStr='01/24/2012 12:10:00';
% DMSPplotsF15(timeMinStr,timeMaxStr,data1,ticks)
% % DMSPplotsViNeOratio(timeMinStr,timeMaxStr,data2,ticks)
% % DMSPplotsViNeOratio(timeMinStr,timeMaxStr,data3,ticks)
% % DMSPplotsViNeOratio(timeMinStr,timeMaxStr,data4,ticks)
% 
 timeMinStr='01/24/2012 11:30:00';
 timeMaxStr='01/24/2012 12:10:00';
 DMSPplots(timeMinStr,timeMaxStr,data2,ticks,mltvar)
%  
 timeMinStr='01/24/2012 11:40:00';
 timeMaxStr='01/24/2012 12:20:00';
DMSPplots(timeMinStr,timeMaxStr,data3,ticks,mltvar)
%  
 timeMinStr='01/24/2012 12:10:00';
 timeMaxStr='01/24/2012 12:40:00';
 DMSPplots(timeMinStr,timeMaxStr,data4,ticks,mltvar)

%% Map plot
% timeMinStr='01/24/2012 12:00:01';
% timeMaxStr='01/24/2012 23:59:59';
% 
% timeMinStr='01/24/2012 11:00:00';
% timeMaxStr='01/24/2012 12:30:00';
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data1.time1);
% indexes1=initd:1:endd;
% 
% timeMinStr='01/24/2012 11:30:00';
% timeMaxStr='01/24/2012 12:30:00';
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data2.time1);
% indexes2=initd:1:endd;
% 
%  timeMinStr='01/24/2012 11:40:00';
%  timeMaxStr='01/24/2012 12:20:00';
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data3.time1);
% indexes3=initd:1:endd;
% 
%  timeMinStr='01/24/2012 11:50:00';
%  timeMaxStr='01/24/2012 12:50:00';
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data4.time1);
% indexes4=initd:1:endd;



% mapgenerator(maptype,latplot,lonplot)
% DMSPmvplot(latplot,lonplot,maptype,data1,timetype,linestep,ttick,[0.8 0.8 0.8],indexes1,scale,0,0,mnorthlat,mnorthlon)
% mapgenerator(maptype,latplot,lonplot)
% DMSPmvplot(latplot,lonplot,maptype,data2,timetype,linestep,ttick,[0.8 0.8 0.8],indexes2,scale,0,0,mnorthlat,mnorthlon)
% mapgenerator(maptype,latplot,lonplot)
% DMSPmvplot(latplot,lonplot,maptype,data3,timetype,linestep,ttick,[0.8 0.8 0.8],indexes3,scale,0,0,mnorthlat,mnorthlon)
% mapgenerator(maptype,latplot,lonplot)
% DMSPmvplot(latplot,lonplot,maptype,data4,timetype,linestep,ttick,[0.8 0.8 0.8],indexes4,scale,0,0,mnorthlat,mnorthlon)
% RadarLOSmplot(RadarFile,RadarStartTime,RadarEndTime,scale,error)

% mnorthlat=82.599;
% mnorthlon=-84.373;
% [x0,y0] = mfwdtran(mnorthlat,mnorthlon);
% plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[0 0 0],'MarkerSize',10);


% If linestep==0, no vectors plotted, if indexes=0, all data is used for
% plot

%% Video plot
%DMSPvideomanager(latplot,lonplot,latitude,longitude,mlt1,time1,vh,DMSPn,0,10,60)
