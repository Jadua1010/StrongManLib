function initializeESP()
    clear
    %Defining some values

    global numLEDs sendPort recievePort pausEE espIP udps udpr;
    
    numLEDs=12;
    
    sendPort=4210;
    recievePort=4211;
    
    pausEE=0.002;
    
    espIP = "192.168.4.1";
    
    %Initiate UDP sender and reciever
    udps = dsp.UDPSender('RemoteIPPort',sendPort,'RemoteIPAddress',espIP);
    udpr = dsp.UDPReceiver('LocalIPPort',recievePort);
    
return