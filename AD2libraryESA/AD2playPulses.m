function AD2playPulses(hdwf, channel, frequency, pulses)
%AD2StartAnalogOut - very simple function to get the analog output to start.
%
% AD2StartAnalogOut(hdwf)
%
% hdwf - hardware device ID of AD2

if ~libisloaded('dwf')
    error('dwf library not loaded, make sure to run AD2Init first');
    return
end

time = (1/frequency)*pulses;

calllib('dwf','FDwfAnalogOutWaitSet',hdwf, channel, 0); %start channel
calllib('dwf','FDwfAnalogOutRunSet',hdwf, channel, time); %start channel
calllib('dwf','FDwfAnalogOutConfigure',hdwf, channel, 1); %start channel
return