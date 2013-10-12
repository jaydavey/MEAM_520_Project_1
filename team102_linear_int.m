function thetas = team102_linear_int(t, t_i, t_f, theta_i, theta_f)

% Linear interpolation between two points

thetas = zeros(length(theta_i), 3);

for i  = 1:length(theta_i)
    theta2dot = 0;
    thetadot = ((theta_f(i) - theta_i(i))/(t_f - t_i));
    theta = (theta_f(i) - thetadot*t_f) + thetadot*t;
    thetas(i, :) = [theta, thetadot, theta2dot];
end