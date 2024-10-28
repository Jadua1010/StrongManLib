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
sampleRate = 1e6;           % Sample rate for input (1 MHz)
pulses = 5;                 % Amount of pulses to send

% Initialize Output and Input
AD2initAnalogOut(hdwf, channelOutW1, outputFreq, amplitude, offset, 1);  % Sine wave on W1
AD2initAnalogIn(hdwf, channelIn, sampleRate, 10, nSamples);
pause(1);
% f = parfeval(@AD2StartAnalogOut, 0, hdwf, channelOutW1)
% AD2StartAnalogOut(hdwf, channelOutW1);
AD2playPulses(hdwf, channelOutW1, outputFreq, pulses)

% Start Analog Input (C1)
% AD2StartAnalogIn(hdwf);
% a = parfeval(@AD2playPulses, 0, hdwf, channelOutW1, outputFreq, pulses);

% Loop to continuously sample until detection
detected = false;
while ~detected
    fprintf('Looping\n');
    % Get sample data
    data = AD2GetAnalogData(hdwf, channelIn, nSamples);
    
    % Check if any sample reaches or exceeds 3V
    if any(data >= 3)
        detected = true;
        timestamp = datetime('now');
        fprintf('5V threshold reached at %s\n', timestamp);
    end
end
