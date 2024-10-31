function LED(numberToSend)
% Open serial connection to Arduino
arduino = serialport("COM3", 9600);

% Pause briefly to establish the connection
pause(2);

writeline(arduino, num2str(numberToSend));

end

