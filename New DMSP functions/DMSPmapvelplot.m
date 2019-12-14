function DMSPmapvelplot(latplot,lonplot,type,data,...
                        linestep, ttick,indexesplot,scale,...
                        startHL,endHL,obctimes,fig)

%% DMSPmvplotUTD.m DMSP data plot on map of horizontal to orbit velocity vectors
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
% data      - struct of DMSP data as obtained from DMSPdatafetchUT.m
% mltvar    - 'ut' or 'mlt' representing the time to be displayed on map
% linestep  - step taken for each vector to be plotted. 0 means no vectors
%           plotted
% ttick     - seconds between time ticks to be shown
% color     - Color of vectors to be plotted in [R G B]
% indexsplot- Indexes of from data to be plotted. 0 means all data is used.
%             Data indexes can be obtained using DMSPtimesi.m
% scale     - Factor by which the velocities are divided (originally m/s)
% startHL   - Index of vectors to be highlighted.
% endHL     - Index of vectors to be highlighted.
% mnorthlat - Latitude of magnetic north.
% mnorthlon - Longitude of magnetic north. 
% obctimes  - Times to put OBC marks
%--------------------------------------------------------------------------
% Output
%------
% Map figure with velocity vectors plotted, the sun is always at the top of
% the figure. 
%--------------------------------------------------------------------------
% Modified: 26th Sep 2018  Now manages UTdallas plots and better
% perpendicular plot
% Created : 05th Jun 2018
% Author  : Joaquin Diaz Pena
% Ref     : 
%--------------------------------------------------------------------------
mltvar='ut';

if indexesplot==0
%     latitude=data.latitude;
%     longitude=data.longitude;
    mlt1=data.mlt1;
    mlat=data.maglat;
    time=data.timeS;
    vh=data.vh;
    DMSPn=data.DMSPn;
else
%     latitude=data.latitude(indexesplot);
%     longitude=data.longitude(indexesplot);
    mlt1=data.mlt1(indexesplot);
    mlat=data.maglat(indexesplot);
    time=data.timeS(indexesplot);
    vh=data.vh(indexesplot);
    DMSPn=data.DMSPn;
end

lon=mlt1*15;
lat=mlat;


if strcmp('northM',type)==0 && strcmp('north',type)==0
    deltalat=latplot;
    if lonplot(1)>lonplot(2)
        deltalon1=[0 lonplot(2)];
        deltalon2=[lonplot(1) 360];  
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
    mlat=mlat(indexes);
    timeut=time(indexes);
    vh=vh(indexes);
else
    deltalon=[0 360];
    deltalat=[latplot(1) 90];
    indexes=indexlatlon(lat,lon,deltalat,deltalon);
    lat=lat(indexes);
    lon=lon(indexes);
    timemlt=mlt1(indexes);
    timeut=time(indexes);
    vh=vh(indexes);
    mlat=mlat(indexes);

end

vh(vh==-9999)=NaN;

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
    [xt,yt]=latlon2cart(strlat',strlon);
    [strlatf,strlonf]=cart2latlon(xt-3,yt);
    %this part needs fixing, it should find the perpendicular to each point
    %and calculate it. Now this is anoying since my code does it later,
    %need to integrate it to the later part rather than doing it now at
    %this point. 

%     textm(strlatf, strlonf, strusef, 'FontSize',8,'Color', 'k')
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
    DMSPorbitplot_V2(lat,lon,timeut,timemlt,vh,...
                     type,newindexes(1,w):newindexes(2,w),scale,linestep,indexesHL,...
                     obctimes,ttick,mltvar,fig)
end
 %% Data scatter for color coding

    hc=colorbar;
    hc.Location='southoutside';
    title(hc,'V (m/s)');
    caxis([-1000 1000])
