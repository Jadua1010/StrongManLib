function MotorCodeFunc(hdwf)

    % Define parameters
    solenoid_pin = bin2dec('0010'); % Enabling pins for opening and closing the solenoid
    solenoid_pin_close = bin2dec('0000');
    solenoid_pin_open = bin2dec('0010'); 
    [Voltage, t] = StrongmanGameHammer(); %Random voltage from the function simulating the hammer
    acceleration_voltage = max(Voltage); %The voltage that is used
    %acceleration_voltage  = ; %Enter the value manually, if the test is wanted 
    disp(acceleration_voltage)
    max_voltage = 3.3;            % Voltage level for PWM (3.3V)
    period = 0.01;         % The total period of PWM signal (s)
    frequency = 100;       % 1/period
    channelOut = 0; % Channel that outputs the PWM wave
    
    % Determing thew duty cycle in percentages
    duty_cycle = acceleration_voltage / max_voltage * 100;
    
    % Generate the PWM signal based on the duty cycle
    AD2initPWM(hdwf,channelOut,duty_cycle,frequency);
    
    % enable output on DIO pin 1
    AD2SetDigitalOutput(hdwf,solenoid_pin);
    
    %Start the PWM signal for 4 s
    AD2StartPWM(hdwf,channelOut)
    pause(3)
    
    % open the solenoid
    AD2SetDigitalIO(hdwf,solenoid_pin_open)
    pause(0.8);
    
    %close the solenoid
    AD2SetDigitalIO(hdwf,solenoid_pin_close);
    
    %End the PWM signal
    AD2StopPWM(hdwf, channelOut)
return