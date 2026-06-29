%% Quanser Rotary Servo DC Motor SRV02 Parameters
% The notations and variable names are based on the schematic of 
% SRV02 device created by Dr. Arash Khatamianfar in T2 2026.
% Some values have been experimentally obtained, rounded, and verified 
% by Dr. Arash Khatamianfar in T2 2026.

%clc; clear all;

% DC Motor Parameters 
Rm = 2.6;        % Motor armature (Terminal) resistance (Ω)
Lm = 180e-6;     % Motor armature (Rotor) inductance (H)
Km = 7.7e-3;     % Torque constant (N·m/A)
Kb = 7.7e-3;     % Back EMF constant (V/(rad/s))
Ja = 4e-7;       % Motor rotor inertia (kg.m^2)  
Da = 8.1e-7;     % Motor viscous damping coefficient (N.m/(rad/s))

Vm_nom = 6;      % Nominal/Rated operating voltage (V). 
                 % Maximum alloable voltage is +-15V but the DAQ terminal
                 % is limited at +-10V.


% External Inertias
Jg3 = 1e-7;     % N_3 gear inertia (kg.m^2)
Jg4 = 4.2e-5;   % N_4 gear inertia (kg.m^2)
Jg5 = 5.4e-6;   % N_5 gear inertia (kg.m^2)
Jpg = 5.4e-6;   % N_pg gear inertia (kg.m^2)
Jld	= 5e-5;     % Load disc inertia (kg.m^2)
% Jmeq = ?;     % To be calculated by students!

% External Viscous Damping Coefficients
Bmeq = 1.44e-6; %Total equivalent viscous damping on motor side	(N.m/(rad/s))

% Gear Ratios
% Internal planetary great ratio (scaled) N1:N2 --> 1:14 
N1 = 1; 
N2 = 14;		

% Main gear ratio (scaled) N3:N4 --> 1:5 
N3 = 1;
N4 = 5;

% Potentiometer/anti-backlash gear ratio (scaled) N5:Npg --> 1:1 
N5 = 1;
Npg = 1;






%%%%%%%%%%%% DATA CLEANING %%%%%%%%%%%%%%%%%%%%%%%

y_position = Position.signals.values;
y_speed = Speed.signals.values(:,1);
t = Position.time;
Vm_input = Input_Voltage.signals.values;

%%%% PARAMS FOR FILTER %%%%%
fc = 10;
zeta = 0.707;
WindowSize = 22;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
Y_disc = disc_speed_ready(1:4000);
T = t_ready(1:4000);

% create the filter weights
N = 20;
a = 1;

b = ones(1, N+1) / (N+1);

% apply the filter and create Y_disc_filtered_A

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
