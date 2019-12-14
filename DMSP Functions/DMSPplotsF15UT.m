function DMSPplotsF15UT(InitialTime,FinalTime,data,ticks)

%% DMSPplotsF15UT.m DMSP time series plot of DMSP F15 velocity data and density
%--------------------------------------------------------------------------
% Input
%------
% InitialTime   - Initial Time to plot in string format, eg '09/08/2017 02:00:00';
% Finaltime     - Final Time to plot in string format, eg '09/08/2017 02:00:00';  
% data          - struct of DMSP data as obtained from DMSPdatafetchUT.m 
% ticks         - Number of time ticks on the plot
%--------------------------------------------------------------------------
% Output
%------
% Time series plot of the data Ion velocity, Density, TI Oxygen Ratio
%--------------------------------------------------------------------------
% Modified: 09th Aug 2018
% Created : 09th Aug 2018
% Author  : Joaquin Diaz Pena
% Ref     : 
%--------------------------------------------------------------------------

time=data.time1;
latitude=data.latitude;
longitude=data.longitude;

vz=data.vz;
vh=data.vh;
vx=data.vx;
Ne=data.Ne;

Oratio=data.Oratio;
Heratio=data.Heratio;
Hratio=data.Hratio;

DMSPn=data.DMSPn;

Ti=data.Ti;
Te=data.Te;

IDM=data.IDM;
RPA=data.RPA;


initt=datenum(InitialTime);
endt=datenum(FinalTime);

% Find closest time to desire interval
indexi=find(abs((time-initt))==min(abs(time-initt)));
indexe=find(abs((time-endt))==min(abs(time-endt)));


% Set time and geographical coordinates
timem=time(indexi:indexe);
latm=latitude(indexi:indexe);
lonm=longitude(indexi:indexe);


% Change all -9999 data in ratios to NaN

Oratio(Oratio<0)=NaN;
Hratio(Hratio<0)=NaN;
Heratio(Heratio<0)=NaN;
Ti(Ti<0)=NaN;
Te(Te<0)=NaN;
vx(vx==-9999.0)=NaN;



% %Set Length for Oratio vector 
% sizetime1=size(time);
% newOr=zeros(sizetime1(1),1);
% newOr(1:4:end) = Oratio(:,:);
% for i=1:sizetime1(1)
%     if newOr(i)==0
%         newOr(i)=NaN;
%     end
% end
% 
% a=1;
% 
% %Set Length for Ti vector 
% sizetime1=size(time);
% newTi=zeros(sizetime1(1),1);
% newTi(1:4:end) = Ti(:,:);
% for i=1:sizetime1(1)
%     if newTi(i)==0
%         newTi(i)=NaN;
%     end
% end

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

deltax=0.21;
fontsize=10;


% Plot Density
figure;
s1=subplot(4,1,1);
set(s1, 'Position', get(s1,'Position')-[0.025 0 -0.1 -0.04]);

plot(timem,log10(Ne(indexi:indexe)),'k');
hold on
plot(timem,(log10(OratioN(indexi:indexe).*Ne(indexi:indexe))),'r');
grid on

title(['DMSP ', num2str(DMSPn) ,' -- ',  datestr(timem(1))]);

ax1 = gca;
drawnow; pause(0.1);
yruler = ax1.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax1.XRuler;
xruler.Axle.Visible = 'off';

%upper bound
maxNe=max(log10(Ne(indexi:indexe)));
maxO=max(real(log10(OratioN(indexi:indexe).*Ne(indexi:indexe))));
MaxNeO=max(maxNe,maxO);
MaxNeO=round(MaxNeO+1);

%lower bound
minNe=min(log10(Ne(indexi:indexe)));
minO=min(real(log10(OratioN(indexi:indexe).*Ne(indexi:indexe))));
MinNeO=min(minO,minNe);
MinNeO=round(MinNeO-1);
yaxisticks=MinNeO:1:MaxNeO;

set(gca,'ylim',[MinNeO MaxNeO]);
set(gca,'YTick',yaxisticks)
legend('Ni','O+','Location','southwest','Orientation','horizontal');
y1=ylabel('Density log_1_0 [m^-^3]','fontsize',fontsize);



% Plot ratios
s2=subplot(4,1,2);
set(s2, 'Position', get(s1,'Position')-[0 deltax 0 0]);

plot(timem,OratioN(indexi:indexe),'k');
hold on
plot(timem,HratioN(indexi:indexe),'r');
plot(timem,HeratioN(indexi:indexe),'b');

grid on

ax2 = gca;
drawnow; pause(0.1);
yruler = ax2.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax2.XRuler;
xruler.Axle.Visible = 'off';

y2=ylabel('Density Ratio','fontsize',fontsize);
legend('[O+]/[Ni]','[H+]/[Ni]','[He+]/[Ni]','Location','northwest','Orientation','horizontal');
axis([min(timem) max(timem) 0 1.5]);


% Plot Ti
s22=subplot(4,1,3);
set(s22, 'Position', get(s2,'Position')-[0 deltax 0 0]);

%Search IDM for flags
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

ax22 = gca;
drawnow; pause(0.1);
yruler = ax22.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax22.XRuler;
xruler.Axle.Visible = 'off';

maxTi=max(TiN(indexi:indexe));
maxTe=max(TeN(indexi:indexe));
MaxT=max(maxTe,maxTi);
MaxT=round(MaxT+1000,-3);
MaxT=min(MaxT,5000);

% minTi=min(TiN(indexi:indexe));
% minTe=min(TeN(indexi:indexe));
% MinT=min(minTi,minTe);
% MinT=round(MinT-1000,-3);
MinT=0;

set(gca,'ylim',[MinT min(MaxT,10000)]);
set(gca,'YTick',MinT:1000:min(MaxT,10000))
y3=ylabel('Temperature [K]','fontsize',fontsize);
legend('Ti','Good', 'Fair', 'Poor','Location','northwest','Orientation','horizontal');
axis([min(timem) max(timem) MinT*0.7 min(MaxT,10000)]);
axis([min(timem) max(timem) MinT MaxT]);


% Plot Velocity
s3=subplot(4,1,4);
set(s3, 'Position', get(s22,'Position')-[0 deltax 0 0]);

vhF=vh;
vhP=vh;
vhI=vh;
vhG=vh;
vhG(IDM~=1)=NaN;
vhI(IDM~=4)=NaN;
vhF(IDM~=2)=NaN;
vhP(IDM~=3)=NaN;

plot(timem,vz(indexi:indexe),'k');
hold on
plot(timem,vh(indexi:indexe),'r');
% plot(timem,vhG(indexi:indexe),'k.');
% plot(timem,vhF(indexi:indexe),'m.');
% plot(timem,vhP(indexi:indexe),'r.');
% plot(timem,vhI(indexi:indexe),'c.');
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
y4=ylabel('V_{Ion} [m/s]','fontsize',fontsize);

%legend('Vy','Good','Fair','Poor','Unditermined','Location','southwest','Orientation','horizontal');
legend('Vertical','Horizontal','Location','southwest','Orientation','horizontal');
txtHandle = text(-0.05, -0.1, 'UT','Units','normalized','FontSize',fontsize);
set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');
txtHandle = text(-0.05, -0.24, 'Lat','Units','normalized','FontSize',fontsize);
set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');
txtHandle = text(-0.05, -0.38, 'Lon','Units','normalized','FontSize',fontsize);
set(txtHandle, 'HorizontalAlignment','right','VerticalAlignment','middle');

% Get ylabel locations and set to the furthest one

y1pos=get(y1,'pos');
y2pos=get(y2,'pos');
y3pos=get(y3,'pos');
y4pos=get(y4,'pos');
minx=max([y1pos(1),y2pos(1),y3pos(1),y4pos(1)])-0.001;
set(y1,'Pos',[minx y1pos(2) y1pos(3)])
set(y2,'Pos',[minx y2pos(2) y2pos(3)])
set(y3,'Pos',[minx y3pos(2) y3pos(3)])
set(y4,'Pos',[minx y4pos(2) y4pos(3)])


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

cx(1)=1;
cx(end)=size2;

for i=2:ti
    cx(i)=(1+(i-1)*round(size2/ti));
end

tick1=timem(cx)';

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
