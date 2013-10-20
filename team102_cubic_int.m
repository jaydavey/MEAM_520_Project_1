function thetas = team102_cubic_int(t, t_i, t_f, theta_i, theta_f, thetadot_i, thetadot_f, joint)

% Cubic interpolation between two points
% Variables are assigned to y = [a0; a1; a2; a3]

% Define persistent constants to prevent constant recalculation
persistent y t_i_check_y

% This function is initialized by calling it with no argument.
if (nargin == 0)
   t_i_check_y = ones(6, 1)*-100000;
   y = zeros(4, 6);
   return
end

if (t_i == t_i_check_y(joint))
    % If timestamp is within previously calculated interpolation boundaries
    % use previously calculated constants
        
    theta = y(1, joint) + y(2, joint)*t + y(3, joint)*t.^2 + y(4, joint)*t.^3;
    thetadot = y(2, joint) + 2*y(3, joint)*t + 3*y(4, joint)*t.^2;
    thetas = [theta, thetadot, 0];
    
else
    % If timestamp is the beginning of a new interpolation calculate new
    % constants
    
    %time elements
    A = [1    t_i   t_i^2     t_i^3; 
         0      1   2*t_i   3*t_i^2; 
         1    t_f   t_f^2     t_f^3; 
         0      1   2*t_f   3*t_f^2];
     
    B = [theta_i; thetadot_i; theta_f; thetadot_f];
    
    %solve for coefficients
    y(:, joint) = A\B;
    
    t_i_check_y(joint) = t_i;
    
    theta = y(1, joint) + y(2, joint)*t + y(3, joint)*t.^2 + y(4, joint)*t.^3;
    thetadot = y(2, joint) + 2*y(3, joint)*t + 3*y(4, joint)*t.^2;
    thetas = [theta, thetadot, 0];
end
