function thetas = team102_quintic_int(t, t_i, t_f, theta_i, theta_f, thetadot_i, thetadot_f, theta2dot_i, theta2dot_f)

% Quintic interpolation between two points
% Variables are assigned to x = [a0; a1; a2; a3; a4; a5]

% Define persistent constants to prevent constant recalculation
persistent x t_i_check

% This function is initialized by calling it with no argument.
if (nargin == 0)
   t_i_check = -100000;
   return
end

if (t_i == t_i_check)
    % If timestamp is within previously calculated interpolation boundaries
    % use previously calculated constants
        
    if (t < t_i)
        theta = x(1) + x(2)*t + x(3)*t.^2 + x(4)*t.^3 + x(5)*t.^4 + x(6)*t.^5;
        thetadot = x(2) + 2*x(3)*t + 3*x(4)*t.^2 + 4*x(5)*t.^3 + 5*x(6)*t.^4;
        theta2dot = 2*x(3) + 6*x(4)*t + 12*x(5)*t.^2 + 20*x(6)*t.^3;
        thetas = [theta thetadot theta2dot];
    end
    
else
    % If timestamp is the beginning of a new interpolation calculate new
    % constants
    
    %conditions
    B = [theta_i thetadot_i theta2dot_i theta_f thetadot_f theta2dot_f]';

    %time elements
    A = [1    t_i   t_i^2     t_i^3    t_i^4    t_i^5; 
         0      1   2*t_i   3*t_i^2  4*t_i^3  5*t_i^4; 
         0      0       2     6*t_i 12*t_i^2 20*t_i^3;
         1    t_f   t_f^2     t_f^3    t_f^4    t_f^5; 
         0      1   2*t_f   3*t_f^2  4*t_f^3  5*t_f^4;
         0      0       2     6*t_f 12*t_f^2 20*t_f^3];
     
    B = [theta_i; thetadot_i; theta2dot_i; theta_f; thetadot_f; theta2dot_f];
    
    %solve for coefficients
    x = A\B;
    
    t_i_check = t_i;
    
    if (t < t_i)
        
        theta = x(1) + x(2)*t + x(3)*t.^2 + x(4)*t.^3 + x(5)*t.^4 + x(6)*t.^5;
        thetadot = x(2) + 2*x(3)*t + 3*x(4)*t.^2 + 4*x(5)*t.^3 + 5*x(6)*t.^4;
        theta2dot = 2*x(3) + 6*x(4)*t + 12*x(5)*t.^2 + 20*x(6)*t.^3;
        thetas = [theta thetadot theta2dot];
    end

end
