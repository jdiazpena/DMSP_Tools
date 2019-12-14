close all
clear

load DMSP2012

ticks=6;
textsize=12; %8 for working
maptype='north'; %north, conical or cylindrical
timetype='ut';
linestep=1;
ttick=120;
scale=200;
mltvar=0;
factor=15;



latplot=[65 90];
lonplot=[-120 60];

%From AACGMV2
mnorthlat=82.80649308270759;
mnorthlon=-84.43672620476947;

%% Line plot time interval
timeMinStr='01/24/2012 11:40:00';
timeMaxStr='01/24/2012 12:05:00';

fig1=DMSPplotsENeVUT(timeMinStr,timeMaxStr,data2,ticks,mltvar,textsize);
fig1.PaperUnits='inches';
fig1.PaperPosition = [0 0 8.5 8.5];
print(fig1,'C:\SDStorage\Google Drive\Matlab\Figures\DMSP16TS','-dpng','-r300','-opengl')

%% Time settings map plot
timeMinStr='01/24/2012 11:30:00';
timeMaxStr='01/24/2012 12:30:00';

[initd, endd]=DMSPtimesi(timeMinStr,timeMaxStr,data2.time1);
indexes=initd:1:endd;
indexesplot=data2.latitude(indexes)>latplot(1);

indexes2=indexes(indexesplot);

obctimes=['24-Jan-2012 11:49:30';'24-Jan-2012 11:57:00'];

%% OMTI Set up
% list = dir('OMTI/*C62*0.abs');
list = dir('D:\Google Drive\Public\Joaquin_Pena\omti\120124\*C62*0.TIF');

directory = 'D:\Google Drive\Public\Joaquin_Pena\omti\120124\';
% cd 'D:\Google Drive\Public\omti\120124\';
keo = zeros(231,size(list,1));

height=230;

latfile= ['omti_glat_',num2str(height),'km.dat'];
lonfile= ['omti_glon_',num2str(height),'km.dat'];

lat = load(latfile);
lat=reshape(lat,256,256);
lon = load(lonfile);
lon=reshape(lon,256,256);

nanpoint = find(lat<-998 | lon <-998);
lat(nanpoint) = NaN;
lon(nanpoint) = NaN;
lon = -(360-lon);
lat=lat(27:253,1:224);
lon=lon(27:253,1:224);

[X, Y] = meshgrid(linspace(-1, 1, 224),linspace(-1,1,227));
R = hypot(X, Y);
circMatrix = R < 0.99;

%times OMTI

for i=1:length(list)
    timestr=list(i).name;
    year=num2str(2000+str2double(timestr(5:6)));
    month=(timestr(7:8));
    day=(timestr(9:10));
    hours=timestr(11:12);
    minute=timestr(13:14);
    second=timestr(15:16);
    timestrfull(i,:)=[month, '/' day '/' year ' ' hours ':' minute ':' second];
    timeomti(i)=datenum(timestrfull(i,:));
end

indexstart=find(abs((timeomti-data2.time1(indexes2(1))))==min(abs((timeomti-data2.time1(indexes2(1))))));
indexend=find(abs((timeomti-data2.time1(indexes2(end))))==min(abs((timeomti-data2.time1(indexes2(end))))));


% timeMinStrHL='01/24/2012 11:54:00';
% timeMaxStrHL='01/24/2012 11:56:00';

%% Loop start

for i=indexstart:1:indexend+1



    filename=[directory, list(i).name];
    fid=fopen(filename, 'rb');
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

    fig2=mapgenerator(maptype,latplot,lonplot);
    h=pcolorm(lat,lon,imfinal*factor);
    set(h,'edgecolor','none')
    colormap('gray')
    caxis([0,1])
    freezeColors;
    
    timeMinStrHL=timestrfull(i,:);
    timeMaxStrHL=timestrfull(i+1,:);
    
    DMSPmvplotUTD(latplot,lonplot,maptype,data2,timetype,linestep,ttick,indexes2,scale,timeMinStrHL,timeMaxStrHL,mnorthlat,mnorthlon,obctimes)

    [x0,y0] = mfwdtran(mnorthlat,mnorthlon);
    plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[0 0 0],'MarkerSize',10);

    risrlat=74.72955;
    risrlon=-94.90676;
    [x0,y0] = mfwdtran(risrlat,risrlon);
    plot(x0,y0,'kp','MarkerEdgeColor', 	[0 0 0],'MarkerFaceColor', 	[1 1 0],'MarkerSize',10);
    
    timeStrname=strrep(timestrfull(i,12:end),' ','_');
    timeStrname=strrep(timeStrname,':','_');
    myFolder = 'C:\SDStorage\Google Drive\Matlab\Figures\';
    print(fig2,[myFolder,'DMSP16', timeStrname],'-fillpage','-dpdf','-r300','-opengl')
end