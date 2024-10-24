function [Voltage,t] = StrongmanGameHammer()
% StrongmanGameHammer()
% Generates a randomized current response of a fictional accelerometer/hammer.
% Based on the pre-project accelerometer
%
%   Input arguments: 
%   None
%
%   Output arguments:
%   Current (A)
%   t - Time (s)
%
%   Author(s):
% v1.0: Douwe de Bruijn - Copyright 2020

dt = 0.002;
t = 0:dt:2;
i = 1:length(t);

t1 = 0.5+0.1*rand;
idx1 = interp1(t,i,t1,'nearest','extrap');
t2 = t1 + 0.3+0.2*rand;
idx2 = interp1(t,i,t2,'nearest','extrap');
t3 = t2+4*dt;
idx3 = interp1(t,i,t3,'nearest','extrap');
t4 = t3 + 0.8+(0.1*rand);
idx4 = interp1(t,i,t4,'nearest','extrap');

offset = 1e-6+0.1e-6*rand;
e = 8*(1+0.05*rand);

dI1 = offset -0.5e-8 + 0.5e-8*exp(e*(t(idx1:idx2)-t(idx1)));
delta = dI1(end)-offset;
k = 5;
dI2 = offset + 0.6*delta*exp(-k*(t(idx3:idx4)-t(idx3))).*sin(8*pi*1/(t4-t3)*(t(idx3:idx4)-t(idx3)));

Voltage(1:idx1) = offset;
Voltage(idx1:idx2) = [dI1];
Voltage(idx2:idx3) = offset-delta*(2+0.5*rand);
Voltage(idx3:idx4) = [dI2];
Voltage(idx4:length(i)) = offset;

noise = 0.0004;
Voltage = (Voltage + Voltage*(-noise+2*noise*rand(length(Voltage))))*1e6;

end

