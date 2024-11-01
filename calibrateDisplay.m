function calibrateDisplay()

global numLEDs sendPort recievePort pausEE espIP udps udpr;

%Select accel z-axis
dispCommand = uint8(zeros(numLEDs,1));
dispCommand(1)=4;
dispCommand(2)=1;
udps(dispCommand);

%Request data
datapointSize=6;
datapointsPerPacket = 20;                                                   %Each packet contains 20 datapoints
packets = 10;                                                               % Number of packets to read
dataRead = zeros(1,packets);                                                % Initialize sensor data array
dataReadTimes = zeros(1,packets);                                           % Initialize sensor time array  

resultIndex = 1;
for i = 1:packets                                                           %Step through all the packets                                                  %Clear the data 
    dataReceived = [];
    while (size(dataReceived, 1) == 0)                                      % Check if any data was received
        dataReceived = udpr();                                                  %Call the raw sensor data, returns [] if not available
    end
    dataReshaped = reshape(dataReceived, datapointSize, datapointsPerPacket);   % Reshape the data for easier interpretation
    for j = 1:datapointsPerPacket
        value = typecast(uint8(dataReshaped(1:2, j)), 'int16');             % Sensor output value
        time = typecast(uint8(dataReshaped(3:6, j)), 'uint32');             % Measurement time of datapoint in microseconds
        dataReadTimes(resultIndex) = time;                                  % Store time in array
        dataRead(resultIndex)=value;                                        % Store datapoint in array
        resultIndex = resultIndex + 1;                                      % Increment index by 1 for next datapoint
    end
               %Get the sensor data
end


[~,timeDif] = findpeaks(dataRead,MinPeakDistance=20,MinPeakHeight=500);
interval = mean(diff(timeDif))/0.12;
disp(interval);

dispCommand = uint8(zeros(numLEDs,1));                                      %Create an empty display packet to contain command
dispCommand(1)=3;                                                           %Where 3 indicates that we are going to send timing data
timing = round(interval*10);                                                     %Blink the image once per second, this variable should be changed accordingly

tim_bin=dec2bin(timing,32);                                                 %Convert the timing into binary format
dispCommand(2) = bin2dec(tim_bin(25:32));                                   %Since UDP can only send 8 bits, we are going to send it byte by byte, this is the low part
dispCommand(3) = bin2dec(tim_bin(17:24));                                   %Then the next 8 bits
dispCommand(4) = bin2dec(tim_bin(9:16));                                    %And the next
dispCommand(5) = bin2dec(tim_bin(1:8));                                     %And finally the high byte of our timing value
udps(dispCommand);       

end
