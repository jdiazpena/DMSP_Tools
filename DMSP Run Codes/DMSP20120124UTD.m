%% 
% Initialization

% close all;
% 
% clear;
%  
% fileNameStr = 'F152012024.h5';
% data1=DMSPdatafetchUT(fileNameStr,15);
% 
% fileNameStr = 'F162012024.h5';
% fileNameStr2= 'dms_20120124_16e.001.hdf5';
% data2=DMSPdatafetchUT(fileNameStr,16,fileNameStr2);
% 
% fileNameStr = 'F172012024.h5';
% fileNameStr2= 'dms_20120124_17e.001.hdf5';
% data3=DMSPdatafetchUT(fileNameStr,17,fileNameStr2);
% 
% fileNameStr = 'F182012024.h5';
% fileNameStr2= 'dms_20120124_18e.001.hdf5';
% data4=DMSPdatafetchUT(fileNameStr,18,fileNameStr2);
% 
% 
% RadarStartTime = '01/24/2012 12:05:00';
% RadarEndTime = '01/24/2012 12:10:00';
% RadarFile = '20120122.001_lp_5min.h5';

load DMSP2012

error=0.20;

ticks=10;

maptype='north'; %north, conical or cylindrical
timetype='ut';
linestep=5;
ttick=120;
scale=200;
mltvar=1;
textsize=12; %8 for working



latplot=[60 90];
lonplot=[-120 60];

%From AACGMV2
mnorthlat=82.80649308270759;
mnorthlon=-84.43672620476947;

%% Line plot time interval
% timeMinStr='01/24/2012 11:30:00';
% timeMaxStr='01/24/2012 12:10:00';
% DMSPplotsF15UT(timeMinStr,timeMaxStr,data1,ticks)
% % 
timeMinStr='01/24/2012 11:45:00';
timeMaxStr='01/24/2012 12:05:00';
fig2=DMSPplotsENeVUT(timeMinStr,timeMaxStr,data2,ticks,mltvar,textsize)
% % % DMSPplotsViNeOratio(timeMinStr,timeMaxStr,data3,ticks)
% % % DMSPplotsViNeOratio(timeMinStr,timeMaxStr,data4,ticks)
% % %

% DMSPplotsP1UT(timeMinStr,timeMaxStr,data2,ticks,mltvar)

% %  
%  timeMinStr='01/24/2012 11:40:00';
%  timeMaxStr='01/24/2012 12:20:00';
% fig3=DMSPplotsUTAll(timeMinStr,timeMaxStr,data3,ticks,mltvar);
% %  
%  timeMinStr='01/24/2012 12:10:00';
%  timeMaxStr='01/24/2012 12:50:00';
% fig4=DMSPplotsUTAll(timeMinStr,timeMaxStr,data4,ticks,mltvar);

    fig2.PaperUnits='inches';
    fig2.PaperPosition = [0 0 8 8.5];
    print(fig2,'DMSP16','-dpng','-r300','-opengl')
%     fig3.PaperUnits='inches';
%     fig3.PaperPosition = [0 0 8 8.5];
%     print(fig3,'DMSP17','-dpng','-r300','-opengl')
%     fig4.PaperUnits='inches';
%     fig4.PaperPosition = [0 0 8 8.5];
%     print(fig4,'DMSP18','-dpng','-r300','-opengl')
%     print(fig2,'DMSP16','-fillpage','-dpdf','-r300','-opengl')
%     print(fig3,'DMSP17','-fillpage','-dpdf','-r300','-opengl')
%     print(fig4,'DMSP18','-fillpage','-dpdf','-r300','-opengl')


%% Map plot
timeMinStr='01/24/2012 11:30:00';
timeMaxStr='01/24/2012 12:30:00';
% 
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data1.time1);
% indexes1=initd:1:endd;
% 
[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data2.time1);
indexes2=initd:1:endd;
% 
%  timeMinStr='01/24/2012 11:40:00';
%  timeMaxStr='01/24/2012 12:50:00';
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data3.time1);
% indexes3=initd:1:endd;
% 
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data4.time1);
% indexes4=initd:1:endd;

obctimes=['24-Jan-2012 11:49:30';'24-Jan-2012 11:57:00'];



% fig2=mapgenerator(maptype,latplot,lonplot);
% OMTImaptest;
% h=pcolorm(lat,lon,imfinal*factor);
% set(h,'edgecolor','none')
% colormap('gray')
% caxis([0,1])
% freezeColors;
% DMSPmvplotUTD(latplot,lonplot,maptype,data2,timetype,linestep,ttick,indexes2,scale,0,0,mnorthlat,mnorthlon,obctimes)
% 
% [x0,y0] = mfwdtran(mnorthlat,mnorthlon);
% plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[0 0 0],'MarkerSize',10);
% 
% risrlat=74.72955;
% risrlon=-94.90676;
% [x0,y0] = mfwdtran(risrlat,risrlon);
% plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[1 1 0],'MarkerSize',10);

% 
% fig3=mapgenerator(maptype,latplot,lonplot);
% OMTImaptest;
% h=pcolorm(lat,lon,imfinal*factor);
% set(h,'edgecolor','none')
% colormap('gray')
% caxis([0,1])
% freezeColors;
% DMSPmvplotUTD(latplot,lonplot,maptype,data3,timetype,linestep,ttick,indexes2,scale,0,0,mnorthlat,mnorthlon,0)
% 
% mnorthlat=82.599;
% mnorthlon=-84.373;
% [x0,y0] = mfwdtran(mnorthlat,mnorthlon);
% plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[0 0 0],'MarkerSize',10);
% 
% mnorthlat=74.72955;
% mnorthlon=-94.90676;
% [x0,y0] = mfwdtran(mnorthlat,mnorthlon);
% plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[1 1 0],'MarkerSize',10);
% print(fig3,'DMSP17','-fillpage','-dpdf','-r300','-opengl')
% 
% 
% dif4=mapgenerator(maptype,latplot,lonplot);
% OMTImaptest;
% h=pcolorm(lat,lon,imfinal*factor);
% set(h,'edgecolor','none')
% colormap('gray')
% caxis([0,1])
% freezeColors;
% DMSPmvplotUTD(latplot,lonplot,maptype,data4,timetype,linestep,ttick,indexes2,scale,0,0,mnorthlat,mnorthlon,0)
% % RadarLOSmplot(RadarFile,RadarStartTime,RadarEndTime,scale,error)
% 
% mnorthlat=82.599;
% mnorthlon=-84.373;
% [x0,y0] = mfwdtran(mnorthlat,mnorthlon);
% plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[0 0 0],'MarkerSize',10);
% 
% mnorthlat=74.72955;
% mnorthlon=-94.90676;
% [x0,y0] = mfwdtran(mnorthlat,mnorthlon);
% plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[1 1 0],'MarkerSize',10);
% print(fig3,'DMSP18','-fillpage','-dpdf','-r300','-opengl')


% If linestep==0, no vectors plotted, if indexes=0, all data is used for
% plot

%% Video plot
%DMSPvideomanager(latplot,lonplot,latitude,longitude,mlt1,time1,vh,DMSPn,0,10,60)
