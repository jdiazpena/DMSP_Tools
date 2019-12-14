function DMSPorbitplot(latitude,longitude,timeut,tmlt,veh,type,indexplot,scale,linestep,indexesHL,mnorthlat,mnorthlon,...
    obctimes,ttick,mltvar)
%% DMSPorbitplot.m Plot data, called inside DMSPmvplot
%--------------------------------------------------------------------------
% Input
%------
% latitude  - full latitude vector
% longitude - full longitude vector
% tmlt      - mlt time vector
% veh       - Horizontal velocity vector
% type      - String referencing the type of plot
%           cilindrical: latitude longitude plot in cilindrical projection
%           (cartesian coordinates)
%           north: azimuthal projection from the north pole (polar
%           coordinates)
% indexsplot- Indexes of from data to be plotted, taken from
%           indexmanagment function. 
% scale     - Factor by which the velocities are divided (originally m/s)
% linestep  - step taken for each vector to be plotted. 0 means no vectors
%           plotted
% color     - Color of vectors to be plotted in [R G B]
% indexHL   - Index of vectors to be highlighted.
% mnorthlat - Latitude of magnetic north.
% mnorthlon - longitude of magnetic north. 

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



    lat=latitude(indexplot);
    lon=longitude(indexplot);
    timemlt=tmlt(indexplot);
    vh=veh(indexplot);
    timeut=timeut(indexplot);
    
    j=1;
    N=1;
    u=zeros(2,length(1:N:length(lat)-1));
    latu=zeros(1,length(1:N:length(lat)-1));
    lonu=zeros(1,length(1:N:length(lat)-1));
    scalefactor=scale;
    
    %Where is the sun?
    latinit=lat(1);
    loninit=lon(1);
    mltinit=timemlt(1);
    latend=lat(end);
    lonend=lon(end);
    mltend=timemlt(end);
    %linem([90 latinit],[0 loninit],'k')
    %linem([90 latend],[0 lonend],'k')
    [xn,yn]=latlon2cart(mnorthlat,mnorthlon);
    [x0,y0]=latlon2cart(latinit,loninit);
    [x1,y1]=latlon2cart(latend,lonend);
    theta=180/12*(12-mltinit);
    rmatrixsun=[cosd(theta) -sind(theta); sind(theta) cosd(theta)];
    vs=rmatrixsun*[x0-xn;y0-yn];
    vs=vs/norm(vs);
    %[latd,lond]=cart2latlon(vs(1),vs(2));
    %linem([mnorthlat latd],[mnorthlon lond],'r')
    %linem([90 latd],[0 lond],'r')
    theta=180/12*(12-mltend);
    rmatrixsun=[cosd(theta) -sind(theta); sind(theta) cosd(theta)];
    vs1=rmatrixsun*[x1-xn;y1-yn];
    vs1=vs1/norm(vs1);
    %[latd,lond]=cart2latlon(vs1(1),vs1(2));
    %linem([mnorthlat latd],[mnorthlon lond],'r')
    %linem([90 latd],[0 lond],'r')
    vs2=vs1/2+vs/2;
    vs2=90*vs2/norm(vs2);
    xsn=vs2(1)+xn;
    ysn=vs2(2)+yn;
    xs=vs2(1);
    ys=vs2(2);
    [lats,lons]=cart2latlon(xs,ys);
    
    %set the sun at the top of the figure
    view([lons+180 90])
    %[latsn,lonsn]=cart2latlon(xsn,ysn);
    %linem([mnorthlat latsn],[mnorthlon lonsn],'g')
    %linem([90 lats],[0 lons],'g')
    
    % Latitude and longitude smoothing
    [x,y]=latlon2cart(lat,lon');
   
    p1=polyfit(x,y,5);
    error1=sum(abs(polyval(p1,x)-y));

    p2=polyfit(y,x,5);
    error2=sum(abs(polyval(p2,y)-x));
    
    if error1<=error2
        xfinal=x;
        yfinal=polyval(p1,x);
    else
        xfinal=polyval(p2,y);
        yfinal=y;
    end
    
    [lat,lon]=cart2latlon(xfinal,yfinal);
    scatterm(lat,lon,3,vh,'filled');
    colormap(jet)
    caxis([min(vh) max(vh)])

% Times to plot
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
end
    
    
%plot lines

%find times of obc
if obctimes~=0
    indextime=1:linestep:length(lat)-1;
    timevector=timeut(indextime);
    for i=1:size(obctimes,1)
        obc=datenum(obctimes(i,:));
        obcindexes(i)=find(abs(timevector-obc)==min(abs(timevector-obc)));
    end
    obctimes=timevector(obcindexes);
    for i=1:size(obctimes,1)
        obcI(i)=find(abs(timeut-obctimes(i))==min(abs(timeut-obctimes(i))));
    end
else
    obcI=0;
end
    
    if linestep~=0
        for i=1:linestep:length(lat)-1
     
            lat0=lat(i);
            lon0=lon(i);
            lat1=lat(i+1);
            lon1=lon(i+1);  
            latu(j)=lat0;
            lonu(j)=lon0;
     
            if strcmp('cylindrical',type)==1
                m=(lat1-lat0)/(lon1-lon0);
                v=[m,1];
                if m>0
                    rmatrix=[0, 1; -1, 0];
                else
                    rmatrix=[0, -1; 1, 0];
                end
                
                if timemlt(i)<12
                    u(:,j)=(v*rmatrix./norm(v*rmatrix)).*vh(i)/scalefactor;
                end
                if timemlt(i)>=12
                    u(:,j)=-(v*rmatrix./norm(v*rmatrix)).*vh(i)/scalefactor;
                end
                j=j+1;
            else %Northplot
                [x0,y0]=latlon2cart(lat0,lon0);
                [x1,y1]=latlon2cart(lat1,lon1);
                xd=x1-x0;
                yd=y1-y0;
                v=[xd;yd];
                angle = atan2d(xd*ys-yd*xs,xd*xs+yd*ys);
                if angle>0 && angle<=180
                    rmatrix=[0, -1; 1, 0];
                else
                    rmatrix=[0, 1; -1, 0];
                end
                ucart=(rmatrix*v./norm(rmatrix*v)).*vh(i)/scalefactor;
                xf=ucart(1)+x0;
                yf=ucart(2)+y0;
                [latf,lonf]=cart2latlon(xf,yf);
                j=j+1;
                if indexesHL==0
                    linem([lat0 latf],[lon0 lonf],'k')
                else
                    if sum(i==indexesHL)==1
                        linem([lat0 latf],[lon0 lonf],'r')
                    else
                        linem([lat0 latf],[lon0 lonf],'k')
                    end
                end
                if sum(obcI==i)==1    
                    ucartobc=15*(rmatrix*v./norm(rmatrix*v));
                    xf=ucartobc(1)+x0;
                    yf=ucartobc(2)+y0;
                    [latobc,lonobc]=cart2latlon(xf,yf);
                    linem([lat0 latobc],[lon0 lonobc],'r')
                    ucartobc=[-1, 0;0, -1]*ucartobc;
                    xf=ucartobc(1)+x0;
                    yf=ucartobc(2)+y0;
                    [latobc,lonobc]=cart2latlon(xf,yf);
                    linem([lat0 latobc],[lon0 lonobc],'r')
                end
                if sum(textindex==i)==1
                    ucartobc=-abs(5*(rmatrix*v./norm(rmatrix*v)));
                    xf=ucartobc(1)+x0;
                    yf=ucartobc(2)+y0;
                    [lattime,lontime]=cart2latlon(xf,yf);
                    if sum(i==indexesHL)==1
                        linem([lat0 lattime],[lon0 lontime],'Color',[0.6,0.6,0.6])
                        textm(lattime, lontime, struse(i,:), 'FontSize',8,'Color', 'k')
                    else
                        linem([lat0 lattime],[lon0 lontime],'Color',[0.6,0.6,0.6])
                        textm(lattime, lontime, struse(i,:), 'FontSize',8,'Color', 'k')
                    end
                end
                
                %linem([lat0 lat1],[lon0 lon1],'k')
            end 
        end

%         if strcmp('cylindrical',type)==1
%             q=quiverm(latu,lonu,u(1,:),u(2,:),0);
%             set(q,'Color',color)   
%             %mdistort angles
%         end
    end