function [ output_args ] = team102_LSPB_int( t, t_i, t_f, theta_i, theta_f, thetadot_i, thetadot_f, t_blend)

% LSPB interpolation between two points

if (t < t_blend)
    % First parabolic segment
    
elseif (t < t_f - t_blend)
    % Linear segment

else
    % Second parabolic segment

end

