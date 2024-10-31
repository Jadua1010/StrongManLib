function predicted = Pred(hdwf)
    % Initialize timing and flag variables
    startTime = datetime('now'); % Record the absolute start time when program starts
    gate2Active = false;         % Flag to check if gate2 has become active
    distance = 0.13;             % Distance between gates in meters

    
    while true
        ioPinData = AD2readDigitalIO(hdwf); % Get data
        gate1Status = ~ioPinData(3);        % Invert data
        gate2Status = ~ioPinData(4);        % Invert data
    
        % Check if gate2 has turned active
        if gate2Status == 1 && ~gate2Active
            startTime = datetime('now');  % Record the exact start time
            gate2Active = true;           % Mark gate2 as active
            disp('Gate 2 active, starting timer...');
        end
    
        % Check if gate1 becomes active after gate2 has been active
        if gate1Status == 1 && gate2Active
            endTime = datetime('now');    % Record the exact end time
            elapsedTime = seconds(endTime - startTime); % Calculate elapsed time in seconds
            break;
        end
    
        pause(0.001); % Small delay for stability
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
    
    % Display the results
    disp(['C1 = ', num2str(C1_val)]);
    disp(['C2 = ', num2str(C2_val)]);
    
    % Define the velocity function as an anonymous function
    v = @(t) (-0.03192) * C2_val * exp(-0.03192 * t) - 307.329126 ;
    
    % Calculate and display v(0)
    v_0 = v(0);
    % disp(['Initial Velocity v(0) = ', num2str(v_0), ' m/s']);
    
    % Define a range for t and compute x(t) using the calculated C1 and C2 values
    t = linspace(0, 1 , 5000); % Adjust range of t as needed
    x_t = C1_val + C2_val .* exp(-0.03192 .* t) - 307.329126 .* t + 0.12 - 0.09956*(v_0) +0.262;

    predicted = max(x_t);
return