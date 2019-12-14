function DMSPmplotvideo(latplot,lonplot,latitude,longitude,mlt1,time,vh,DMSPn,mltvar,color,indexplot,interval)




%% Alaska cylindrical plot

    figure
    ax=axesm ('pcarree', 'Frame', 'on', 'Grid', 'on', 'MapLatLimit',latplot,'MapLonLimit',lonplot);
    load coastlines
    geoshow(coastlat,coastlon,'DisplayType','polygon','FaceColor','w')
    framem on
    gridm on
    mlabel on
    plabel on
    axis off

%% Data 

cindex=findlongitude(longitude);

lat=latitude(cindex);
lon=longitude(cindex);
mlt1=mlt1(cindex);
time=time(cindex);
vh=vh(cindex);

deltalat=latplot;
if lonplot(1)>0 && lonplot(2)<0
    deltalon1=[-180 lonplot(2)];
    deltalon2=[lonplot(1) 180];  
    indexes1=indexlatlon(lat,lon,deltalat,deltalon1);
    indexes2=indexlatlon(lat,lon,deltalat,deltalon2);
    indexes=[indexes1 indexes2];
else
    deltalon=lonplot;
    indexes=indexlatlon(lat,lon,deltalat,deltalon);
end
    lat=lat(indexes);
    lon=lon(indexes);
    timemlt=mlt1(indexes);
    timeut=time(indexes);
    vh=vh(indexes);




%% B projection

% lat0=zeros(1,length(lat));
% lon0=zeros(1,length(lat));
% altd=zeros(1,length(lat));
% 
% for i=1:size(lat)
%     [lat0(i), lon0(i), altd(i)]=geo2btrace(time(indexes(i)),lat(i),lon(i),altitude(indexes(i)),100);
%     i
% end

%% Data scatter on map

scatterm(lat,lon,5,vh,'filled');
colormap(jet)
hc=colorbar;
title(hc,'V (m/s)');

textindex=1:60:length(lat);

if mltvar==1
    mlttime=mltmanage(timemlt);
    struse=num2str(mlttime(:,1));
    for i=1:length(struse)
        struse1(i,1:3)=[struse(i,:), ':'];
    end
    struse=[struse1,num2str(mlttime(:,2))];
else
    struse=datestr(timeut);
    struse=struse(:,13:17);
end
textm(lat(textindex), lon(textindex)+0.5, struse(textindex,:), 'FontSize',8)

if mltvar==1
      TitleH=title(['Sunward velocity from DMPS', num2str(DMSPn), ' in MLT']);
else
      TitleH=title(['Sunward velocity from DMPS', num2str(DMSPn), ' in UT']);
end
set(TitleH, 'Position', [1.0204e-06 1.7191 0], ...
 'VerticalAlignment', 'bottom', ...
 'HorizontalAlignment', 'center')


%% Vector plot
    
    scalefactor=750;

    j=1;
    N=1;
    u=zeros(2,length(1:N:length(lat)-1));
    latu=zeros(1,length(1:N:length(lat)-1));
    lonu=zeros(1,length(1:N:length(lat)-1));
    timeuut=zeros(1,length(1:N:length(lat)-1));
    timeumlt=zeros(1,length(1:N:length(lat)-1));
    for i=1:N:length(lat)-1
        lat0=lat(i);
        lon0=lon(i);
        lat1=lat(i+1);
        lon1=lon(i+1);
        m=(lat1-lat0)/(lon1-lon0);
        v=[m,1];
        if m<=0 
            rmatrix=[0, -1; 1, 0];
        else
            rmatrix=[0, 1; -1, 0];
        end
        if timemlt(i)<12
            u(:,j)=(v*rmatrix./norm(v*rmatrix)).*vh(i)/scalefactor;
        end
        if timemlt(i)>=12
            u(:,j)=-(v*rmatrix./norm(v*rmatrix)).*vh(i)/scalefactor;
        end
            latu(j)=lat0;
            lonu(j)=lon0;
            timeumlt(j)=timemlt(i);
            timeuut(j)=timeut(i);
            j=j+1;
    end
    q=quiverm(latu(1:indexplot-1),lonu(1:indexplot-1),u(1,(1:indexplot-1)),u(2,(1:indexplot-1)),0);
    set(q,'Color',[0.8 0.8 0.8])
    
    q1=quiverm(latu(indexplot:indexplot+interval),lonu(indexplot:indexplot+interval),u(1,indexplot:indexplot+interval),u(2,indexplot:indexplot+interval),0);
    set(q1,'Color',color)
    
    q=quiverm(latu(indexplot+interval+1:end),lonu(indexplot+interval+1:end),u(1,indexplot+interval+1:end),u(2,(indexplot+interval+1:end)),0);
    set(q,'Color',[0.8 0.8 0.8])

        



