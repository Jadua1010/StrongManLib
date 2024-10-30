clear
function initializeESP()
%Defining some values

numLEDs=12;

sendPort=4210;
recievePort=4211;

pausEE=0.002;

espIP = "192.168.4.1";

%Initiate UDP sender and reciever
udps = dsp.UDPSender('RemoteIPPort',sendPort,'RemoteIPAddress',espIP);
udpr = dsp.UDPReceiver('LocalIPPort',recievePort);


%defining matrices for individual numbers
m1 = [1 1 1 1 1 1 1;      1 1 1 0 0 1 1;      1 1 0 0 0 1 1;      1 0 0 0 0 1 1;      1 1 1 0 0 1 1;      1 1 1 0 0 1 1;      1 1 1 0 0 1 1;      1 1 1 0 0 1 1;      1 1 1 0 0 1 1;      1 0 0 0 0 0 0;      1 0 0 0 0 0 0;      1 1 1 1 1 1 1];
m2 = [1 1 1 1 1 1 1;      1 1 0 0 0 0 1;      1 0 0 0 0 0 0;      1 0 0 1 1 0 0;      1 1 1 1 0 0 0;      1 1 1 0 0 0 1;      1 1 0 0 0 1 1;      1 0 0 0 1 1 1;      1 0 0 1 1 1 1;      1 0 0 0 0 0 0;      1 0 0 0 0 0 0;      1 1 1 1 1 1 1];
m3 = [1 1 1 1 1 1 1;      1 1 0 0 0 0 1;      1 0 0 0 0 0 0;      1 0 0 1 1 0 0;      1 1 1 1 1 0 0;      1 1 0 0 0 0 0;      1 1 0 0 0 0 0;      1 1 1 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 0 0 0 0;      1 1 0 0 0 0 1;      1 1 1 1 1 1 1];
m4 = [1 1 1 1 1 1 1;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 0 0 0 0;      1 0 0 0 0 0 0;      1 1 1 1 1 0 0;      1 1 1 1 1 0 0;      1 1 1 1 1 0 0;      1 1 1 1 1 0 0;      1 1 1 1 1 0 0;      1 1 1 1 1 1 1];
m5 = [1 1 1 1 1 1 1;      1 0 0 0 0 0 0;      1 0 0 0 0 0 0;      1 0 0 1 1 1 1;      1 0 0 1 1 1 1;      1 0 0 0 0 0 1;      1 0 0 0 0 0 0;      1 1 1 1 1 0 0;      1 1 1 1 1 0 0;      1 0 0 0 0 0 0;      1 0 0 0 0 0 1;      1 1 1 1 1 1 1];
m6 = [1 1 1 1 1 1 1;      1 1 0 0 0 0 0;      1 0 0 0 0 0 0;      1 0 0 1 1 1 1;      1 0 0 1 1 1 1;      1 0 0 0 0 0 1;      1 0 0 0 0 0 0;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 0 0 0 0;      1 1 0 0 0 0 1;      1 1 1 1 1 1 1];
m7 = [1 1 1 1 1 1 1;      1 0 0 0 0 0 0;      1 0 0 0 0 0 0;      1 1 1 1 1 0 0;      1 1 1 1 0 0 0;      1 1 1 1 0 0 1;      1 1 1 1 0 0 1;      1 1 1 0 0 0 1;      1 1 1 0 0 1 1;      1 1 1 0 0 1 1;      1 1 1 0 0 1 1;      1 1 1 1 1 1 1];
m8 = [1 1 1 1 1 1 1;      1 1 0 0 0 0 1;      1 0 0 0 0 0 0;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 0 0 0 0;      1 0 0 0 0 0 0;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 0 0 0 0;      1 1 0 0 0 0 1;      1 1 1 1 1 1 1];
m9 = [1 1 1 1 1 1 1;      1 1 0 0 0 0 1;      1 0 0 0 0 0 0;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 0 0 0 0;      1 1 0 0 0 0 0;      1 1 1 1 1 0 0;      1 1 1 1 1 0 0;      1 0 0 0 0 0 0;      1 0 0 0 0 0 1;      1 1 1 1 1 1 1];
m0 = [1 1 1 1 1 1 1;      1 1 0 0 0 0 1;      1 0 0 0 0 0 0;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 1 1 0 0;      1 0 0 0 0 0 0;      1 1 0 0 0 0 1;      1 1 1 1 1 1 1];





%list with all the numbers
list={m0, m1, m2, m3, m4, m5, m6, m7, m8, m9};

filler=[1;1;1;1;1;1;1;1;1;1;1;1];

end


function displayNumber(calculation)
%Replace with input from sensor during integration hell
number=round(calculation);

if number>999
    number=999;
end

digits=dec2base(number,10)-'0';
matrixData=[];

for value = digits+1
    matrixData=[matrixData, list{value}];
end

while size(matrixData,2)<24
    matrixData=[matrixData, filler];
end

numColumn=size(matrixData,2);

disp(matrixData);

dataSend = uint8(ones(numLEDs,numColumn)*250);                              %Create an empty array of display data to send to ESP32
dataSend(1,:) = 1;
dataSend(2,:) = 0:numColumn-1;                                              %We fill our dataSend array with the column numbers
dataSend(5,:) = 0;                                                          %The red value for our columns
dataSend(6,:) = 0;                                                          %The green value for our columns
dataSend(7,:) = 255;                                                        %The blue value for our columns
dataSend(3,:) =  uint8(bin2dec(char(matrixData(1:4,:)' + '0')));                 %We provide our led matrix with values of L1 to L4 to be on or off.
dataSend(4,:) =  uint8(bin2dec(char(matrixData(5:12,:)' + '0')));                %We provide our led matrix with values of L5 to L12 to be on or off.

for i=1:numColumn
    udps(dataSend(:,i));                                                    %Send out the leddata, column by column.
    pause(pausEE);                                                              %Wait for the ESP32 to process our packet completely
end
end

function calibrateDisplay()
%Select accel z-axis
dispCommand = uint8(zeros(numLEDs,1));
dispCommand(1)=4;
dispCommand(2)=3;
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


[~,timeDif] = findpeaks(dataRead,MinPeakDistance=40,MinPeakHeight=500);
interval = mean(diff(timeDif))/0.24;
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
%% Faulty method using accelerometer and traveled path
%radiusIMU=0.00007;

%Select accel y-axis
%dispCommand = uint8(zeros(numLEDs,1));
%dispCommand(1)=4;
%dispCommand(2)=2;
%udps(dispCommand);

%Request data
%datapointsPerPacket = 20;                                                   %Each packet contains 20 datapoints
%packets = 10;                                                               % Number of packets to read
%dataRead = zeros(1,packets);                                                % Initialize sensor data array
%dataReadTimes = zeros(1,packets);                                           % Initialize sensor time array  

%resultIndex = 1;
%for i = 1:packets                                                           %Step through all the packets                                                  %Clear the data 
%    dataReceived = [];
%    while (size(dataReceived, 1) == 0)                                      % Check if any data was received
%        dataReceived = udpr();                                                  %Call the raw sensor data, returns [] if not available
%    end
%    dataReshaped = reshape(dataReceived, datapointSize, datapointsPerPacket);   % Reshape the data for easier interpretation
%    for j = 1:datapointsPerPacket
%        value = typecast(uint8(dataReshaped(1:2, j)), 'int16');             % Sensor output value
%        time = typecast(uint8(dataReshaped(3:6, j)), 'uint32');             % Measurement time of datapoint in microseconds
%        dataReadTimes(resultIndex) = time;                                  % Store time in array
%        dataRead(resultIndex)=value;                                        % Store datapoint in array
%        resultIndex = resultIndex + 1;                                      % Increment index by 1 for next datapoint
%    end
%               %Get the sensor data
%end
%disp(dataRead);

%acceleration=abs(mean(dataRead));
%velocity=sqrt(acceleration*radiusIMU);
%rotationTime=(2*pi*0.05)/(velocity);
%intervalTime=round(100000*(rotationTime/80));

%disp(intervalTime);

%dispCommand = uint8(zeros(numLEDs,1));
%dispCommand(1)=3;
%timing = intervalTime;

%tim_bin=dec2bin(timing,32);                                                 
%dispCommand(2) = bin2dec(tim_bin(25:32));
%dispCommand(3) = bin2dec(tim_bin(17:24));
%dispCommand(4) = bin2dec(tim_bin(9:16));
%dispCommand(5) = bin2dec(tim_bin(1:8));
%udps(dispCommand);
