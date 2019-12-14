function DMSPorbitplot_V2(latitude,longitude,timeut,tmlt,veh,...
                        type,indexplot,scale,linestep,indexesHL,...
                        obctimes,ttick,mltvar,fig)
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
    
    
    
    [x,y]=latlon2cart(lat,lon);
    curvefit = fit(y,x,'poly5','normalize','on');
    xfinal=curvefit(y);
    yfinal=y;
    
    
%     % Latitude and longitude smoothing
%     x=lon;
%     y=lat;
%     
%     
%     curvefit = fit(x,y,'poly9','normalize','on');
%     yfinal=curvefit(x);
%     xfinal=x;
   
%     p1=polyfit(x-mean(x),y,5);
%     error1=sum(abs(polyval(p1,x-mean(x))-y));
% 
%     p2=polyfit(y-mean(y),x,5);
%     error2=sum(abs(polyval(p2,y-mean(y))-x));
%     
%     if error1<=error2
%         xfinal=x;
%         yfinal=polyval(p1,x-mean(x));
%     else
%         xfinal=polyval(p2,y-mean(y));
%         yfinal=y;
%     end
    
%     lon=xfinal;
%     lat=yfinal;

    [lat,lon]=cart2latlon(xfinal,yfinal);
    scatterm(lat,lon,10,vh,'filled');
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
if obctimes==0
    obcI=0;
elseif linestep~=0
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
                
                rmatrix=[0, -1; 1, 0];
 
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
                    ucartobc=abs(5*(rmatrix*v./norm(rmatrix*v)));
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