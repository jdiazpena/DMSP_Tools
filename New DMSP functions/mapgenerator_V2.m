function fig=mapgenerator_V2(type,latplot,lonplot)

%% mapgenerator.m Initialize map canvas for DMSP or any other sensor data plot
%--------------------------------------------------------------------------
% Input
%------
% type - String referencing the type of plot
%           cilindrical: latitude longitude plot in cilindrical projection
%           (cartesian coordinates)
%           north: azimuthal projection from the north pole (polar
%           coordinates)
% Latplot - [minlat maxlat] vectors for the map
% Lonplot - [minlon maxlon] vectors for the map
%--------------------------------------------------------------------------
% Output
%------
% Map figure
%--------------------------------------------------------------------------
% Modified: 13th Jun 2018  Added Conical plot
% Created : 05th Jun 2018
% Author  : Joaquin Diaz Pena
% Ref     : 
%--------------------------------------------------------------------------


%% Alaska cylindrical plot

if strcmp('cylindrical',type)==1
    fig=figure;
    axesm ('pcarree', 'Frame', 'on', 'Grid', 'on', 'MapLatLimit',latplot,'MapLonLimit',lonplot);
    load coastlines
    geoshow(coastlat,coastlon,'DisplayType','polygon','FaceColor','w')
    framem on
    gridm on
    mlabel on
    plabel on
    axis off
    hold on
end

%% Alaska Plots
% 
% if type==2
%     figure
%     ax=usamap('alaska');
%     alaskahi = shaperead('usastatehi', 'UseGeoCoords', true,...
%               'Selector',{@(name) strcmpi(name,'Alaska'), 'Name'});
%     geoshow(alaskahi, 'FaceColor', [1 1 1]);
% 
%     % latlim = getm(ax, 'MapLatLimit');
%     % lonlim = getm(ax, 'MapLonLimit');
% end

if strcmp('conical',type)==1
%     figure
%     ax=axesm ('murdoch1', 'Frame', 'on', 'Grid', 'on', 'MapLatLimit',latplot,'MapLonLimit',lonplot)
%     load coastlines
%     geoshow(coastlat,coastlon,'DisplayType','polygon','FaceColor','w')
%     framem on
%     gridm on
%     mlabel on
%     plabel on
%     axis off
%     hold on
    load coastlines
    fig=figure('Color','w');
    axesm('eqdazim','Origin',[90 0 0],'FLatLimit',[-inf 30],'MapLonLimit',lonplot)
    axis off
    framem on
    gridm on
    mlabel on
    plabel on;
    setm(gca,'MLabelParallel',0)
    geoshow(coastlat,coastlon,'DisplayType','polygon','FaceColor','w')
    hold on
end

%% North Pole plots

if strcmp('north',type)==1
    load coastlines
    fig=figure('Color','w');
    axesm('eqdazim','MapLatLimit',latplot);
    axis off
    framem on
    gridm on
    mlabel on
    plabel on;
    setm(gca,'MLabelParallel',0)
    geoshow(coastlat,coastlon,'DisplayType','polygon','FaceColor','w','EdgeColor',[0.7 0.7 0.7])
    hold on
    view([0 90])
    %direction = [1 0 0];
    %rotate(ax,direction,180)
    %camroll(-180)
end

if strcmp('northM',type)==1
    fig=figure('Color','w');
    axesm('eqdazim','MapLatLimit',latplot, 'PLineLocation',5,'LabelFormat','none');
    axis off
    framem on
    gridm on
    mlabel on
    plabel on;
    setm(gca,'MLabelParallel',10)
    hold on
    view([0 90])
    %direction = [1 0 0];
    %rotate(ax,direction,180)
    %camroll(-180)

end