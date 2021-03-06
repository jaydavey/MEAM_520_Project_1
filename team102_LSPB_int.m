function thetas = team102_LSPB_int(t, t_i, t_f, theta_i, theta_f, thetadot_i, thetadot_f, joint)

% LSPB interpolation between two points, blend time is 10% of total time
% between via points

% Define persistent constants to prevent constant recalculation
% Variables are assigned to x = [a0; a1; b0; b1; b2; c0; c1; c2]
persistent x t_b t_i_check

% This function is initialized by calling it with no argument.
if (nargin == 0)
   t_i_check = ones(6, 1)*-100000;
   t_b = zeros(6, 1);
   x = zeros(8, 6);
   return
end

if (t_i == t_i_check(joint))
    % If timestamp is within previously calculated interpolation boundaries
    % use previously calculated constants
    if (t < (t_i + t_b(joint)))
        % First parabolic segment
        theta = x(3, joint) + x(4, joint)*t + x(5, joint)*t^2;
        thetadot = x(4, joint) + 2*x(5, joint)*t;
        theta2dot = 2*x(5, joint);
        thetas = [theta, thetadot, theta2dot];

    elseif (t < (t_f - t_b(joint)))
        % Linear segment
        theta = x(1, joint) + x(2, joint)*t;
        thetadot = x(2, joint);
        theta2dot = 0;
        thetas = [theta, thetadot, theta2dot];

    else
        % Second parabolic segment
        theta = x(6, joint) + x(7, joint)*t + x(8, joint)*t^2;
        thetadot = x(7, joint) + 2*x(8, joint)*t;
        theta2dot = 2*x(8, joint);
        thetas = [theta, thetadot, theta2dot];
        
    end
    
else
    % If timestamp is the beginning of a new interpolation calculate new
    % constants
    t_b(joint) = 0.1*(t_f - t_i);
    A = [0                0    1                 t_i                 t_i^2    0                   0                     0;
         0                0    0                   1                 2*t_i    0                   0                     0;
         0                0    0                   0                     0    1                 t_f                 t_f^2;
         0                0    0                   0                     0    0                   1                 2*t_f;
         1   t_f-t_b(joint)    0                   0                     0   -1   -(t_f-t_b(joint))   -(t_f-t_b(joint))^2;
         0               -1    0                   0                     0    0                   1    2*(t_f-t_b(joint));
         1   t_i+t_b(joint)   -1   -(t_i+t_b(joint))   -(t_i+t_b(joint))^2    0                   0                     0;
         0               -1    0                   1    2*(t_i+t_b(joint))    0                   0                     0];
    
     B = [theta_i; thetadot_i; theta_f; thetadot_f; 0; 0; 0; 0];
    x(:, joint) = A\B;
    t_i_check(joint) = t_i;
    
    if (t < (t_i + t_b(joint)))
        % First parabolic segment
        theta = x(3, joint) + x(4, joint)*t + x(5, joint)*t^2;
        thetadot = x(4, joint) + 2*x(5, joint)*t;
        theta2dot = 2*x(5, joint);
        thetas = [theta, thetadot, theta2dot];

    elseif (t < (t_f - t_b(joint)))
        % Linear segment
        theta = x(1, joint) + x(2, joint)*t;
        thetadot = x(2, joint);
        theta2dot = 0;
        thetas = [theta, thetadot, theta2dot];

    else
        % Second parabolic segment
        theta = x(6, joint) + x(7, joint)*t + x(8, joint)*t^2;
        thetadot = x(7, joint) + 2*x(8, joint)*t;
        theta2dot = 2*x(8, joint);
        thetas = [theta, thetadot, theta2dot];
        
    end
end
