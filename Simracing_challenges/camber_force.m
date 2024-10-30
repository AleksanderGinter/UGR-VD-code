clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 1;

mass = 983;
wheelbase = 2.31;
CG_loc = 0.54;


% get your path to the folder where the runs are saved
folder = 'D:\UGRacing\UGR EV24\SimRacing\Challenge3\matlab';

manual_legend = {'R21'};
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


        s.(['FL_Normal_' run]) = abs(Tire_Load_FL.Value);
        s.(['RL_Normal_' run]) = abs(Tire_Load_RL.Value);
        s.(['FR_Normal_' run]) = abs(Tire_Load_FR.Value);
        s.(['RR_Normal_' run]) = abs(Tire_Load_RR.Value);

        s.(['Chassis_Yaw_Rate_' run]) = Chassis_Yaw_Rate.Value;
        s.(['CG_Accel_Lateral_' run]) = movmean(abs(CG_Accel_Lateral.Value), 20).*9.81;

        s.(['Lap_Dist_' run]) = Corr_Dist.Value;
        s.(['Speed_' run]) = Ground_Speed.Value;

    % getting the lap started at 0
        s.(['Time_' run]) = s.(['Time_' run]) - s.(['Time_' run])(1,1);
        s.(['Lap_Dist_' run]) = s.(['Lap_Dist_' run]) - s.(['Lap_Dist_' run])(1,1);
        times{length(times) + 1} = s.(['Time_' run])(1, end);

    % stitching the values together
        s.(['W_AVE_TSA_F_' run]) = (s.(['TSA_FL_Value_' run]).*s.(['FL_Normal_' run]) + s.(['TSA_FR_Value_' run]).*s.(['FR_Normal_' run])) ./ (2.*(s.(['FL_Normal_' run])+s.(['FR_Normal_' run])));
        s.(['W_AVE_TSA_R_' run]) = (s.(['TSA_RL_Value_' run]).*s.(['RL_Normal_' run]) + s.(['TSA_RR_Value_' run])).*s.(['RR_Normal_' run]) ./ (2.*(s.(['RL_Normal_' run]) + s.(['RR_Normal_' run])));
    
        for i = 1:length(s.(['Chassis_Yaw_Rate_' run]))-1
            s.(['Chassis_Yaw_Accel_' run])(i) = (s.(['Chassis_Yaw_Rate_' run])(i+1) - s.(['Chassis_Yaw_Rate_' run])(i)) / (s.(['Time_' run])(i+1) - s.(['Time_' run])(i));
        end

        s.(['Chassis_Yaw_Accel_' run])(length(s.(['Chassis_Yaw_Accel_' run])+1)) = 0;

        s.(['Force_Front_' run]) = (mass * (wheelbase*(1-CG_loc))) .* s.(['CG_Accel_Lateral_' run]) ./wheelbase;
        s.(['Force_Rear_' run]) = (mass * (wheelbase*(CG_loc))) .* s.(['CG_Accel_Lateral_' run]) ./wheelbase;

        s.((['G_Tot_' run])) = (s.(['Force_Front_' run]) + s.(['Force_Rear_' run])) ./ mass;

        


        % getting max value of cambers and forces

        for i = 1:(length(s.(['Camber_FL_Value_' run])))
            if s.(['FL_Normal_' run])(i) >= s.(['FR_Normal_' run])(i)

                s.(['Camber_plot_' run])(i) = s.(['Camber_FL_Value_' run])(i);
            else
                s.(['Camber_plot_' run])(i) = s.(['Camber_FR_Value_' run])(i);
            end
        end

   % Cumulative difference in angle, F- R, average
%         s.(['DIFF_TSA_' run]) = cumsum(s.(['AVE_TSA_F_' run]) - s.(['AVE_TSA_R_' run]));

%         balance{idx} = round(sum(s.(['DIFF_TSA_' run]))/length(s.(['DIFF_TSA_' run])), 3);

        
% reshape to average for N continuous samples
% deletes the last k values so that there is no remainder after
% concatenation

%     % get TSA data 
%         to_delete = mod(int64(length(s.(['DIFF_TSA_' run]))), no_sampl);
%         new_size = int64(length(s.(['DIFF_TSA_' run]))) - to_delete;
% 
%         s.(['DIFF_TSA_' run]) = smooth(mean(reshape(s.(['DIFF_TSA_' run])(1:new_size), no_sampl, [])));
% 
%        % get lap distnace and speed in order
%         s.(['Lap_Dist_' run]) = mean(reshape(s.(['Lap_Dist_' run])(1:new_size), no_sampl, []));
%         s.(['Speed_' run]) = round(mean(reshape(s.(['Speed_' run])(1:new_size), no_sampl, [])));

    %create graph
        markers = ['o', 'x', '^', '<', '+'];

%         patch(s.(['Lap_Dist_' run]), s.(['DIFF_TSA_' run]),s.(['Speed_' run]), 'FaceColor', 'none', 'EdgeColor', 'interp', 'Marker', markers(idx), 'LineWidth', 1.5)
%         scatter(s.(['TSA_FL_Time_' run]), s.(['DIFF_TSA_' run]),18, s.(['speed_' run]), markers(idx));



        plot(s.(['Lap_Dist_' run]), s.(['Speed_' run]), 'LineWidth',1.5)%, 'Marker', markers(idx))
%         colormap jet
        hold on

end

% pretty up the figure
grid on
x = xlabel('Corrected distance of corners T12b / T13, [m]','FontName', 'Serif', 'Interpreter','latex');
set(x, 'FontSize', 24)
y = ylabel('Speed, [kph]', 'FontName', 'Serif', 'Interpreter','latex');
set(y, 'FontSize', 24)
% title('Vehicle balance over a lap from Tire Slip Angles')

% ------------------------------ CHANGE AXES -----------------------------
axis([0 330 135 160 ])
%-------------------------------------------------------------------------

ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;
% h = colorbar;
% ylabel(h, 'Car speed, kph', 'FontSize', 20)

legend_strings = string(manual_legend);
% for i = 1:idx
%     L(i) = plot(nan, nan, ['b' markers(i)]);
% end
leg = legend(legend_strings, 'Location','northwest');
set(leg, 'Interpreter', 'none', 'FontSize', 16);
hold off