clear all;
AD2close();

% Initialize device
hdwf = AD2Init();

% Settings
outputFreq = 40000;         % Target Frequency of sine wave (40 kHz)
amplitude = 5;              % Amplitude of the sine wave (5V)
offset = 0;                 % Offset for the sine wave (0V)
channelOutW1 = 0;           % Output channel (W1)
channelIn = 0;              % Input channel (C1)
nSamples = 2000;            % Number of samples per iteration
sampleRate = 2e6;           % Sample rate for input (1 MHz)
pulses = 5;                 % Amount of pulses to send
sampleInterval = 1 / sampleRate;
distanceData = [];

% Set up the figure and plot
figure;
hPlot = plot(nan, nan, 'b-');  % Initialize empty plot with a blue line
xlabel('Sample Number');
ylabel('Distance (V)');
title('Real-Time Voltage Monitoring');
grid on;
% Debounce time (in seconds) to prevent multiple detections
debounce = 0.01;

% Initialize Output and Input
AD2initAnalogOut(hdwf, channelOutW1, outputFreq, amplitude, offset, 1);  % Sine wave on W1
AD2initAnalogIn(hdwf, channelIn, sampleRate, 10, nSamples);
% Variables to store data for plotting
while true
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
    
        elseif any(data <= -3)
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
            firstLowVoltageIndex = find(allData2 < -0.02, 1, 'first');
            minPeakTime = (length(allData2) + firstLowVoltageIndex - 1) * sampleInterval;
    
             % Find the sample index of the first -3V detection
            firstIndex3V = find(data <= -3, 1, 'first');
            firstPeakTime = (length(allData) - nSamples + firstIndex3V - 1) * sampleInterval;
            % fprintf('First -3V signal detected at %f seconds\n', firstPeakTime);
    
            % Combine all data for plotting
            % allData = [allData, allData2];
    
            % Calculate the time difference between first peak and minimum peak
            timeDifference = (minPeakTime - firstPeakTime);
            distance = timeDifference * 331.29 * 0.5;
            fprintf('Distance: %f m\n', distance);
            distanceData = [distanceData, distance];
            set(hPlot, 'XData', 1:length(distanceData), 'YData', distanceData);
            drawnow;  % Force MATLAB to update the figure window
            pause(debounce);
        end
    end
end
% Plotting all data using sample indices
figure;
plot(1:length(allData), allData);
xlabel('Sample Number');
ylabel('Voltage (V)');
title('Voltage vs. Sample Number');
grid on;