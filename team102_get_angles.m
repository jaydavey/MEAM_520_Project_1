function thetas = team102_get_angles(t)

% Define dance and all other variables needed multiple times to be persistent.
persistent tvia thetavia thetadotvia theta2dotvia trajectorytypevia

% This function is initialized by calling it with no argument.
if (nargin == 0)
    
    % Load the team's dance file from disk.  It contains the variable dance.
    load team102
    
    % Pull the list of via point times out of the dance matrix.
    tvia = dance(:,1);
    
    % Pull the list of joint angles out of the dance matrix.
    thetavia = dance(:,2:7);
    
    % Pull the list of joint angle velocities out of the dance matrix.
    thetadotvia = dance(:,8:13);
    
    % Pull the list of joint angle accelerations out of the dance matrix
    theta2dotvia = dance(:,14:19);
    
    % Pull the list of trajectory types out of the dance matrix.
    trajectorytypevia = dance(:,20:25);
    
    % Return from initialization.
    return
    
end

% Determine which trajectory we should be executing.  Assuming the via
% point times are monotonically increasing, we look for the first via point
% time that is greater than the current time.  Subtract 1 to get to the
% index of the via point that starts this trajectory.

% Get the actual via point times for each joint, skipping over any NaN
% entries in the dance matrix
traj = find(t < tvia,1) - 1;
times = zeros(2, 6);
for i = 1:6
    % Determine joint specific interpolation starting time
    traj_temp = traj;
    while (isnan(thetavia(traj_temp, i)))
        traj_temp = traj_temp - 1;
    end
    times(1, i) = traj_temp;
    
    % Determine joint specific interpolation ending time
    traj_temp = traj + 1;
    while (isnan(thetavia(traj_temp, i)))
        traj_temp = traj_temp + 1;
    end
    times(2, i) = traj_temp;
end

% Initialize empty thetas matrix
thetas = zeros(6, 3);

% Select the correct trajectory type for each joint
for i = 1:6
    switch (trajectorytypevia(times(1, i), i))
        case 0
            % Linear interpolation
            thetas(i, :) = team102_linear_int(t, tvia(times(1, i)), tvia(times(2, i)), thetavia(times(1, i), i), thetavia(times(2, i), i));
        case 1
            % Cubic interpolation
            % use linear interpolation until the Cubic code is written
            thetas(i, :) = team102_cubic_int(t, tvia(times(1, i)), tvia(times(2, i)), thetavia(times(1, i), i), thetavia(times(2, i), i), thetadotvia(times(1, i), i), thetadotvia(times(2, i), i));
        case 2
            % Quintic interpolation
            % use linear interpolation until the Quintic code is written
            thetas(i, :) = team102_quintic_int(t, tvia(times(1, i)), tvia(times(2, i)), thetavia(times(1, i), i), thetavia(times(2, i), i), thetadotvia(times(1, i), i), thetadotvia(times(2, i), i), theta2dotvia(times(1, i), i), theta2dotvia(times(2, i), i));
        case 3
            % LSPB interpolation
            thetas(i, :) = team102_LSPB_int(t, tvia(times(1, i)), tvia(times(2, i)), thetavia(times(1, i), i), thetavia(times(2, i), i), thetadotvia(times(1, i), i), thetadotvia(times(2, i), i));
        otherwise
            error(['Unknown trajectory type: ' num2str(trajectorytypevia(traj))])
    end
end