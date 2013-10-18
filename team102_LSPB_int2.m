function thetas = team102_LSPB_int2(t, t_i, t_f, theta_i, theta_f, thetadot_i, thetadot_f)

theta2dot_i = 1;
theta2dot_f = 1;

% LSPB interpolation between two points, blend time is 10% of total time
% between via points

% Define persistent constants to prevent constant recalculation
% Variables are assigned to x1 = [a1; a2; a3], x2 = [a4; a5]; x3 = [a6; a7; a8]
persistent x1 x2 x3 t_b t_i_check

% This function is initialized by calling it with no argument.
if (nargin == 0)
   t_i_check = -100000;
   return
end

if (t_i == t_i_check)
    % If timestamp is within previously calculated interpolation boundaries
    % use previously calculated constants
    if ((t_i<=t)&&(t<=t_i+t_b))
        % First parabolic segment
        theta = x1(1) + x1(2)*t + x1(3)*t^2;
        thetadot = x1(2) + 2*x1(3)*t;
        theta2dot = 2*x1(3);
        thetas = [theta, thetadot, theta2dot];
        
    elseif ((t_i+t_b<t)&&(t<=t_f-t_b))
        % Linear segment
        theta = x2(1) + x2(2)*t;
        thetadot = x2(2);
        theta2dot = 0;
        thetas = [theta, thetadot, theta2dot];
        
    elseif ((t_f-t_b<t)&&(t<=t_f))
        % Second parabolic segment
        theta = x3(1) + x3(2)*t + x3(3)*t^2;
        thetadot = x3(2) + 2*x3(3)*t;
        theta2dot = 2*x3(3);
        thetas = [theta, thetadot, theta2dot];
    else
        fprintf('time outside range. LSPB error.\n');
    end
    
else
    % If timestamp is the beginning of a new interpolation calculate new
    % constants
    %solve for the tb that gives the desired acceleration
    %t_b = 0.1*(t_f - t_i);
    V = 
    
    %time elements
    A1 = [1        t_i       t_i^2; 
          0          1       2*t_i; 
          0          0           2;
          1    t_i+t_b   t_i+t_b^2; 
          0          1   2*t_i+t_b;
          0          0           2];
     
    B1 = [theta_i; thetadot_i; theta2dot_i; theta_f; thetadot_f; theta2dot_f];
    
    A2 = [0      1   t_i+t_b; 
          0      0         1; 
          0      0         0;
          0      1   t_f-t_b; 
          0      0         1;
          0      0         0];
     
    B2 = [theta_i; thetadot_i; 0; theta_f; thetadot_f; 0];
    
    A3 = [1    t_f-t_b   t_f-t_b^2; 
          0          1   2*t_f-t_b; 
          0          0           2;
          1        t_f       t_f^2; 
          0          1       2*t_f;
          0          0           2];
    
    B3 = [theta_i; thetadot_i; theta2dot_i; theta_f; thetadot_f; theta2dot_f];
    
    
    x1 = A1\B1;
    x2 = A2\B2;
    x3 = A3\B3;
    
    
    t_i_check = t_i;
    
    if ((t_i<=t)&&(t<=t_i+t_b))
        % First parabolic segment
        theta = x1(1) + x1(2)*t + x1(3)*t^2;
        thetadot = x1(2) + 2*x1(3)*t;
        theta2dot = 2*x1(3);
        thetas = [theta, thetadot, theta2dot];
        
    elseif ((t_i+t_b<t)&&(t<=t_f-t_b))
        % Linear segment
        theta = x2(1) + x2(2)*t;
        thetadot = x2(2);
        theta2dot = 0;
        thetas = [theta, thetadot, theta2dot];
        
    elseif ((t_f-t_b<t)&&(t<=t_f))
        % Second parabolic segment
        theta = x3(1) + x3(2)*t + x3(3)*t^2;
        thetadot = x3(2) + 2*x3(3)*t;
        theta2dot = 2*x3(3);
        thetas = [theta, thetadot, theta2dot];
    else
        fprintf('time outside range. LSPB error.\n');
    end
    
    %Plot the result to validate the trajectory shape.
    figure();
    t_vect_a=[t_i:0.1:t_b];
    theta_plot_a = x1(1) + x1(2).*t_vect_a + x1(3).*t_vect_a.^2;

    t_vect_b=[t_i+t_b:0.1:t_f-t_b];
    theta_plot_b = x2(1) + x2(2).*t_vect_b;

    t_vect_c=[t_f-t_b:0.1:t_f];
    theta_plot_c = x3(1) + x3(2).*t_vect_c + x3(3).*t_vect_c.^2;

    hold on
    plot(t_vect_a,theta_plot_a,'-r');
    plot(t_vect_b,theta_plot_b,'-g');
    plot(t_vect_c,theta_plot_c,'-b');
    
end
