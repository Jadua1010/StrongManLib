function AD2SetDigitalOutput(hdwf,value)

if ~libisloaded('dwf')
    error('dwf library not loaded, make sure to run AD2Init first');
    return
end

calllib('dwf','FDwfDigitalIOOutputEnableSet',hdwf, value);
return