function thetas = team102_quintic_int(t, t_i, t_f, theta_i, theta_f, thetadot_i, thetadot_f, theta2dot_i, theta2dot_f, joint)

% Quintic interpolation between two points
% Variables are assigned to z = [a0; a1; a2; a3; a4; a5]

% Define persistent constants to prevent constant recalculation
persistent z t_i_check_z

% This function is initialized by calling it with no argument.
if (nargin == 0)
    t_i_check_z = ones(6, 1)*-100000;
   z = zeros(6, 6);
   return
end

if (t_i == t_i_check_z(joint))
    % If timestamp is within previously calculated interpolation boundaries
    % use previously calculated constants

    theta = z(1, joint) + z(2, joint)*t + z(3, joint)*t.^2 + z(4, joint)*t.^3 + z(5, joint)*t.^4 + z(6, joint)*t.^5;
    thetadot = z(2, joint) + 2*z(3, joint)*t + 3*z(4, joint)*t.^2 + 4*z(5, joint)*t.^3 + 5*z(6, joint)*t.^4;
    theta2dot = 2*z(3, joint) + 6*z(4, joint)*t + 12*z(5, joint)*t.^2 + 20*z(6, joint)*t.^3;
    thetas = [theta, thetadot, theta2dot];
    
else
    % If timestamp is the beginning of a new interpolation calculate new
    % constants
    
    %time elements
    A = [1    t_i   t_i^2     t_i^3    t_i^4    t_i^5; 
         0      1   2*t_i   3*t_i^2  4*t_i^3  5*t_i^4; 
         0      0       2     6*t_i 12*t_i^2 20*t_i^3;
         1    t_f   t_f^2     t_f^3    t_f^4    t_f^5; 
         0      1   2*t_f   3*t_f^2  4*t_f^3  5*t_f^4;
         0      0       2     6*t_f 12*t_f^2 20*t_f^3];
     
    B = [theta_i; thetadot_i; theta2dot_i; theta_f; thetadot_f; theta2dot_f];
    
    %solve for coefficients
    z(:, joint) = A\B;
    
    t_i_check_z(joint) = t_i;
    
    theta = z(1, joint) + z(2, joint)*t + z(3, joint)*t.^2 + z(4, joint)*t.^3 + z(5, joint)*t.^4 + z(6, joint)*t.^5;
    thetadot = z(2, joint) + 2*z(3, joint)*t + 3*z(4, joint)*t.^2 + 4*z(5, joint)*t.^3 + 5*z(6, joint)*t.^4;
    theta2dot = 2*z(3, joint) + 6*z(4, joint)*t + 12*z(5, joint)*t.^2 + 20*z(6, joint)*t.^3;
    thetas = [theta, thetadot, theta2dot];
end
