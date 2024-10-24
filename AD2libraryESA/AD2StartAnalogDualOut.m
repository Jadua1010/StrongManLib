function AD2StartAnalogDualOut(hdwf)
%AD2StartAnalogOut - very simple function to get the analog output to start.
%
% AD2StartAnalogOut(hdwf)
%
% hdwf - hardware device ID of AD2

if ~libisloaded('dwf')
    error('dwf library not loaded, make sure to run AD2Init first');
    return
end

calllib('dwf','FDwfAnalogOutConfigure',hdwf, -1, 1); %start channel
return