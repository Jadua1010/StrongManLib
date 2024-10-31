function displayNumber(calculation)

    global numLEDs sendPort recievePort pausEE espIP udps udpr;

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
    
    %disp(matrixData);
    
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
