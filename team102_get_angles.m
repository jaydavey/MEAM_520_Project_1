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
    trajectorytypevia = dance(:,20);
    
    % Return from initialization.
    return
    
end

% Determine which trajectory we should be executing.  Assuming the via
% point times are monotonically increasing, we look for the first via point
% time that is greater than the current time.  Subtract 1 to get to the
% index of the via point that starts this trajectory.
traj = find(t < tvia,1) - 1;

% Select the correct trajectory types.
switch (trajectorytypevia(traj))
    case 0
        % Linear interpolation
        % You may not use this pcoded file in your solution.
        thetas = team102_linear_int(t, tvia(traj), tvia(traj+1), thetavia(traj,:)', thetavia(traj+1, :)');
    case 1
        % Cubic interpolation
    case 2
        % Quintic interpolation
    case 3
        % LSPB interpolation
    otherwise
        error(['Unknown trajectory type: ' num2str(trajectorytypevia(traj))])
end