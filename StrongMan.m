clear all;
AD2close();

% Initialize device
hdwf = AD2Init();

buttonIn = 8;
buttonOut = 0;
ledOut = 1;

AD2initAnalogOut(hdwf, ledOut, 0.5, -1, -2.3, 1);  % LED wave
AD2StartAnalogOut(hdwf, ledOut)
AD2SetPower(hdwf, buttonOut, 5);
pressed = 0;
initializeESP();

global calibration

while true
    while pressed == 0
        pressedVector = AD2readDigitalIO(hdwf);
        pressed = pressedVector(buttonIn + 1);
    end
    AD2initAnalogOut(hdwf, ledOut, 4, -1, -2.3, 2);  % LED wave
    AD2StartAnalogOut(hdwf, ledOut);
    % Calibrate
    AD2StartAnalogIn(hdwf);
    calData = AD2GetAnalogData(hdwf, 0, 2000);
    calibration = average(calData) - 0.05
    % a = parfevalOnAll(@MotorCodeFunc, 0, hdwf);
    [maxDistance, predDistance] = MeasureAllDistances(hdwf, 50);
    maxDistance
    predDistance
    % parfevalOnAll(@LED, 0, 120);
    % displayNumber(round(maxDistance)*100);
    % parfevalOnAll(@calibrateDisplay, 0);
    % pause(5)
    AD2initAnalogOut(hdwf, ledOut, 0.5, -1, -2.3, 1);  % LED wave
    AD2StartAnalogOut(hdwf, ledOut);
    pressed = 0;
end
