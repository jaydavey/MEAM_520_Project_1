function thetas = team102_cubic_int(t, t_i, t_f, theta_i, theta_f, thetadot_i, thetadot_f)

% Cubic interpolation between two points
% Variables are assigned to x = [a0; a1; a2; a3]

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
        theta = x(1) + x(2)*t + x(3)*t.^2 + x(4)*t.^3;
        thetadot = x(2) + 2*x(3)*t + 3*x(4)*t.^2;
        thetas = [theta thetadot [0;0;0;0;0;0]];
    end
    
else
    % If timestamp is the beginning of a new interpolation calculate new
    % constants
    
    %conditions
    B = [theta_i theadot_i 0 theta_f thetadot_f 0]';

    %time elements
    A = [1    t_i   t_i^2     t_i^3    0    0; 
         0      1   2*t_i   3*t_i^2    0    0; 
         0      0       0         0    0    0;
         1    t_f   t_f^2     t_f^3    0    0; 
         0      1   2*t_f   3*t_f^2    0    0;
         0      0       0         0    0    0];
     
    B = [theta_i; thetadot_i; 0; theta_f; thetadot_f; 0];
    
    %solve for coefficients
    x = A\B;
    
    t_i_check = t_i;
    
    if (t < t_i)
        
        theta = x(1) + x(2)*t + x(3)*t.^2 + x(4)*t.^3;
        thetadot = x(2) + 2*x(3)*t + 3*x(4)*t.^2;
        thetas = [theta thetadot [0;0;0;0;0;0]];
        
    end

end
