%% PUMA Dance
%
% Written by Alex McCraw and Jay Davey
% Starter code by Katherine J. Kuchenbecker
% MEAM 520 at the University of Pennsylvania


%% Clean up

% Clear all variables and functions.  You should do this before calling any PUMA functions.
clear all

% Move the cursor to the top of the command window so new text is easily seen.
home


%% Definitions

% Define team number.
teamnumber = 102;

% Define student names.
studentnames = 'Alex McCraw and Jay Davey';

% Load the dance file from disk.
load team102_2

% Pull the list of via point times out of the dance matrix for use below.
tvia = dance(:,1);

% Initialize the function that calculates angles.
team102_get_angles

% Define music filename (without team number).
musicfilename = 'Check It Yo E';

%% Robot Parameters

% Define joint limits
theta1_min = degtorad(-180);
theta1_max = degtorad(110);
theta2_min = degtorad(-75);
theta2_max = degtorad(240);
theta3_min = degtorad(-235);
theta3_max = degtorad(60);
theta4_min = degtorad(-580);
theta4_max = degtorad(40);
theta5_min = degtorad(-120);
theta5_max = degtorad(110);
theta6_min = degtorad(-215);
theta6_max = degtorad(295);

theta_mins = [theta1_min, theta2_min, theta3_min, theta4_min, theta5_min, theta6_min];
theta_maxs = [theta1_max, theta2_max, theta3_max, theta4_max, theta5_max, theta6_max];

%% Music

% Load the piece of music for the robot to dance to.
[y,Fs] = audioread([num2str(teamnumber) ' ' musicfilename '.wav']);

% Calculate the duration of the music.
musicduration = (length(y)-1)/Fs;

% Calculate the duration of silence at the start of the dance.
silenceduration = abs(min(tvia));

% Create a time vector for the entire piece of music, for use in plotting.
t = ((min(tvia):(1/Fs):musicduration))';

% Pad the start of the music file with zeros for the silence.
y = [zeros(length(t)-length(y),2); y];


%% Choose duration

% Set the start and stop times of the segment we want to test.
% To play the entire dance, set tstart = t(1) and tstop = t(end).
tstart = t(1);
%tstop = t(end);
tstop = 55;

% Select only the part of the music that we want to play right now, from
% tstart to tstop.
yplay = y(1+round(Fs*(tstart - t(1))):round(Fs*(tstop-t(1))),:);

% Put this snippet into an audio player so we can listen to it.
music = audioplayer(yplay,Fs);


%% Plot music

% Pull first audio channel and downsample it for easier display.
factordown = 30;
ydown = downsample(y(:,1),factordown);

% Downsample the time vector too.
tdown = downsample(t,factordown);

% Open figure and clear it.
figure(2)
clf

% Plot one of the sound channels to look at.
plot(tdown,ydown,'Color',[.2 .4 0.8]);
xlim([floor(t(1)) ceil(t(end))])

% Turn on hold to allow us to plot more things on this graph.
hold on

% Plot a vertical line at the time of each of the via points.
for i = 1:length(tvia)
    plot(tvia(i)*[1 1],ylim,'k--')
end

% Plot vertical lines at the start and stop times.
plot(tstart*[1 1],ylim,'k:')
plot(tstop*[1 1],ylim,'k:')

% Add a vertical line to show where we are in the music.
hline = plot(tstart*[1 1],ylim,'r-');

% Turn off hold.
hold off

% Set the title to show the team number and the name of the song.
title(['Team ' num2str(teamnumber) ': ' musicfilename])


%% Start robot

% Open figure 1 and clear it.
figure(1)
clf

% Initialize the PUMA simulation.
pumaStart()

% Set the view so we are looking from roughly where the camera will be.
view(80,20)

% The PUMA always starts with all joints at zero except joint 5, which
% starts at -pi/2 radians.  You can check this by calling pumaAngles.
thetahome = pumaAngles;

% Call pumaServo once to initialize timers.
pumaServo(thetahome);


%% Initialize dance

% Calculate the joint angles where the robot should start.
thetas = team102_get_angles(tstart);
thetastart = thetas(:,1);

% Calculate time needed to get from home pose to starting pose moving at
% angular speed of 0.5 radians per second on the joint that has the
% farthest to go.
tprep = abs(max(thetastart - thetahome)) / .5;

% Start the built-in MATLAB timer.
tic

% Slowly servo the robot to its starting position, in case we're
% not starting at the beginning of the dance.
while(true)
    % Get the current time for preparation move.
    tnow = toc;
    
    % Check to see whether preparation move is done.
    if (tnow > tprep)
        
        % Servo the robot to the starting pose.
        pumaServo(thetastart)
        
        % Break out of the infinite while loop.
        break

    end
    
    % Calculate joint angles.
    thetanow = team102_linear_int(tnow,0,tprep,thetahome,thetastart);

    % Servo the robot to this pose to prepare to dance.
    pumaServo(thetanow);
end

% Initialize history vectors for holding time and angles.  We preallocate
% these for speed, making them much larger than we will need.
thistory = zeros(10000,1);
thetahistory = zeros(10000,6);
thetadothistory = zeros(10000,6);
theta2dothistory = zeros(10000,6);

% Initialize our counter at zero.
i = 0;


%% Start music and timer

% Start the zero-padded music so we hear it.
play(music);

% Start the built-in MATLAB timer so we can keep track of where we are in
% the song.
tic


%% Dance

% Enter an infinite loop.
while(true)
    % Increment our counter.
    i = i+1;
    
    % Get the current time elapsed and add it to the time where we're
    % starting in the song. Store this value in the thistory vector.   
    thistory(i) = toc + tstart;
    
    % Check if we have passed the end of the performance.
    if (thistory(i) > tstop)
        
        % Break out of the infinite while loop.
        break

    end
    
    % Calculate the joint angles for the robot at this point in time and
    % store in our thetahistory matrix.
    thetas = team102_get_angles(thistory(i));
    thetahistory(i,:) = thetas(:,1);
    thetadothistory(i,:) = thetas(:,2);
    theta2dothistory(i,:) = thetas(:,3);

    % Servo the robot to these new joint angles.
    pumaServo(thetahistory(i,:));
        
    % Move the line on the music plot.
    set(hline,'xdata',thistory(i)*[1 1]);
end

% Stop the PUMA robot.
pumaStop
        
% Remove the unused ends of the history vector and matrix, which we
% preallocated for speed.
thistory(i:end) = [];
thetahistory(i:end,:) = [];
thetadothistory(i:end,:) = [];
theta2dothistory(i:end,:) = [];


%% Plot output

% Color order
color = ['y', 'm', 'c', 'r', 'g', 'b'];

% Open figure 3 and clear it.
figure(3)
clf
subplot(3,1,1)
h1 = plot(thistory, thetahistory);
for i = 1:length(h1)
   set(h1(i), 'color', color(i), 'LineWidth', 2) 
end

hold on
for i = 1:length(h1)
    plot([tstart, tstop],[theta_mins(i), theta_mins(i)], 'color', color(i), 'LineStyle', '--')
    plot([tstart, tstop],[theta_maxs(i), theta_maxs(i)], 'color', color(i), 'LineStyle', '--')
end

title(['Team ' num2str(teamnumber) ': Joint Angles over Time'])
axis auto
subplot(3,1,2)
h2 = plot(thistory, thetadothistory);
for i = 1:length(h1)
   set(h2(i), 'color', color(i), 'LineWidth', 2) 
end

title(['Team ' num2str(teamnumber) ': Joint Velocities over Time'])
axis auto
subplot(3,1,3)
h3 = plot(thistory, theta2dothistory);
for i = 1:length(h1)
   set(h3(i), 'color', color(i), 'LineWidth', 2) 
end

title(['Team ' num2str(teamnumber) ': Joint Accelerations over Time'])
axis auto
