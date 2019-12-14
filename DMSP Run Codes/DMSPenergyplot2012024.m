%Plots Energy deposition for DMSP16, one time thing



% fileNameStr = 'F162012024.h5';
% fileNameStr2= 'dms_20120124_16e.001.hdf5';
% fileNameStr4='dms_20120124_16s1.001.hdf5';
% 
% data=DMSPdatafetchUT(fileNameStr,16,fileNameStr2,fileNameStr4);

load DMSPpoytngtest.mat

close all

InitialTime='01/24/2012 11:30:00';
FinalTime='01/24/2012 12:10:00';

time=data.time;
time2=data.time2;
latitude=data.latitude;
longitude=data.longitude;
bd=data.diff_bd;
bfor=data.diff_bfor;
bperp=data.diff_bperp;
bdmodel=data.bd;
bformodel=data.bfor;
bperpmodel=data.bperp;
vx=-data.vz;
vz=-data.vh;

initt=datenum(InitialTime);
endt=datenum(FinalTime);

% Find closest time to desire interval
indexi=find(abs((time-initt))==min(abs(time-initt)));
indexe=find(abs((time-endt))==min(abs(time-endt)));

indexi2=find(abs((time2-initt))==min(abs(time2-initt)));
indexe2=find(abs((time2-endt))==min(abs(time2-endt)));


% Set time and geographical coordinates for original data
timem=time(indexi:indexe);
latm=latitude(indexi:indexe);
lonm=longitude(indexi:indexe);
vxm=vx(indexi:indexe);
vzm=vz(indexi:indexe);

bdm=bd(indexi2:indexe2);
bform=bfor(indexi2:indexe2);
bperpm=bperp(indexi2:indexe2);
bdmodelm=bdmodel(indexi2:indexe2);
bformodelm=bformodel(indexi2:indexe2);
bperpmodelm=bperpmodel(indexi2:indexe2);



% Eliminate the problem of passings at 0 longitude
    cindex=findlongitude(lonm);
% Update data
    timem=timem(cindex);
    latm=latm(cindex);
    lonm=lonm(cindex);
    vxm=vxm(cindex);
    vzm=vzm(cindex);

    bdm=bdm(cindex);
    bform=bform(cindex);
    bperpm=bperpm(cindex);
    bdmodelm=bdmodelm(cindex);
    bformodelm=bformodelm(cindex);
    bperpmodelm=bperpmodelm(cindex);   

mu0=4e-7*pi;
pointingflux=((vxm.*bperpmodelm-vzm.*bdmodelm).*bperpm+vxm.*bformodelm.*bform)/mu0;

fontsize=15;


fig2=figure;
plot(timem,pointingflux.*1e3,'k','LineWidth',2)
hold on
ax = gca;
grid on
legend('\mu_0^{-1} E \times B','Location','northwest','fontsize',fontsize)
xlabel('Time UT','fontsize',fontsize)
ylabel('mW/m^2','fontsize',fontsize)
title('DMSP16 Energy Deposition for 24-Jan-2012','fontsize',fontsize)
set(ax,'fontsize',fontsize);

ticks=12;
timeplot=timem;
timeticks=linspace(timeplot(1),timeplot(end),ticks);
timeticksstr=datestr(timeticks);
timeticksstrfinal=timeticksstr(:,13:17);

xticks(ax,timeticks);
xticklabels(ax,timeticksstrfinal)

xlim([datenum('01/24/2012 11:40:00') datenum('01/24/2012 12:04:00')])
    fig2.PaperUnits='inches';
    fig2.PaperPosition = [0 0 9.5 2.5];
    print(fig2,'Pointyng','-dpng','-r300','-opengl')


maptype='north'; %north, conical or cylindrical
latplotA=[60 90];
lonplotA=[-120 60];
fig=mapgenerator(maptype,latplotA,lonplotA);
hold on

OMTImaptest;
h=pcolorm(lat,lon,imfinal*factor);
set(h,'edgecolor','none')
colormap('gray')
caxis([0,1])
freezeColors;

scatterm(latm,lonm,3,pointingflux.*1e3,'filled');
colormap jet
colorbar
caxis([-0.8712    4.6823])
view([180 90])
title(['Poynting Flux [mW/m^2]'])




