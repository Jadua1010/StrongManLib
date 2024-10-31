function maxDist = MeasurePeakDistance(hdwf, reps)
    
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
    
    % Debounce time (in seconds) to prevent multiple detections
    debounce = 0.01;
    repIts = 0

    % Calibrate
    AD2StartAnalogIn(hdwf);
    calData = AD2GetAnalogData(hdwf, channelIn, nSamples);
    calibration = average(calData) - 0.05
    
    % Initialize Output and Input
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
        
            elseif any(data <= calibration-3)
                
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
                    firstLowVoltageIndex = find(allData2 < calibration-0.02, 1, 'first');
                    minPeakTime = (length(allData2) + firstLowVoltageIndex - 1) * sampleInterval;
            
                     % Find the sample index of the first -3V detection
                    firstIndex3V = find(data <= calibration-3, 1, 'first');
                    firstPeakTime = (length(allData) - nSamples + firstIndex3V - 1) * sampleInterval;
                    % fprintf('First -3V signal detected at %f seconds\n', firstPeakTime);
            
                    % Combine all data for plotting
                    % allData = [allData, allData2];
            
                    % Calculate the time difference between first peak and minimum peak
                    timeDifference = (minPeakTime - firstPeakTime)
                    distance = 1.35 - timeDifference * 331.29 * 0.5;
                    fprintf('Distance: %f m\n', distance);
                    distanceData = [distanceData, distance];
                    pause(debounce);
                    repIts = repIts + 1;
            end
        end
    end
    maxDist = max(distanceData);
return