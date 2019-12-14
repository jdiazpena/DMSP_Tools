function data=DMSPdatafetchMAD(fileNameStr1,fileNameStr2,fileNameStr3)

%% DMSPdatafetch.m DMSP data fetching from MADRIGAL hdf5 file
%--------------------------------------------------------------------------
% Input
%------
% fileNameStr1   - Name of first hdf5 file of DMSP, sampling frequency of 1
%                  which contains velocity measurements among others
% fileNameStr2   - Name of second hdf5 file of DMSP, sampling frequency of
%                  4 seconds. Includes ion ratio among others.  
% fileNameStr3   - Name of third hdf5 file of DMSP, sampling frequency of
%                  1 second. Includes energy measurements. 
%--------------------------------------------------------------------------
% Output
%------
% Data            - Structure of data that includes almost all data inside
%                   the hdf5 file
%--------------------------------------------------------------------------
% Modified: 05th Jul 2018 
% Created : 05th Jun 2018
% Author  : Joaquin Diaz Pena
% Ref     : 
%--------------------------------------------------------------------------

all_data = h5read(fileNameStr1,'/Data/Table Layout');
all_data2 = h5read(fileNameStr2,'/Data/Table Layout');


data.Oratio=all_data2.po0x2B;
data.latitude=all_data.gdlat;
data.longitude=all_data.glon;
data.altitude=all_data.gdalt;
data.time1= unix_to_matlab_time(all_data.ut1_unix);
data.time2=unix_to_matlab_time(all_data2.ut1_unix);
data.mlt1=all_data.mlt;
data.mlt2=all_data.mlt;
data.maglat=all_data.mlat;
data.maglon=all_data.mlong;
data.Ne=all_data.ne;
data.vz=all_data.vert_ion_v;
data.vh=all_data.hor_ion_v;
data.bz=all_data.bd;
data.by=all_data.b_perp;
data.bx=all_data.b_forward;
data.Ti=all_data2.ti;
data.Te=all_data2.te;
data.DMSPn=num2str(fileNameStr1(14:15));
if str2double(data.DMSPn)~=15
    all_data3 = h5read(fileNameStr3,'/Data/Table Layout');
    IEflux=(all_data3.ion_d_ener);
    eEflux=(all_data3.el_d_ener);
    IEflux(IEflux==0)=NaN;
    eEflux(eEflux==0)=NaN;
    IEflux=log10(IEflux);
    eEflux=log10(eEflux);
    centralenergy=(all_data3.ch_ctrl_ener);
    spacingenergy=(all_data3.ch_energy);
    time3=unix_to_matlab_time(all_data3.ut1_unix);
    time3=reshape(time3,19,[]);
    
    data.centralenergy=reshape(spacingenergy,19,[]);
    data.spaengenergy=reshape(centralenergy,19,[]);
    data.time3=time3(1,:)';
    data.IEflux=reshape(IEflux,19,[]);
    data.eEflux=reshape(eEflux,19,[]);
end
