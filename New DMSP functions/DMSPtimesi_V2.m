function [indexi, indexe]=DMSPtimesi(InitialTime,FinalTime,time)

%% DMSPtimesi.m DMSP indexes of desire times of measurements
%--------------------------------------------------------------------------
% Input
%------
% InitialTime   - Initial Time to plot in string format, eg '09/08/2017 02:00:00';
% Finaltime     - Final Time to plot in string format, eg '09/08/2017 02:00:00';  
% Time          - Time vector from which the indexes are found
%--------------------------------------------------------------------------
% Output
%------
% indexi        - Index where the data starts
% indexe        - Index where the data ends
%--------------------------------------------------------------------------
% Modified: 05th Jun 2018 
% Created : 05th Jun 2018
% Author  : Joaquin Diaz Pena
% Ref     : 
%--------------------------------------------------------------------------

initt=datenum(InitialTime);
endt=datenum(FinalTime);

% Find closest time to desire interval
indexi=find(abs((time-initt))==min(abs(time-initt)));
indexe=find(abs((time-endt))==min(abs(time-endt)));