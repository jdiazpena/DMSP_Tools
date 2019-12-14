%% Simple Run code for analyzing DMSP data
%--------------------------------------------------------------------------
% Output
%------
% Many figures 
%--------------------------------------------------------------------------
% Modified: 
% Created : 15th Nov 2019
% Author  : Joaquin Diaz-Pena (jmdp@bu.edu)
%--------------------------------------------------------------------------

% close all;
% 
% clear;
%  
% UTSSIES = 'F152012024.h5';
% F15data=DMSPdatafetchUT_V2(UTSSIES,15);
% 
% UTSSIES = 'F162012024.h5';
% MADSSJ5= 'dms_20120124_16e.001.hdf5';
% MADSSIES= 'dms_20120124_16s1.001.hdf5';
% F16data=DMSPdatafetchUT_V2(UTSSIES,16,MADSSJ5,MADSSIES);
% 
% UTSSIES = 'F172012024.h5';
% MADSSJ5= 'dms_20120124_17e.001.hdf5';
% MADSSIES= 'dms_20120124_17s1.001.hdf5';
% F17data=DMSPdatafetchUT_V2(UTSSIES,17,MADSSJ5,MADSSIES);
% 
% UTSSIES = 'F182012024.h5';
% MADSSJ4= 'dms_20120124_18e.001.hdf5';
% MADSSIES= 'dms_20120124_18s1.001.hdf5';
% F18data=DMSPdatafetchUT_V2(UTSSIES,18,MADSSJ5,MADSSIES);
% 
% save('DMSPdata2012','F15data','F16data','F17data','F18data')

load DMSPdata2012

error=0.20;

ticks=10;

maptype='northM'; %north, conical or cylindrical
timetype='ut';
linestep=1;
ttick=120;
scale=200;
mltvar=0;
factor=20;

latplot=[60 90];
lonplot=[-120 60];

timeMinStr='01/24/2012 11:30:00';
timeMaxStr='01/24/2012 12:30:00';

obctimes=['24-Jan-2012 11:49:30';'24-Jan-2012 11:57:00'];


[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,F16data.timeS);
indexes=initd:1:endd;

filename='MLTcoord1152apex.h5';

mlat=h5read(filename,'/Magnetic Latitude');
mlt=h5read(filename,'/Magnetic Local Time');

lat=mlat;
lon=mlt;

lat=reshape(lat,256,256);
lon=reshape(lon,256,256);

nanpoint = find(lat<-998 | lon <-998);
lat(nanpoint) = NaN;
lon(nanpoint) = NaN;
lon = lon*15;
lat=lat(27:253,1:224);
lon=lon(27:253,1:224);

[X, Y] = meshgrid(linspace(-1, 1, 224),linspace(-1,1,227));
R = hypot(X, Y);
circMatrix = R < 0.99;

fid=fopen('C62_120124115436_0030.TIF', 'rb');
fseek(fid,8,'bof');% seek ahead to remove the header
%     use uint16, seems like it works
curdata=fread(fid,[256,256],'uint16=>uint16');
im = bitshift(curdata,-2);
fclose(fid);

im=im2double(im);
imflip=fliplr(im);
imflip(nanpoint)=NaN;
imflip=imflip(27:253,1:224);
    
imfinal=imflip.*circMatrix;
imfinal(imfinal==0)=NaN;

fig1=mapgenerator(maptype,latplot,lonplot,1,10);

    h=pcolorm(lat,lon,imfinal*factor);
    set(h,'edgecolor','none')
    colormap('gray')
    caxis([0,1])
    freezeColors;
    
    
    timeMinStrHL='01/24/2012 11:54:36';
    timeMaxStrHL='01/24/2012 11:55:06';

DMSPmapvelplot(latplot,lonplot,maptype,F16data,...
                        linestep, ttick,indexes,scale,...
                        timeMinStrHL,timeMaxStrHL,obctimes,fig1)
                    
[x0,y0] = mfwdtran(82.64,4.9026*15);
plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[1 1 0],'MarkerSize',10); 

    timeStrname=strrep('11:54:36',' ','_');
    timeStrname=strrep(timeStrname,':','_');
    myFolder = 'C:\SDStorage\Google Drive\Matlab\Figures\';
    print(fig1,[myFolder,'DMSPOMTI', timeStrname],'-fillpage','-dpdf','-r300','-opengl')
                    
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,F17data.timeS);
% indexes=initd:1:endd;
% 
% fig2=mapgenerator_V2(maptype,latplot,lonplot);
% 
% DMSPmapvelplot(latplot,lonplot,maptype,F17data,...
%                         linestep, ttick,indexes,scale,...
%                         0,0,0,fig1)
%                     
%                     
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,F15data.timeS);
% indexes=initd:1:endd;
% 
% fig3=mapgenerator_V2(maptype,latplot,lonplot);
% 
% DMSPmapvelplot(latplot,lonplot,maptype,F15data,...
%                         linestep, ttick,indexes,scale,...
%                         0,0,0,fig1)
% 
%                     
% [initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,F18data.timeS);
% indexes=initd:1:endd;
% 
% fig4=mapgenerator_V2(maptype,latplot,lonplot);
% 
% DMSPmapvelplot(latplot,lonplot,maptype,F18data,...
%                         linestep, ttick,indexes,scale,...
%                         0,0,0,fig1)


