function thetas = team102_LSPB_int(t, t_i, t_f, theta_i, theta_f, thetadot_i, thetadot_f)

% LSPB interpolation between two points, blend time is 10% of total time
% between via points

% Define persistent constants to prevent constant recalculation
% Variables are assigned to x = [a0; a1; b0; b1; b2; c0; c1; c2]
persistent x t_b t_i_check

% This function is initialized by calling it with no argument.
if (nargin == 0)
   t_i_check = -100000;
   return
end

if (t_i == t_i_check)
    % If timestamp is within previously calculated interpolation boundaries
    % use previously calculated constants
    if (t < (t_i + t_b))
        % First parabolic segment
        theta = x(3) + x(4)*t + x(5)*t^2;
        thetadot = x(4) + 2*x(5)*t;
        theta2dot = 2*x(5);
        thetas = [theta, thetadot, theta2dot];
        
    elseif (t < (t_f - t_b))
        % Linear segment
        theta = x(1) + x(2)*t;
        thetadot = x(2);
        theta2dot = 0;
        thetas = [theta, thetadot, theta2dot];
        
    else
        % Second parabolic segment
        theta = x(6) + x(7)*t + x(8)*t^2;
        thetadot = x(7) + 2*x(8)*t;
        theta2dot = 2*x(8);
        thetas = [theta, thetadot, theta2dot];
        
    end
    
else
    % If timestamp is the beginning of a new interpolation calculate new
    % constants
    t_b = 0.1*(t_f - t_i);
    A = [0,       0,   1,         t_i,        t_i^2,  0,          0,            0;
         0,       0,   0,           1,        2*t_i,  0,          0,            0;
         0,       0,   0,           0,            0,  1,        t_f,        t_f^2;
         0,       0,   0,           0,            0,  0,          1,        2*t_f;
         1, t_f-t_b,   0,           0,            0, -1, -(t_f-t_b), -(t_f-t_b)^2;
         0,      -1,   0,           0,            0,  0,          1,  2*(t_f-t_b);
         1, t_i+t_b,  -1,  -(t_i+t_b), -(t_i+t_b)^2,  0,          0,            0;
         0,       -1,  0,           1,  2*(t_i+t_b),  0,          0,            0];
    
     B = [theta_i; thetadot_i; theta_f; thetadot_f; 0; 0; 0; 0];
    x = A\B;
    t_i_check = t_i;
    
    if (t < (t_i + t_b))
        % First parabolic segment
        theta = x(3) + x(4)*t + x(5)*t^2;
        thetadot = x(4) + 2*x(5)*t;
        theta2dot = 2*x(5);
        thetas = [theta, thetadot, theta2dot];

    elseif (t < (t_f - t_b))
        % Linear segment
        theta = x(1) + x(2)*t;
        thetadot = x(2);
        theta2dot = 0;
        thetas = [theta, thetadot, theta2dot];

    else
        % Second parabolic segment
        theta = x(6) + x(7)*t + x(8)*t^2;
        thetadot = x(7) + 2*x(8)*t;
        theta2dot = 2*x(8);
        thetas = [theta, thetadot, theta2dot];
        
    end
    
    %Plot the result to validate the trajectory shape.
    figure();
    t_vect_a=[t_i:0.1:t_b];
    theta_plot_a = x(3) + x(4).*t_vect_a + x(5).*t_vect_a.^2;

    t_vect_b=[t_i+t_b:0.1:t_f-t_b];
    theta_plot_b = x(1) + x(2).*t_vect_b;

    t_vect_c=[t_f-t_b:0.1:t_f];
    theta_plot_c = x(6) + x(7).*t_vect_c + x(8).*t_vect_c.^2;

    hold on
    plot(t_vect_a,theta_plot_a,'-r');
    plot(t_vect_b,theta_plot_b,'-g');
    plot(t_vect_c,theta_plot_c,'-b');
    
end
