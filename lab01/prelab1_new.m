%%-#############################################################
%  ########################    NOTE    #########################
%--#############################################################
%  This is for Q5 onwards of the actual prelab pdf, which
%  the same steps from grader 1.1-1.4 applied to a different
%  dataset


%%-#############################################################
% Q1:   Load the data
%--#############################################################

% Load the MAT file:
load('PreLab1_Data_new.mat');

% Extract data from the discSpeed matrix:
y_new1 = discSpeed_new.signals.values(:,1)*60/(2*pi); % rad/s to rpm
t_new1 = discSpeed_new.time;

% Plot the original data set:
try
  close("Q1_FIG_01")
catch
end
figure("Name", "Q1_FIG_01");
plot(t_new1, y_new1);
title('Measured Speed Data (New)');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;


%%-#############################################################
% Q2:   Truncate the data
%--#############################################################
y_new2 = y_new1(501:end);
t_new2 = t_new1(501:end) - t_new1(501);

% Plot both the ORIGINAL and TRUNCATED data sets:
try
  close("Q2_FIG_01")
catch
end
figure("Name", "Q2_FIG_01");


subplot(2,1,1);
plot(t_new1, y_new1);
title('Original Speed Data (New)');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;

subplot(2,1,2);
plot(t_new2, y_new2);
title('Truncated Speed Data (New)');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;


%%-#############################################################
% Q3:   DC offset removal part 1 of 3
%--#############################################################
% compute the DC offset from the first 500 samples of truncated data
DC_offset_new = mean(y_new1(1:500));


%%-#############################################################
% Q4a:   DC offset removal part 2 of 3
%--#############################################################
y_new3 = y_new2 - DC_offset_new;
t_new3 = t_new2;


%%-#############################################################
% Q4b:   DC offset removal part 3 of 3
%--#############################################################
% y_new4 = y_new3(501:end);
% t_new4 = t_new3(501:end) - t_new3(501);

% maybe this unnecessary
y_new4 = y_new3; % Use the offset-free data directly for the next steps
t_new4 = t_new3; % Keep the time vector aligned with the offset-free data

% Plot both the OFFSET-FREE data set and the "ready" TRUNCATED OFFSET-FREE data set
try
  close("Q4b_FIG_01")
catch
end
figure("Name", "Q4b_FIG_01");

subplot(2,1,1);
plot(t_new3, y_new3);
title('Offset-Free Speed Data (New)');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;


subplot(2,1,2);
plot(t_new4, y_new4);
title('Truncated Offset-Free Speed Data (New)');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;


%%-#############################################################
% Q6: Simulink setup
%--#############////////////////////////////////////////////////
fc = 10;
zeta = 0.707;
WindowSize = 22;