AD2close();
% Pin 0 is used for the motor control; Pin 1 for the solenoid
% V+ is used to supply 3.3 V(coonect to 6V of the motor control) 
% Initialize device
hdwf = AD2Init();

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
duty_cycle = ;

% Generate the PWM signal based on the duty cycle
AD2initPWM(hdwf,channelOut,duty_cycle,frequency);

% enable output on DIO pin 1
AD2SetDigitalOutput(hdwf,solenoid_pin);

%Start the PWM signal for 4 s
AD2StartPWM(hdwf,channelOut)
pause(3)

% open the solenoid
AD2SetDigitalIO(hdwf,solenoid_pin_open)
pause(0.6);

%close the solenoid
AD2SetDigitalIO(hdwf,solenoid_pin_close);

%End the PWM signal
AD2StopPWM(hdwf, channelOut)