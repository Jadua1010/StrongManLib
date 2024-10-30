clear all;
AD2close();

% Initialize device
hdwf = AD2Init();

buttonIn = 0;
buttonOut = 0;
ledOut = 1;

AD2initAnalogOut(hdwf, ledOut, 0.5, -1, -2.3, 1);  % LED wave
AD2StartAnalogOut(hdwf, ledOut)
AD2SetPower(hdwf, buttonOut, 3.3);
pressed = 0

while true
    while pressed == 0
        pressedVector = AD2readDigitalIO(hdwf);
        pressed = pressedVector(buttonIn + 1)
    end
    AD2initAnalogOut(hdwf, ledOut, 4, -1, -2.3, 2);  % LED wave
    AD2StartAnalogOut(hdwf, ledOut)
    % Run functions
    pause(5)
    AD2initAnalogOut(hdwf, ledOut, 0.5, -1, -2.3, 1);  % LED wave
    AD2StartAnalogOut(hdwf, ledOut)
    pressed = 0;
end
