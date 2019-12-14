function data=DMSPdatafetchUT(fileNameStr1,Sat,fileNameStr2, fileNameStr3)

%% UTDMSPdatafetch.m DMSP data fetching from UTD hdf5 file
%--------------------------------------------------------------------------
% Input
%------
% fileNameStr1   - Name of first hdf5 file of DMSP, taken from Python code
%                  that manages Marc Hariston UT Dallas ASCII file data
% fileNameStr2   - Name of second hdf5 file of DMSP, sampling frequency of
%                  4 seconds. Includes Energy. Taken from Madrigal. 
%--------------------------------------------------------------------------
% Output
%------
% Data            - Structure of data that includes almost all data inside
%                   the hdf5 file
%--------------------------------------------------------------------------
% Modified: 28th Mar 2019 
% Created : 08th Aug 2018
% Author  : Joaquin Diaz Pena
% Ref     : 
%--------------------------------------------------------------------------

date=h5read(fileNameStr1,'/Date');
sec=h5read(fileNameStr1,'/Time');

data.time=datenum(managedate(date,sec,Sat));
data.Oratio=h5read(fileNameStr1,'/O');
data.Hratio=h5read(fileNameStr1,'/H');
data.Heratio=h5read(fileNameStr1,'/He');
data.latitude=h5read(fileNameStr1,'/GLAT');
data.longitude=h5read(fileNameStr1,'/GLONG');
data.altitude=h5read(fileNameStr1,'/Alt');
data.mlt1=h5read(fileNameStr1,'/MLT');
data.maglat=h5read(fileNameStr1,'/MLAT');
data.Ne=h5read(fileNameStr1,'/Ni');
data.vz=h5read(fileNameStr1,'/Vz');
data.vh=h5read(fileNameStr1,'/Vy');
data.vx=h5read(fileNameStr1,'/Vx');
data.Ti=h5read(fileNameStr1,'/Ti');
data.Te=h5read(fileNameStr1,'/Te');
data.IDM=h5read(fileNameStr1,'/I');
data.RPA=h5read(fileNameStr1,'/R');
data.DMSPn=num2str(Sat);


% Energy data is still taken from MADRIGAL
if Sat~=15
    all_data1 = h5read(fileNameStr2,'/Data/Table Layout');
    IEflux=(all_data1.ion_d_ener);
    eEflux=(all_data1.el_d_ener);
    IEflux(IEflux==0)=NaN;
    eEflux(eEflux==0)=NaN;
    IEflux=log10(IEflux);
    eEflux=log10(eEflux);
    centralenergy=(all_data1.ch_ctrl_ener);
    spacingenergy=(all_data1.ch_energy);
    dt = reshape(datetime( all_data1.ut1_unix, 'ConvertFrom', 'posixtime' ),19,[]);
    data.time1str=datestr( dt(1,:) );
    data.time1=datenum( data.time1str );
    data.centralenergy=reshape(spacingenergy,19,[]);
    data.spaengenergy=reshape(centralenergy,19,[]);
    data.IEflux=reshape(IEflux,19,[]);
    data.eEflux=reshape(eEflux,19,[]);
end


if isempty(fileNameStr3)==0
    all_data2 = h5read(fileNameStr3,'/Data/Table Layout');
    data.diff_bd=all_data2.diff_bd;
    data.diff_bfor=all_data2.diff_b_for;
    data.diff_bperp=all_data2.diff_b_perp;
    data.bd=all_data2.bd;
    data.bfor=all_data2.b_forward;
    data.bperp=all_data2.b_perp;
    
    dt = datetime( all_data2.ut1_unix, 'ConvertFrom', 'posixtime' );
    data.time2str=datestr( dt );
    data.time2=datenum( data.time2str );
    data.latitude2=all_data2.gdlat;
    data.longitude2=all_data2.glon;
    data.altitude2=all_data2.gdalt;
end