function fig=DMSPplotsUTAll(InitialTime,FinalTime,data,ticks,mltvar)

%% DMSPplots.m DMSP time series plot of DMSP data for F16/17/18
%--------------------------------------------------------------------------
% Input
%------
% InitialTime   - Initial Time to plot in string format, eg '09/08/2017 02:00:00';
% Finaltime     - Final Time to plot in string format, eg '09/08/2017 02:00:00';  
% data          - struct of DMSP data as obtained from DMSPdatafetch.m (Madrigal
%               case)
% ticks         - Number of time ticks on the plot
%--------------------------------------------------------------------------
% Output
%------
% Time series plot of data:
%                           Electron Energy Flux
%                           Density
%                           Ratios
%                           Ti-Te  
%                           A velocity of choosing

%--------------------------------------------------------------------------
% Modified: 18th Sept 2018 % Edited to manage different velocities 
% Created : 05th Jun 2018
% Author  : Joaquin Diaz Pena
% Ref     : 
%--------------------------------------------------------------------------

time=data.time1;
time3=data.time3;
latitude=data.latitude;
longitude=data.longitude;

vz=data.vz;
vh=data.vh;
vx=data.vx;
Ne=data.Ne;

IDM=data.IDM;
RPA=data.RPA;

Oratio=data.Oratio;
Hratio=data.Hratio;
Heratio=data.Heratio;

DMSPn=data.DMSPn;
Ti=data.Ti;
Te=data.Te;
maglat=data.maglat;
mlttime=data.mlt1;

initt=datenum(InitialTime);
endt=datenum(FinalTime);

% Find closest time to desire interval
indexi=find(abs((time-initt))==min(abs(time-initt)));
indexe=find(abs((time-endt))==min(abs(time-endt)));

indexip=find(abs((time3-initt))==min(abs(time3-initt)));
indexep=find(abs((time3-endt))==min(abs(time3-endt)));

% Set time and geographical coordinates
timem=time(indexi:indexe);
latm=latitude(indexi:indexe);
lonm=longitude(indexi:indexe);
mlatm=maglat(indexi:indexe);
mlttimem=mlttime(indexi:indexe);

% Change all -9999 data in ratios to NaN

Oratio(Oratio<=0)=NaN;
Hratio(Hratio<=0)=NaN;
Heratio(Heratio<=0)=NaN;
Ti(Ti<=0)=NaN;
Te(Te<=0)=NaN;


% %Set Length for Ti vector 
% sizetime1=size(time);
% newtime=zeros(sizetime1(1),1);
% newtime(1:4:end) = Ti(:,:);
% for i=1:sizetime1(1)
%     if newtime(i)==0
%         newtime(i)=NaN;
%     end
% end
% 
% % Interpolate time for 2 set of measurements
% OratioN=fillmissing(Oratio,'spline');
% errorreducer=linspace(0, 1, length(OratioN)).*1E-8;
% d=errorreducer';
% OratioU=OratioN+d;
% Interpolated=interp1(time2,OratioU,time,'spline');
% 
% % Interpolate Ti for 2 set of measurements
% TiN=fillmissing(Ti,'spline');
% errorreducer=linspace(0, 1, length(TiN)).*1E-8;
% d=errorreducer';
% TiU=TiN+d;
% InterpolatedTi=interp1(time2,TiU,time,'spline');

% % Interpolate missing data
% % Ratios
% OratioN=fillmissing(Oratio,'pchip');
% HeratioN=fillmissing(Heratio,'pchip');
% HratioN=fillmissing(Hratio,'pchip');
% 
% % Interpolate Ti for 2 set of measurements
% TiN=fillmissing(Ti,'pchip');
% TeN=fillmissing(Te,'pchip');

OratioN=Oratio;
HeratioN=Heratio;
HratioN=Hratio;
TiN=Ti;
TeN=Te;


deltax=0.178;
fontsize=10;




% Plot electron energy flux
fig=figure;
s1=subplot(5,1,1);
set(s1, 'Position', get(s1,'Position')-[0.025 0 -0.03 -0.04]);
originalSize1 = get(s1, 'Position');
yAxis=data.centralenergy(:,1)+data.spaengenergy(:,1)/2;
[X,Y]=meshgrid(time3(indexip:indexep),yAxis);	
zValue=data.eEflux(:,indexip:indexep);
h=pcolor(X,Y,zValue);
title(['DMSP ', num2str(DMSPn) ,' -- ',  datestr(timem(1))]);
set(h,'EdgeColor','none'); 
ax1 = gca;
drawnow; pause(0.1);
yruler = ax1.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax1.XRuler;
xruler.Axle.Visible = 'off';

shading flat;
set(gca,'Layer','top')
hold on;
meandata=nanmean(nanmean(zValue));
stddata=nanstd(nanstd(zValue));
caxis([meandata-3*stddata meandata+3*stddata]);
colormap(jet)
cb1=colorbar('location','eastoutside');
set(s1, 'Position', originalSize1);
set(gca, 'YScale', 'log')
ylabel(cb1, 'Log_{10} Energy Flux ')
y1=ylabel('Electron Eenergy (eV)','fontsize',fontsize);


% Plot Density
s2=subplot(5,1,2);
set(s2, 'Position', get(s1,'Position')-[0 deltax 0 0]);

plot(timem,real(log10(Ne(indexi:indexe))),'k.','MarkerSize',8);
hold on
plot(timem,real(log10(Ne(indexi:indexe))),'k','HandleVisibility','off');
plot(timem,real(log10(OratioN(indexi:indexe).*Ne(indexi:indexe))),'r.','MarkerSize',4);
grid on
ax2 = gca;
drawnow; pause(0.1);
yruler = ax2.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax2.XRuler;
xruler.Axle.Visible = 'off';

%upper bound
maxNe=max(log10(Ne(indexi:indexe)));
maxO=max((log10(OratioN(indexi:indexe).*Ne(indexi:indexe))));
MaxNeO=max([maxNe,maxO]);
MaxNeO=round(MaxNeO+1);
MaxNeO=min(MaxNeO,6);

%lower bound
minNe=min(log10(Ne(indexi:indexe)));
minO=min((log10(OratioN(indexi:indexe).*Ne(indexi:indexe))));
MinNeO=min(minO,minNe);
MinNeO=round(MinNeO-1);
yaxisticks=MinNeO:1:MaxNeO;

set(gca,'ylim',[MinNeO MaxNeO]);
set(gca,'YTick',yaxisticks)
legend('Ni','O+','Location','southwest','Orientation','horizontal');
y2=ylabel('Density log10 [cm^-^3]','fontsize',fontsize);
axis([min(timem) max(timem) MinNeO MaxNeO]);

% Plot ratios
s3=subplot(5,1,3);
set(s3, 'Position', get(s2,'Position')-[0 deltax 0 0]);

plot(timem,OratioN(indexi:indexe),'r.','MarkerSize',4);
hold on
plot(timem,HratioN(indexi:indexe),'b.','MarkerSize',4);
plot(timem,HeratioN(indexi:indexe),'k.','MarkerSize',4);
grid on
ax3 = gca;
drawnow; pause(0.1);
yruler = ax3.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax3.XRuler;
xruler.Axle.Visible = 'off';

set(gca,'ylim',[-0.1 1.1]);
legend('O+','H+','He','Location','southwest','Orientation','horizontal');
y3=ylabel('Density Ratios','fontsize',fontsize);
axis([min(timem) max(timem) -0.1 1.1]);

% Plot ion and electron Temp
s4=subplot(5,1,4);
set(s4, 'Position', get(s3,'Position')-[0 deltax 0 0]);

%TiN(RPA==3)=NaN;
TiP=TiN;
TiF=TiN;
TiG=TiN;
TiP(RPA~=3)=NaN;
TiF(RPA~=2)=NaN;
TiG(RPA~=1)=NaN;
%TiN(RPA==3)=NaN;

plot(timem,TiN(indexi:indexe),'k');
hold on
plot(timem,TiG(indexi:indexe),'k.');
plot(timem,TiF(indexi:indexe),'m.');
plot(timem,TiP(indexi:indexe),'r.');
grid on

ax4 = gca;
drawnow; pause(0.1);
yruler = ax4.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax4.XRuler;
xruler.Axle.Visible = 'off';


maxTi=max(TiN(indexi:indexe));
maxTe=max(TeN(indexi:indexe));
MaxT=max(maxTe,maxTi);
MaxT=round(MaxT+1000,-3);
MaxT=min(MaxT,5000);

minTi=min(TiN(indexi:indexe));
minTe=min(TeN(indexi:indexe));
MinT=min(minTi,minTe);
MinT=round(MinT-1000,-3);

set(gca,'ylim',[MinT MaxT]);
set(gca,'YTick',MinT:1000:MaxT)
y4=ylabel('Temperature [K]','fontsize',fontsize);
legend('Ti','Good', 'Fair', 'Poor','Location','northwest','Orientation','horizontal');
axis([min(timem) max(timem) 0 MaxT]);

% Plot Ion velocity
s5=subplot(5,1,5);
set(s5, 'Position', get(s4,'Position')-[0 deltax 0 0]);
plot(timem,vz(indexi:indexe),'r');
hold on
plot(timem,vh(indexi:indexe),'k');
grid on
ax5 = gca;
drawnow; pause(0.1);
yruler = ax5.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax5.XRuler;
xruler.Axle.Visible = 'off';

mavz=max(vz(indexi:indexe));
mavh=max(vh(indexi:indexe));
mav=max(mavz,mavh);
mav=round(mav+1000,-3);
yaxisticks=linspace(-mav,mav,5);
set(gca,'ylim',[-mav mav]);
set(gca,'YTick',yaxisticks)
y5=ylabel('V-Ion [m/s]','fontsize',fontsize);
legend('Vertical','Horizontal','Location','southwest','Orientation','horizontal');
txtHandle = text(-0.045, -0.12, 'UT','Units','normalized','FontSize',fontsize);
set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');

if mltvar==0
    txtHandle = text(-0.045, -0.3, 'Lat','Units','normalized','FontSize',fontsize);
    set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');
    txtHandle = text(-0.045, -0.48, 'Lon','Units','normalized','FontSize',fontsize);
    set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');
else
    txtHandle = text(-0.045, -0.3, 'MLat','Units','normalized','FontSize',fontsize);
    set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');
    txtHandle = text(-0.045, -0.48, 'MLT','Units','normalized','FontSize',fontsize);
    set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');
end



% Get ylabel locations and set to the furthest one

y1pos=get(y1,'pos');
y2pos=get(y2,'pos');
y3pos=get(y3,'pos');
y4pos=get(y4,'pos');
y5pos=get(y5,'pos');
minx=max([y1pos(1),y2pos(1),y3pos(1),y4pos(1),y5pos(1)])-0.001;
set(y1,'Pos',[minx y1pos(2) y1pos(3)])
set(y2,'Pos',[minx y2pos(2) y2pos(3)])
set(y3,'Pos',[minx y3pos(2) y3pos(3)])
set(y4,'Pos',[minx y4pos(2) y4pos(3)])
set(y5,'Pos',[minx y5pos(2) y5pos(3)])

hpos=get(cb1,'Position');
set(cb1, 'Position', [hpos(1) hpos(2) .0581/3 hpos(4)],'fontsize',8)



% axis for lonlat
set(ax1,'Units','normalized','fontsize',fontsize,'XColor','k','Color','w');
set(ax2,'Units','normalized','fontsize',fontsize,'XColor','k','Color','w');
set(ax4,'Units','normalized','fontsize',fontsize,'XColor','k','Color','w');
set(ax3,'Units','normalized','fontsize',fontsize,'XColor','k','Color','w');
set(ax5,'Units','normalized','fontsize',fontsize);


baxis2=get(s5,'Position');
ax6=axes('Position',[baxis2(1) baxis2(2)-0.03  baxis2(3) 1e-12]);
set(ax6,'Units','normalized');
set(ax6,'Color','none','fontsize',fontsize);
ax6.TickLength = [0 0];


ax7=axes('Position',[baxis2(1) baxis2(2)-0.06  baxis2(3) 1e-12]);
set(ax7,'Units','normalized','fontsize',fontsize);
set(ax7,'Color','none');
ax7.TickLength = [0 0];


 % set limits and labels
set(ax1,'xlim',[min(timem) max(timem)]);
set(ax2,'xlim',[min(timem) max(timem)]);
set(ax3,'xlim',[min(timem) max(timem)]);
set(ax4,'xlim',[min(timem) max(timem)]);
set(ax5,'xlim',[min(timem) max(timem)]);
set(ax6,'xlim',[min(timem) max(timem)]);
set(ax7,'xlim',[min(timem) max(timem)]);

pticks=ticks;
ti=pticks;
cx=zeros([1,ti+1]);
size2=indexe-indexi;

cx(1)=1;
cx(end)=size2;

for i=2:ti
    cx(i)=(1+(i-1)*round(size2/ti));
end

tick1=timem(cx)';

tick2=cell([1,ti+1]);
for i=1:ti+1
    if mltvar==0
        tick2{i}=num2str(round(latm(cx(i)),1));
    else
        tick2{i}=num2str(round(mlatm(cx(i)),1));
    end
end
tick3=cell([1,ti+1]);
for i=1:ti+1
    if mltvar==0
        tick3{i}=num2str(round(lonm(cx(i)),1));
    else
        tick3{i}=num2str(round(mlttimem(cx(i)),1));
    end
end

tick0=cell([1,ti+1]);
for i=1:ti+1
    stringaux=datestr(timem(cx(i)));
    tick0{i}=stringaux(13:17);
end

xticks(ax1,tick1);
xticklabels(ax1,[])
xticks(ax2,tick1);
xticklabels(ax2,[])
xticks(ax3,tick1);
xticklabels(ax3,[])
xticks(ax4,tick1);
xticklabels(ax4,[])
xticks(ax5,tick1);
xticklabels(ax5,tick0)

xticks(ax6,tick1);
xticklabels(ax6,tick2)
xticks(ax7,tick1);
xticklabels(ax7,tick3)

drawnow; pause(0.1);
xruler = ax6.XRuler;
xruler.Axle.Visible = 'off';
xruler = ax7.XRuler;
xruler.Axle.Visible = 'off';


