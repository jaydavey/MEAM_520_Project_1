function thetas = team102_linear_int(t, t_i, t_f, theta_i, theta_f, joint)

% Linear interpolation between two points

theta2dot = 0;
thetadot = ((theta_f - theta_i)/(t_f - t_i));
theta = (theta_f - thetadot*t_f) + thetadot*t;
thetas = [theta, thetadot, theta2dot];
