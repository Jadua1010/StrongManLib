function [maxDist, predicted] = MeasureAllDistances(hdwf, reps)

    % Motor code stuff

    % Define parameters
    solenoid_pin = bin2dec('0010'); % Enabling pins for opening and closing the solenoid
    solenoid_pin_close = bin2dec('0000');
    solenoid_pin_open = bin2dec('0010'); 
    [Voltage, t] = StrongmanGameHammer(); %Random voltage from the function simulating the hammer
    acceleration_voltage = 5 * max(Voltage); %The voltage that is used
    %acceleration_voltage  = ; %Enter the value manually, if the test is wanted 
    disp(acceleration_voltage)
    max_voltage = 12;            % Voltage level for PWM (12V)
    frequency = 10000;       % 1/period
    channelOut = 0; % Channel that outputs the PWM wave
    
    % Determing thew duty cycle in percentages
    duty_cycle = acceleration_voltage / max_voltage * 100;
    %duty_cycle = 52.5;

    % Generate the PWM signal based on the duty cycle
    AD2initPWM(hdwf,channelOut,duty_cycle,frequency);
    
    % enable output on DIO pin 1
    AD2SetDigitalOutput(hdwf,solenoid_pin);
    
    %Start the PWM signal for 4 s
    AD2StartPWM(hdwf,channelOut)
    pause(3)

    % Settings
    outputFreq = 40000;         % Target Frequency of sine wave (40 kHz)
    amplitude = 5;              % Amplitude of the sine wave (5V)
    offset = 0;                 % Offset for the sine wave (0V)
    channelOutW1 = 0;           % Output channel (W1)
    channelIn = 0;              % Input channel (C1)
    nSamples = 2000;            % Number of samples per iteration
    sampleRate = 2e6;           % Sample rate for input (1 MHz)
    pulses = 5;                 % Amount of pulses to send
    maxDist = 0;
    sampleInterval = 1 / sampleRate;
    distanceData = [];
    global calibration
    
    % Debounce time (in seconds) to prevent multiple detections
    debounce = 0.01;
    repIts = 0
    
% enable output on DIO pin 1
    AD2SetDigitalOutput(hdwf,solenoid_pin);
    % open the solenoid
    AD2SetDigitalIO(hdwf,solenoid_pin_open)

    startTime = datetime('now'); % Record the absolute start time when program starts
    gate2Active = false;         % Flag to check if gate2 has become active
    distance = 0.13;             % Distance between gates in meters

    while true
        ioPinData = AD2readDigitalIO(hdwf); % Get data
        gate1Status = ~ioPinData(4);        % Invert data
        gate2Status = ~ioPinData(3);        % Invert data
    
        % Check if gate2 has turned active
        if gate2Status == 1 && ~gate2Active
            startTime = datetime('now');  % Record the exact start time
            gate2Active = true;           % Mark gate2 as active
            AD2SetDigitalOutput(hdwf,solenoid_pin);
            AD2SetDigitalIO(hdwf,solenoid_pin_close);
        end
    
        % Check if gate1 becomes active after gate2 has been active
        if gate1Status == 1 && gate2Active
            endTime = datetime('now');    % Record the exact end time
            elapsedTime = seconds(endTime - startTime); % Calculate elapsed time in seconds
            break;
        end
    
        pause(0.001); % Small delay for stability
    end

    % Initialize Output and Input
    AD2StopPWM(hdwf, channelOut)

    AD2initAnalogOut(hdwf, channelOutW1, outputFreq, amplitude, offset, 1);  % Sine wave on W1
    AD2initAnalogIn(hdwf, channelIn, sampleRate, 10, nSamples);

    % Variables to store data for plotting
    while repIts <= reps
    allData = [];
    allData2 = [];
    % Initialize minimum voltage tracking and iteration counter
    iterationCount = 0;
    crash = 0;
    
    % Loop to continuously sample until first detection (3V)
    detected3V = false;
    AD2playPulses(hdwf, channelOutW1, outputFreq, pulses); % Start pulses
    while ~detected3V
        AD2StartAnalogIn(hdwf);
        data = AD2GetAnalogData(hdwf, channelIn, nSamples);
        crash = crash + 1;

        if crash == 25
            fprintf('Restarting due to error\n');
            break;
    
        elseif any(data <= calibration - 3)
            detected3V = true;
            allData = [allData, data];  % Append data for plotting
    
            % Loop to sample data for only 10 iterations
            while iterationCount < 6
                AD2StartAnalogIn(hdwf);
                data2 = AD2GetAnalogData(hdwf, channelIn, nSamples);
                allData2 = [allData2, data2];  % Append data for plotting
                
                iterationCount = iterationCount + 1;  % Increment counter
            end
    
            % Find the index of the first voltage sample smaller than -0.150 V
            firstLowVoltageIndex = find(allData2 < calibration - 0.02, 1, 'first');
            minPeakTime = (length(allData2) + firstLowVoltageIndex - 1) * sampleInterval;
    
             % Find the sample index of the first -3V detection
            firstIndex3V = find(data <= calibration - 3, 1, 'first');
            firstPeakTime = (length(allData) - nSamples + firstIndex3V - 1) * sampleInterval;
    
            % Calculate the time difference between first peak and minimum peak
            timeDifference = (minPeakTime - firstPeakTime);
            distance = 1.5 - ((timeDifference * 331.29 * 0.5 - 0.90) * 2).^0.9;
            % fprintf('Distance: %f m\n', distance);
            distanceData = [distanceData, distance];

            pause(debounce);
            repIts = repIts + 1;
            end
        end
    end

    % Define t1 and t2
    t1 = startTime;               % Absolute time when gate2 triggered
    t2 = endTime;                 % Absolute time when gate1 triggered

    % Assume t1 and t2 are provided from previous data
    t1 = 0;  % Example value, replace with actual t1 from data
    t2 =  elapsedTime; % Example value, replace with actual t2 from data
    
    % Define symbolic variables for the constants C1 and C2
    syms C1 C2
    
    % Define the equations based on the conditions x(t1) = 0 and x(t2) = 0.13
    eq1 = C1 + C2 .* exp(-0.03192 .* t1) - 307.329126 .* t1 == 0;
    eq2 = C1 + C2 .* exp(-0.03192 .* t2) - 307.329126 .* t2 == 0.13;
    
    % Solve for C1 and C2 in terms of t1 and t2
    sol = solve([eq1, eq2], [C1, C2]);
    
    % Extract solutions for C1 and C2 as double values
    C1_val = double(sol.C1);
    C2_val = double(sol.C2);
    
    % Define the velocity function as an anonymous function
    v = @(t) (-0.03192) * C2_val * exp(-0.03192 * t) - 307.329126 ;
    
    % Calculate and display v(0)
    v_0 = v(0);
    % disp(['Initial Velocity v(0) = ', num2str(v_0), ' m/s']);
    
    % Define a range for t and compute x(t) using the calculated C1 and C2 values
    t = linspace(0, 1 , 5000); % Adjust range of t as needed
    x_t = C1_val + C2_val .* exp(-0.03192 .* t) - 307.329126 .* t + 0.12 - 0.09956*(v_0) +0.262;

    predicted = max(x_t);
    maxDist = max(distanceData);
return