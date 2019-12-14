%% 
% Initialization

clear;
close all;
fileNameStr = 'dms_20120124_15s1.001.hdf5';
fileNameStr2 = 'dms_20120124_15s4.001.hdf5';
timeMinStr='01/24/2012 11:00:00';
timeMaxStr='01/24/2012 13:00:00';
data=DMSPdatafetch(fileNameStr,fileNameStr2);

fileNameStr = 'dms_20120124_16s1.001.hdf5';
fileNameStr2 = 'dms_20120124_16s4.001.hdf5';
data2=DMSPdatafetch(fileNameStr,fileNameStr2);

fileNameStr = 'dms_20120124_17s1.001.hdf5';
fileNameStr2 = 'dms_20120124_17s4.001.hdf5';
data3=DMSPdatafetch(fileNameStr,fileNameStr2);

fileNameStr = 'dms_20120124_18s1.001.hdf5';
fileNameStr2 = 'dms_20120124_18s4.001.hdf5';
data4=DMSPdatafetch(fileNameStr,fileNameStr2);

ticks=15;
maptype='north'; %north or cilindrical
timetype='ut';
linestep=1;
ttick=60;
scale=250;

%% Line plot time interval

DMSPplots(timeMinStr,timeMaxStr,data3,ticks)

%% Map plot

latplot=[40 90];
lonplot=[160 -100];
%DMSPmplot(latplot,lonplot,1,data.latitude,data.longitude,data.mlt1,data.time1,data.vh,data.DMSPn,timetype,[0.8 0.8 0.8])
%mapgenerator(maptype,latplot,lonplot)
%DMSPmplotest(latplot,lonplot,maptype,data,timetype,linestep,ttick,[0.8 0.8 0.8],0,scale)

% timeMinStr='09/08/2017 13:30:00';
% timeMaxStr='09/08/2017 14:30:00';
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,time1);
% indexes00=initd:1:endd;
% 
% timeMinStr='09/08/2017 15:30:00';
% timeMaxStr='09/08/2017 16:15:00';
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,time1);
% indexes0=initd:1:endd;
% 
% 
% timeMinStr='09/08/2017 17:00:00';
% timeMaxStr='09/08/2017 18:00:00';
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,time1);
% indexes1=initd:1:endd;
% 
% timeMinStr='09/08/2017 19:00:00';
% timeMaxStr='09/08/2017 20:00:00';
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,time1);
% indexes2=initd:1:endd;
% 
% indexes=[indexes00 indexes0 indexes1 indexes2];

[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data.time1);
indexes1=initd:1:endd;

[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data2.time1);
indexes2=initd:1:endd;

[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data3.time1);
indexes3=initd:1:endd;

[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data4.time1);
indexes4=initd:1:endd;


%mapgenerator(maptype,latplot,lonplot)
%DMSPmvplot(latplot,lonplot,maptype,data,timetype,linestep,ttick,[0.8 0.8 0.8],indexes1,scale)

mapgenerator(maptype,latplot,lonplot)
DMSPmvplot(latplot,lonplot,maptype,data2,timetype,linestep,ttick,[0.8 0.8 0.8],indexes2,scale)
mapgenerator(maptype,latplot,lonplot)
DMSPmvplot(latplot,lonplot,maptype,data3,timetype,linestep,ttick,[0.8 0.8 0.8],indexes3,scale)
mapgenerator(maptype,latplot,lonplot)
DMSPmvplot(latplot,lonplot,maptype,data4,timetype,linestep,ttick,[0.8 0.8 0.8],indexes4,scale)


% If linestep==0, no vectors plotted, if indexes=0, all data is used for
% plot

%% Video plot
%DMSPvideomanager(latplot,lonplot,latitude,longitude,mlt1,time1,vh,DMSPn,0,10,60)




