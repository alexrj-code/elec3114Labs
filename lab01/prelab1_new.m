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
% (Write your code after the given locked code)
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
% Q2:   Trucate the data
%--#############################################################

% Truncate the data:
% Note: Have all variables in the same vector size and vector shape (all in column vector form).
% Although in normal MATLAB coding, you can plot same-size vectors regardless of
% whether they are row vectors, column vectors, or a mix of both, 
% for the purposes of this testing function, all vectors must be column vectors.

disc_speed_trunc_new = y_new1(501:end);
t_trunc_new = t_new1(501:end) - t_new1(501);

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
plot(t_trunc_new, disc_speed_trunc_new);
title('Truncated Speed Data (New)');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;

        
%%-#############################################################
% Q3:   DC offset removal part 1 of 3
%--#############################################################        
        
% compute the DC offset from the first 500 samples 
DC_offset_new = mean(disc_speed_trunc_new(1:500));


%%-#############################################################
% Q4a:   DC offset removal part 2 of 3
%--#############################################################   

% remove the DC offset from disc_speed_trunc
disc_speed_offset_free_new = disc_speed_trunc_new - DC_offset_new;
t_offset_free_new = t_trunc_new;


%%-#############################################################
% Q4b:   DC offset removal part 3 of 3
%--############################################################# 

% Truncate the data
disc_speed_ready_new = disc_speed_offset_free_new(501:end);
t_ready_new = t_offset_free_new(501:end) - t_offset_free_new(501);



% Plot both the OFFSET-FREE data set and the "ready" TRUNCATED OFFSET-FREE data set

try
  close("Q4b_FIG_01")
catch
end
figure("Name", "Q4b_FIG_01");

subplot(2,1,1);
plot(t_offset_free_new, disc_speed_offset_free_new);
title('Offset-Free Speed Data (New)');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;

subplot(2,1,2);
plot(t_ready_new, disc_speed_ready_new);
title('Truncated Offset-Free Speed Data (New)');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;

%%-#############################################################
% Q6: Simulink setup
%--#############################################################
fc = 45;
zeta = 0.707;
WindowSize = 5;