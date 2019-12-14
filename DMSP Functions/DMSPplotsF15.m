function DMSPplotsF15(InitialTime,FinalTime,data,ticks)

%% DMSPplotsF15.m DMSP time series plot of DMSP F15 velocity data and density
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
% Time series plot of the data Ion velocity, Density, TI Oxygen Ratio
%--------------------------------------------------------------------------
% Modified: 26th Jun 2018 
% Created : 26th Jun 2018
% Author  : Joaquin Diaz Pena
% Ref     : 
%--------------------------------------------------------------------------

time=data.time1;
time2=data.time2;
latitude=data.latitude;
longitude=data.longitude;
vz=data.vz;
vh=data.vh;
Ne=data.Ne;
Oratio=data.Oratio;
DMSPn=data.DMSPn;
Ti=data.Ti;

initt=datenum(InitialTime);
endt=datenum(FinalTime);

% Find closest time to desire interval
indexi=find(abs((time-initt))==min(abs(time-initt)));
indexe=find(abs((time-endt))==min(abs(time-endt)));


% Set time and geographical coordinates
timem=time(indexi:indexe);
latm=latitude(indexi:indexe);
lonm=longitude(indexi:indexe);


%Set Length for Oratio vector 
sizetime1=size(time);
newOr=zeros(sizetime1(1),1);
newOr(1:4:end) = Oratio(:,:);
for i=1:sizetime1(1)
    if newOr(i)==0
        newOr(i)=NaN;
    end
end

%Set Length for Ti vector 
sizetime1=size(time);
newTi=zeros(sizetime1(1),1);
newTi(1:4:end) = Ti(:,:);
for i=1:sizetime1(1)
    if newTi(i)==0
        newTi(i)=NaN;
    end
end

% Interpolate time for 2 set of measurements
OratioN=fillmissing(Oratio,'spline');
errorreducer=linspace(0, 1, length(OratioN)).*1E-8;
d=errorreducer';
OratioU=OratioN+d;
Interpolated=interp1(time2,OratioU,time,'spline');

% Interpolate Ti for 2 set of measurements
TiN=fillmissing(Ti,'spline');
errorreducer=linspace(0, 1, length(TiN)).*1E-8;
d=errorreducer';
TiU=TiN+d;
InterpolatedTi=interp1(time2,TiU,time,'spline');

deltax=0.21;
fontsize=10;


% Plot Density
figure;
s1=subplot(4,1,1);
set(s1, 'Position', get(s1,'Position')-[0 0 -0.05 -0.04]);

plot(timem,log10(Ne(indexi:indexe)),'k');
hold on
plot(timem,real(log10(Interpolated(indexi:indexe).*Ne(indexi:indexe))),'r');
grid on

title(['DMSP ', num2str(DMSPn) ,' -- ',  datestr(timem(1))]);

ax1 = gca;
drawnow; pause(0.1);
yruler = ax1.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax1.XRuler;
xruler.Axle.Visible = 'off';

mavz=max(log10(Ne(indexi:indexe)));
mavh=max(real(log10(Interpolated(indexi:indexe).*Ne(indexi:indexe))));
mav=max(mavz,mavh);
mav=round(mav+1);
mivz=min(log10(Ne(indexi:indexe)));
mivh=min(real(log10(Interpolated(indexi:indexe).*Ne(indexi:indexe))));
miv=min(mivz,mivh);
miv=round(miv-1);
yaxisticks=miv:1:mav;
set(gca,'ylim',[miv mav]);
set(gca,'YTick',yaxisticks)
legend('Ni','O+','Location','southwest','Orientation','horizontal');
ylabel('Density log_1_0 [m^-^3]','fontsize',fontsize);



% Plot O ratio
s2=subplot(4,1,2);
set(s2, 'Position', get(s1,'Position')-[0 deltax 0 0]);

plot(timem,newOr(indexi:indexe),'r.','MarkerSize',12);
hold on
plot(timem,Interpolated(indexi:indexe),'k');
grid on

ax2 = gca;
drawnow; pause(0.1);
yruler = ax2.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax2.XRuler;
xruler.Axle.Visible = 'off';

ylabel('[O+]/[Ni] ratio','fontsize',fontsize);
legend('[O+]/[Ni] Data','[O+]/[Ni] Interp','Location','southwest','Orientation','horizontal');
axis([min(timem) max(timem) 0 1.5]);


% Plot Ti
s22=subplot(4,1,3);
set(s22, 'Position', get(s2,'Position')-[0 deltax 0 0]);

plot(timem,newTi(indexi:indexe),'r.','MarkerSize',6);
hold on
plot(timem,InterpolatedTi(indexi:indexe),'k');
grid on

ax22 = gca;
drawnow; pause(0.1);
yruler = ax22.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax22.XRuler;
xruler.Axle.Visible = 'off';

mavz=max(newTi(indexi:indexe));
mavh=max(real(InterpolatedTi(indexi:indexe)));
mav=max(mavz,mavh);
mav=round(mav+1000,-3);
mivz=min(newTi(indexi:indexe));
mivh=min(real(InterpolatedTi(indexi:indexe)));
miv=min(mivz,mivh);
miv=round(miv-1000,-3);
set(gca,'ylim',[miv mav]);
set(gca,'YTick',miv:1000:mav)
ylabel('Temperature [K]','fontsize',fontsize);
legend('Ti','Ti Interpolation','Location','northwest','Orientation','horizontal');
axis([min(timem) max(timem) 0 5000]);


% Plot Velocity
s3=subplot(4,1,4);
set(s3, 'Position', get(s22,'Position')-[0 deltax 0 0]);

plot(timem,vz(indexi:indexe),'k');
hold on
plot(timem,vh(indexi:indexe),'r');
grid on


ax3 = gca;
drawnow; pause(0.1);
yruler = ax3.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax3.XRuler;
xruler.Axle.Visible = 'off';

mavz=max(vz(indexi:indexe));
mavh=max(vh(indexi:indexe));
mav=max(mavz,mavh);
mav=round(mav+1000,-3);
yaxisticks=linspace(-mav,mav,5);
set(gca,'ylim',[-mav mav]);
set(gca,'YTick',yaxisticks)
ylabel('V_{Ion} [m/s]','fontsize',fontsize);

legend('Vertical','Horizontal','Location','southwest','Orientation','horizontal');
txtHandle = text(-0.05, -0.1, 'UT','Units','normalized','FontSize',fontsize);
set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');
txtHandle = text(-0.05, -0.24, 'Lat','Units','normalized','FontSize',fontsize);
set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');
txtHandle = text(-0.05, -0.38, 'Lon','Units','normalized','FontSize',fontsize);
set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');

% axis for lonlat
set(ax1,'Units','normalized','fontsize',fontsize,'XColor','k','Color','w');
set(ax2,'Units','normalized','fontsize',fontsize,'XColor','k','Color','w');
set(ax3,'Units','normalized','fontsize',fontsize);
set(ax22,'Units','normalized','fontsize',fontsize,'XColor','k','Color','w');

baxis2=get(s3,'Position');
b3=axes('Position',[baxis2(1) baxis2(2)-0.03  baxis2(3) 1e-12]);
set(b3,'Units','normalized');
set(b3,'Color','none','fontsize',fontsize);
b3.TickLength = [0 0];

c3=axes('Position',[baxis2(1) baxis2(2)-0.06  baxis2(3) 1e-12]);
set(c3,'Units','normalized','fontsize',fontsize);
set(c3,'Color','none');
c3.TickLength = [0 0];


 % set limits and labels
set(ax1,'xlim',[min(timem) max(timem)]);
set(ax2,'xlim',[min(timem) max(timem)]);
set(ax22,'xlim',[min(timem) max(timem)]);
set(ax3,'xlim',[min(timem) max(timem)]);
set(b3,'xlim',[min(timem) max(timem)]);
set(c3,'xlim',[min(timem) max(timem)]);

pticks=ticks;
ti=pticks;
cx=zeros([1,ti+1]);
size2=indexe-indexi;

for i=1:ti+1
    cx(i)=(1+(i-1)*round(size2/ti));
end

tick1=timem(1:round(size2/ti):end)';

tick2=cell([1,ti+1]);
for i=1:ti+1
    tick2{i}=num2str(round(latm(cx(i)),1));
end
tick3=cell([1,ti+1]);
for i=1:ti+1
    tick3{i}=num2str(round(lonm(cx(i)),1));
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
xticklabels(ax3,tick0)
xticks(ax22,tick1);
xticklabels(ax22,[])
xticks(b3,tick1);
xticklabels(b3,tick2)
xticks(c3,tick1);
xticklabels(c3,tick3)

drawnow; pause(0.1);
xruler = b3.XRuler;
xruler.Axle.Visible = 'off';
xruler = c3.XRuler;
xruler.Axle.Visible = 'off';
