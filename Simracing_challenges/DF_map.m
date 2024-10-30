clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 1;

mass = 1225; %car + fuel
wheelbase = 2.504;
CG_loc = 0.6;
h = 0.422;


% get your path to the folder where the runs are saved
folder = 'D:\UGRacing\UGR EV24\SimRacing\Challenge4\matlab';

manual_legend = {''};
% ----------------------------------------------------


% get speed range correct


%// Get all MAT files in directory
f = dir(fullfile(folder, '*.mat'));
runs = {};
times = {};
balance = {};


%// For each MAT file...
for idx = 1 : numel(f)
% for idx = 1:1

    %// Get absolute path to MAT file - i.e. folder/file.mat
    run = f(idx).name(1:end-4);   %get the name of the run
    runs{length(runs) + 1} = run;

    name = fullfile(folder, f(idx).name);
    load(name);

    %getting data into structure
        s.(['Time_' run]) = Tire_Slip_Angle_FL.Time;
        s.(['TSA_FL_Value_' run]) = abs(Tire_Slip_Angle_FL.Value);
        s.(['TSA_RL_Value_' run]) = abs(Tire_Slip_Angle_RL.Value);
        s.(['TSA_FR_Value_' run]) = abs(Tire_Slip_Angle_FR.Value);
        s.(['TSA_RR_Value_' run]) = abs(Tire_Slip_Angle_RR.Value);

        s.(['Camber_FL_Value_' run]) = (Camber_FL.Value);
        s.(['Camber_RL_Value_' run]) = (Camber_RL.Value);
        s.(['Camber_FR_Value_' run]) = (Camber_FR.Value);
        s.(['Camber_RR_Value_' run]) = (Camber_RR.Value);

        s.(['FL_Load_' run]) = abs(Tire_Load_FL.Value);
        s.(['RL_Load_' run]) = abs(Tire_Load_RL.Value);
        s.(['FR_Load_' run]) = abs(Tire_Load_FR.Value);
        s.(['RR_Load_' run]) = abs(Tire_Load_RR.Value);

        s.(['RH_F_' run]) = Ride_Height_FR.Value;
        s.(['RH_R_' run]) = Ride_Height_RR.Value;

        s.(['Chassis_Yaw_Rate_' run]) = Chassis_Yaw_Rate.Value;
        s.(['CG_Accel_Long_' run]) = (CG_Accel_Longitudinal.Value);
        s.(['CG_Accel_Lat_' run]) = (CG_Accel_Lateral.Value);

        s.(['Lap_Dist_' run]) = Corr_Dist.Value;
        s.(['Speed_' run]) = Ground_Speed.Value;

% ------------------------------------------------------------------------------

    % getting the lap started at 0
        s.(['Time_' run]) = s.(['Time_' run]) - s.(['Time_' run])(1,1);
        s.(['Lap_Dist_' run]) = s.(['Lap_Dist_' run]) - s.(['Lap_Dist_' run])(1,1);
        times{length(times) + 1} = s.(['Time_' run])(1, end);

    % Sum tyre loads

        s.(['Combined_Gs_' run]) = sqrt(s.(['CG_Accel_Long_' run]).^2 + s.(['CG_Accel_Lat_' run]).^2);

        s.(['SUM_TL_F_' run]) = movmean((s.(['FL_Load_' run]) + s.(['FR_Load_' run])),50);
        s.(['SUM_TL_R_' run]) = movmean((s.(['RL_Load_' run]) + s.(['RR_Load_' run])), 50);

        Front_mass_split = mass * CG_loc;
        Rear_mass_split = mass * (1-CG_loc);

        Front_LT = h/wheelbase * mass * 9.81 .* s.(['CG_Accel_Long_' run]);
        Rear_LT = - h/wheelbase * mass * 9.81 .* s.(['CG_Accel_Long_' run]);

        DF_front = s.(['SUM_TL_F_' run]) - Front_mass_split - Front_LT;
        DF_rear = s.(['SUM_TL_R_' run]) - Rear_mass_split - Rear_LT;

        for i = 1:length(s.(['RH_F_' run]))
            if (s.(['RH_F_' run])(i) < prctile(s.(['RH_F_' run]), 5) || s.(['RH_F_' run])(i) > prctile(s.(['RH_F_' run]), 95)) || s.(['Combined_Gs_' run])(i) > 1
                s.(['RH_F_' run])(i) = nan;
            end
        end

        for i = 1:length(s.(['RH_R_' run]))
            if s.(['RH_R_' run])(i) < prctile(s.(['RH_R_' run]), 10) || s.(['RH_R_' run])(i) > prctile(s.(['RH_R_' run]), 90) || s.(['Combined_Gs_' run])(i) > 1
                s.(['RH_R_' run])(i) = nan;
            end
        end

        CLA_Front = -DF_front ./ (0.5 * 1.2 * s.(['Speed_' run]).^2);
        CLA_Rear = -DF_rear ./ (0.5 * 1.2 * s.(['Speed_' run]).^2);

        RH_R = s.(['RH_R_' run]);
        RH_F = s.(['RH_F_' run]);
        
        
        figure
        subplot(2,1,1);
        scatter(s.(['Speed_' run]), s.(['CG_Accel_Long_' run]), 10, 'filled')
        title('CLA Downforce Front vs FRH', 'FontSize', 12)
        x = xlabel('Front Ride Height, [mm]', 'FontName', 'Calibri', 'Interpreter','latex');
        set(x, 'FontSize', 12)
        y = ylabel('CLA DF','FontName', 'Calibri', 'Interpreter','latex');
        set(y, 'FontSize', 12)


        subplot(2,1,2);
        scatter(s.(['RH_R_' run]), CLA_Rear, 10, 'filled')
        axis([95 110 -1 -0.2])
        title('CLA Downforce Front vs RRH', 'FontSize', 12)
        x = xlabel('Rear Ride Height, [mm]', 'FontName', 'Calibri', 'Interpreter','latex');
        set(x, 'FontSize', 12)
        y = ylabel('CLA DF','FontName', 'Calibri', 'Interpreter','latex');
        set(y, 'FontSize', 12)
        hold on

end

% % pretty up the figure
% grid on
% x = xlabel('Corrected distance of corners T12b / T13, [m]','FontName', 'Serif', 'Interpreter','latex');
% set(x, 'FontSize', 24)
% y = ylabel('Speed, [kph]', 'FontName', 'Serif', 'Interpreter','latex');
% set(y, 'FontSize', 24)
% % title('Vehicle balance over a lap from Tire Slip Angles')

% ------------------------------ CHANGE AXES -----------------------------
% axis([0 330 135 160 ])
%-------------------------------------------------------------------------

% ax = gca;
% ax.FontSize = 16;
% ax.FontName = 'Serif';
% ax.LineWidth = 1.25;
% % h = colorbar;
% % ylabel(h, 'Car speed, kph', 'FontSize', 20)
% 
% legend_strings = string(manual_legend);
% % for i = 1:idx
% %     L(i) = plot(nan, nan, ['b' markers(i)]);
% % end
% leg = legend(legend_strings, 'Location','northwest');
% set(leg, 'Interpreter', 'none', 'FontSize', 16);
% hold off