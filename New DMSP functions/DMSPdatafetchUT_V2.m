function DMSPDATA=DMSPdatafetchUT_V2(SSIESFILENAME,SATNUMBER,MADSSJ5FILENAME,MADFIELDFILENAME)

%% DMSPdatafetchUT_V2.m DMSP data fetching from UTD hdf5 file
%--------------------------------------------------------------------------
% Input
%------
% SSIESFILENAME     - Name of HDF5 file containing SSIES DMSPDATA, this one is 
%                     taken from Python code that manages Marc Hariston UT 
%                     Dallas ASCII file DMSPDATA.
%                     This is a unque format created, so this function is more
%                     ad-hoc
% SATNUMBER         - SATNUMBERellite number (15,16,17 or 18) for bookinging. 
% MADSSJ4FILENAME   - Name of HDF5 file containing energy DMSPDATA (SSJ5)
%                     Taken from Madrigal. Only for F15 this file is
%                     optinal, other satellites need it.
% MADFIELDFILENAME  - Name of HDF5 file containing Magnetic Field and
%                     Electric Field
%                     Taken from Madrigal. Optional for any satellite. 
%--------------------------------------------------------------------------
% Output
%------
% DMSPDMSPDATA          - Structure of DMSPDATA that includes almost all DMSPDATA inside
%                   the hdf5 file
%--------------------------------------------------------------------------
% Modified: DUDE NEED TO FIX THIS, TURN IT INTO DIFFERENT RUNS FOR BOTH F15
% and others
% Created : 15th Nov 2019
% Author  : Joaquin Diaz-Pena (jmdp@bu.edu)
%--------------------------------------------------------------------------


date=h5read(SSIESFILENAME,'/Date');
sec=h5read(SSIESFILENAME,'/Time');

DMSPDATA.timeS=datenum(DMSPmanagedate(date,sec,SATNUMBER));
DMSPDATA.timeSstr=datestr(DMSPDATA.timeS);
DMSPDATA.Oratio=h5read(SSIESFILENAME,'/O');
DMSPDATA.Hratio=h5read(SSIESFILENAME,'/H');
DMSPDATA.Heratio=h5read(SSIESFILENAME,'/He');
DMSPDATA.latitude=h5read(SSIESFILENAME,'/GLAT');
DMSPDATA.longitude=h5read(SSIESFILENAME,'/GLONG');
DMSPDATA.altitude=h5read(SSIESFILENAME,'/Alt');
DMSPDATA.mlt1=h5read(SSIESFILENAME,'/MLT');
DMSPDATA.maglat=h5read(SSIESFILENAME,'/MLAT');
DMSPDATA.Ne=h5read(SSIESFILENAME,'/Ni');
DMSPDATA.vz=h5read(SSIESFILENAME,'/Vz');
DMSPDATA.vh=h5read(SSIESFILENAME,'/Vy');
DMSPDATA.vx=h5read(SSIESFILENAME,'/Vx');
DMSPDATA.Ti=h5read(SSIESFILENAME,'/Ti');
DMSPDATA.Te=h5read(SSIESFILENAME,'/Te');
DMSPDATA.IDM=h5read(SSIESFILENAME,'/I');
DMSPDATA.RPA=h5read(SSIESFILENAME,'/R');
DMSPDATA.DMSPn=num2str(SATNUMBER);


% Energy DMSPDATA is still taken from MADRIGAL
if SATNUMBER~=15
    all_DMSPDATA1 = h5read(MADSSJ5FILENAME,'/Data/Table Layout');
    IEflux=(all_DMSPDATA1.ion_d_ener);
    eEflux=(all_DMSPDATA1.el_d_ener);
    IEflux(IEflux==0)=NaN;
    eEflux(eEflux==0)=NaN;
    IEflux=log10(IEflux);
    eEflux=log10(eEflux);
    centralenergy=(all_DMSPDATA1.ch_ctrl_ener);
    spacingenergy=(all_DMSPDATA1.ch_energy);
    dt = reshape(datetime( all_DMSPDATA1.ut1_unix, 'ConvertFrom', 'posixtime' ),19,[]);
    DMSPDATA.timeEstr=datestr( dt(1,:) );
    DMSPDATA.timeE=datenum( DMSPDATA.timeEstr);
    DMSPDATA.centralenergy=reshape(spacingenergy,19,[]);
    DMSPDATA.spaengenergy=reshape(centralenergy,19,[]);
    DMSPDATA.IEflux=reshape(IEflux,19,[]);
    DMSPDATA.eEflux=reshape(eEflux,19,[]);
end



% if exist('MADFIELDFILENAME','var')==1
%     all_DMSPDATA2 = h5read(MADFIELDFILENAME,'/Data/Table Layout');
%     DMSPDATA.diff_bd=all_DMSPDATA2.diff_bd;
%     DMSPDATA.diff_bfor=all_DMSPDATA2.diff_b_for;
%     DMSPDATA.diff_bperp=all_DMSPDATA2.diff_b_perp;
%     DMSPDATA.bd=all_DMSPDATA2.bd;
%     DMSPDATA.bfor=all_DMSPDATA2.b_forward;
%     DMSPDATA.bperp=all_DMSPDATA2.b_perp;
%     
%     dt = datetime( all_DMSPDATA2.ut1_unix, 'ConvertFrom', 'posixtime' );
%     DMSPDATA.timeFstr=datestr( dt );
%     DMSPDATA.timeF=datenum( DMSPDATA.time2str );
%     DMSPDATA.latitude2=all_DMSPDATA2.gdlat;
%     DMSPDATA.longitude2=all_DMSPDATA2.glon;
%     DMSPDATA.altitude2=all_DMSPDATA2.gdalt;
% end

if SATNUMBER~=15 && nargin==4
    all_DMSPDATA2 = h5read(MADFIELDFILENAME,'/Data/Table Layout');
    DMSPDATA.diff_bd=all_DMSPDATA2.diff_bd;
    DMSPDATA.diff_bfor=all_DMSPDATA2.diff_b_for;
    DMSPDATA.diff_bperp=all_DMSPDATA2.diff_b_perp;
    DMSPDATA.bd=all_DMSPDATA2.bd;
    DMSPDATA.bfor=all_DMSPDATA2.b_forward;
    DMSPDATA.bperp=all_DMSPDATA2.b_perp;
    
    dt = datetime( all_DMSPDATA2.ut1_unix, 'ConvertFrom', 'posixtime' );
    DMSPDATA.timeFstr=datestr( dt );
    DMSPDATA.timeF=datenum( DMSPDATA.timeFstr );
    DMSPDATA.latitude2=all_DMSPDATA2.gdlat;
    DMSPDATA.longitude2=all_DMSPDATA2.glon;
    DMSPDATA.altitude2=all_DMSPDATA2.gdalt;
end