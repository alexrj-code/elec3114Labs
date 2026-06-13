%%-#############################################################
% Q1:   Load the data
%--#############################################################

% Load the MAT file:
load('PreLab1_Data.mat'); 

% Extract data from the discSpeed matrix:
t_orig = discSpeed(:,1); % extracts first column
disc_speed_orig = discSpeed(:,2); % extracts second column

% Plot the original data set:
% (Write your code after the given locked code)
try
  close("Q1_FIG_01")
catch
end
figure("Name", "Q1_FIG_01");

plot(t_orig, disc_speed_orig);
title('Measured Speed Data');
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

disc_speed_trunc = disc_speed_orig(1001:end); % skips first 1000 rows
t_trunc = t_orig(1001:end) - t_orig(1001);    % dittoo, but shift time 
                                              % vector so starts at zero

% Plot both the ORIGINAL and TRUNCATED data sets:
try
  close("Q2_FIG_01")
catch
end
figure("Name", "Q2_FIG_01");

figure;

subplot(2, 1, 1); %two rows, 1 column first plot. Edit first frame
plot(t_orig, disc_speed_orig);
title('Offset-free Speed Data');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;

subplot(2, 1, 2); % edits second frame
plot(t_trunc, disc_speed_trunc);
title('Truncated Offset-free Speed Data');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;

        
%%-#############################################################
% Q3:   DC offset removal part 1 of 3
%--#############################################################        
        
% compute the DC offset from the first 1000 samples of disc_speed_trunc
DC_offset = mean(disc_speed_trunc(1:1000));


%%-#############################################################
% Q4a:   DC offset removal part 2 of 3
%--#############################################################   

% remove the DC offset from disc_speed_trunc
disc_speed_offset_free = disc_speed_trunc - DC_offset;
t_offset_free = t_trunc;


%%-#############################################################
% Q4b:   DC offset removal part 3 of 3
%--############################################################# 

% Truncate the data
disc_speed_ready = disc_speed_offset_free(1001:end); % save only after 1kth entry
t_ready = t_offset_free(1001:end) - t_offset_free(1001); % start at 0



% Plot both the OFFSET-FREE data set and the "ready" TRUNCATED OFFSET-FREE data set

try
  close("Q4b_FIG_01")
catch
end
figure("Name", "Q4b_FIG_01");

subplot(2, 1, 1);
plot(t_offset_free, disc_speed_offset_free);
title('Offset-free Speed Data');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;

subplot(2, 1, 2);
plot(t_ready, disc_speed_ready);
title('Truncated Offset-Free Disc Speed Data');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
grid on;

        
%%-#############################################################
% Q5a:   Filtering the noise part 1 of 2  (Preserve signal shape)
%--############################################################# 

% create Y_disc and T  
% i.e get 4000 sampless and put in Y_disc and T
Y_disc = disc_speed_ready(1:4000);
T = t_ready(1:4000);

% create the filter weights
N = 20;
a = 1;

b = ones(1, N+1) / (N+1);



% apply the filter and create Y_disc_filtered_A

% this creates 21 ones, then divides them by 21 to create a 'weight factor'
Y_disc_filtered_A = filter(b, a, Y_disc);
% this applies factor to signal, 
% at every point in time, replace measurement with average of last 21 sigs

% Plot:
%   T  vs  Y_disc vs 
%   T  vs  Y_disc_filtered_A
try
  close("Q5a_FIG_01")
catch
end
figure("Name", "Q5a_FIG_01");

plot(T, Y_disc);
hold on;
plot(T, Y_disc_filtered_A);
hold off;
title('RAW versus Filter A Speed Data');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
legend('Raw signal', 'Filter A signal');
grid on;


        
%%-#############################################################
% Q5b:   Filtering the noise part 2 of 2 (Maximise smoothness)
%--#############################################################       
% create the filter weights
N = 200;
a = 1;

b = ones(1, N+1) / (N+1);

% same thing but now 200 avg instead of 21

    
% apply the filter and create Y_disc_filtered_B
Y_disc_filtered_B = filter(b, a, Y_disc);

% Plot:
%   T  vs  Y_disc vs 
%   T  vs  Y_disc_filtered_A
%   T  vs  Y_disc_filtered_B
try
  close("Q5b_FIG_01")
catch
end
figure("Name", "Q5b_FIG_01");

plot(T, Y_disc);
hold on;
plot(T, Y_disc_filtered_A);
plot(T, Y_disc_filtered_B);
hold off;

title('RAW versus Filter A versus Filter B Speed Data');
xlabel('Time (sec)');
ylabel('Disc Speed (rpm)');
legend('Raw signal', 'Filter A signal', 'Filter B signal');
grid on;



        
