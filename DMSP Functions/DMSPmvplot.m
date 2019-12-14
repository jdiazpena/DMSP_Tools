function DMSPmvplot(latplot,lonplot,type,data,mltvar, linestep, ttick, color,indexesplot,scale,startHL,endHL,mnorthlat,mnorthlon)

%% DMSPmvplot.m DMSP data plot on map of horizontal to orbit velocity vectors
%--------------------------------------------------------------------------
% Input
%------
% Latplot   - [minlat maxlat] vectors for the map
% Lonplot   - [minlon maxlon] vectors for the map
% type      - String referencing the type of plot
%           cilindrical: latitude longitude plot in cilindrical projection
%           (cartesian coordinates)
%           north: azimuthal projection from the north pole (polar
%           coordinates)
% data      - struct of DMSP data as obtained from DMSPdatafetch.m (Madrigal
%           case)
% mltvar    - 'ut' or 'mlt' representing the time to be displayed on map
% linestep  - step taken for each vector to be plotted. 0 means no vectors
%           plotted
% ttick     - seconds between time ticks to be shown
% color     - Color of vectors to be plotted in [R G B]
% indexsplot- Indexes of from data to be plotted. 0 means all data is used.
%           Data indexes can be obtained using DMSPtimesi.m
% scale     - Factor by which the velocities are divided (originally m/s)
% indexHL   - Index of vectors to be highlighted.
% mnorthlat - Latitude of magnetic north.
% mnorthlon - longitude of magnetic north. 
%--------------------------------------------------------------------------
% Output
%------
% Map figure with velocity vectors plotted, the sun is always at the top of
% the figure. 
%--------------------------------------------------------------------------
% Modified: 28th Jun 2018  Added Conical plot
% Created : 05th Jun 2018
% Author  : Joaquin Diaz Pena
% Ref     : 
%--------------------------------------------------------------------------

if indexesplot==0
    latitude=data.latitude;
    longitude=data.longitude;
    mlt1=data.mlt1;
    time=data.time1;
    vh=data.vh;
    DMSPn=data.DMSPn;
else
    latitude=data.latitude(indexesplot);
    longitude=data.longitude(indexesplot);
    mlt1=data.mlt1(indexesplot);
    time=data.time1(indexesplot);
    vh=data.vh(indexesplot);
    DMSPn=data.DMSPn;
end

%mapgenerator(type,latplot,lonplot)

%% Data 

% % Eliminate the problem of passings at 0 longitude
%     cindex=findlongitude(longitude);
% % Update data
%     lat=latitude(cindex);
%     lon=longitude(cindex);
%     mlt1=mlt1(cindex);
%     time=time(cindex);
%     vh=vh(cindex);
lat=latitude;
lon=longitude';


if strcmp('north',type)==0
    deltalat=latplot;
    if lonplot(1)>0 && lonplot(2)<0
        deltalon1=[-180 lonplot(2)];
        deltalon2=[lonplot(1) 180];  
        indexes1=indexlatlon(lat,lon,deltalat,deltalon1);
        indexes2=indexlatlon(lat,lon,deltalat,deltalon2);
        if length(indexes2)==1 && length(indexes1)==1
                    error('Error, no data on desire map')
        else
            if indexes1==0
                indexes=indexes2;
            else
                if indexes2==0
                    indexes=indexes1;
                else
                    indexes=[indexes1 indexes2];
                end
            end
        end
    else
        deltalon=lonplot;
        indexes=indexlatlon(lat,lon,deltalat,deltalon);
    end
    lat=lat(indexes);
    lon=lon(indexes);
    timemlt=mlt1(indexes);
    timeut=time(indexes);
    vh=vh(indexes);
else
    deltalon=[-180 180];
    deltalat=[latplot(1) 90];
    indexes=indexlatlon(lat,lon,deltalat,deltalon);
    lat=lat(indexes);
    lon=lon(indexes);
    timemlt=mlt1(indexes);
    timeut=time(indexes);
    vh=vh(indexes);
end

% Find indexes for every pass at the geographical area at those times
newindexes=indexmanagment(indexes);
% a=newindexes(1,1):newindexes(2,1);
% b=newindexes(1,2):newindexes(2,2);
% c=newindexes(1,3):newindexes(2,3);
% d=newindexes(1,4):newindexes(2,4);
% f=newindexes(1,5):newindexes(2,5);
% g=newindexes(1,6):newindexes(2,6);


%% Mark indexes for highlight

if sum(startHL==0)==0 || sum(endHL==0)==0
    [indexbHL, indexeHL]=DMSPtimesi(startHL,endHL,timeut);
    indexesHL=indexbHL:indexeHL;
else
    indexesHL=0;
end




%% B projection

% lat0=zeros(1,length(lat));
% lon0=zeros(1,length(lat));
% altd=zeros(1,length(lat));
% 
% for i=1:size(lat)
%     [lat0(i), lon0(i), altd(i)]=geo2btrace(time(indexes(i)),lat(i),lon(i),altitude(indexes(i)),100);
%     i
% end

%% Time stamps

if ttick~=0
    textindex=1:ttick:length(lat);
    
    if strcmp(mltvar,'mlt')==1
        mlttime=mltmanage(timemlt);
        struse=mlttime;
    else
        struse=datestr(timeut);
        struse=struse(:,13:17);
    end
    strlat=lat(textindex);
    strlon=lon(textindex);
    strusef=struse(textindex,:);
    displaytime=datestr(timeut);
    displaytime=displaytime(1,1:11);
    textm(strlat'+2, strlon+2, strusef, 'FontSize',8,'Color', 'r')
%     for i=1:length(lat(textindex))
%         linem([strlat(i) strlat(i)+1],[strlon(i) strlon(i)+5],'r')
%     end   
end

if strcmp(mltvar,'mlt')==1
      TitleH=title(['Sunward velocity from DMSP', num2str(DMSPn), ' in MLT - ', displaytime]);
else
      TitleH=title(['Sunward velocity from DMSP', num2str(DMSPn), ' in UT - ', displaytime]);
end
% if strcmp('north',type)==0
%     set(TitleH, 'Position', [1.0204e-06 1.7191 0], ...
%     'VerticalAlignment', 'bottom', ...
%     'HorizontalAlignment', 'center')
% end


%% Vector plot

for w=1:size(newindexes,2)
    DMSPorbitplot(lat,lon,timemlt,vh,type,newindexes(1,w):newindexes(2,w),scale,linestep,color,indexesHL,mnorthlat,mnorthlon)
end
 %% Data scatter for color coding
    
    scatterm(lat',lon,3,vh,'filled');
    colormap(jet)
    hc=colorbar;
    title(hc,'V (m/s)');


