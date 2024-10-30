clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 10;

% get your path to the folder where the runs are saved
folder = 'D:\UGRacing\UGR EV24\SimRacing\Challenge4\matlab\diff_coast';

manual_legend = {'Lamborghini R1', 'Lamborghini R3', 'Mercedes R1', 'Mercedes R3', 'Porsche R1', 'Porsche R4'};
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
        s.(['TSA_RL_Value_' run]) = abs(Tire_Slip_Angle_RR.Value);
        s.(['TSA_FR_Value_' run]) = abs(Tire_Slip_Angle_RL.Value);
        s.(['TSA_RR_Value_' run]) = abs(Tire_Slip_Angle_RR.Value);

        s.(['Lap_Dist_' run]) = Corr_Dist.Value;
        s.(['Speed_' run]) = Ground_Speed.Value;
        s.(['Lat_acc_' run]) = CG_Accel_Lateral.Value;
        s.(['Long_acc_' run]) = CG_Accel_Longitudinal.Value;

    % getting the lap started at 0
        s.(['Time_' run]) = s.(['Time_' run]) - s.(['Time_' run])(1,1);
        s.(['Lap_Dist_' run]) = s.(['Lap_Dist_' run]) - s.(['Lap_Dist_' run])(1,1);
        times{length(times) + 1} = s.(['Time_' run])(1, end);

    % stitching the values together
        s.(['AVE_TSA_F_' run]) = (s.(['TSA_FL_Value_' run]) + s.(['TSA_FR_Value_' run])) ./2;
        s.(['AVE_TSA_R_' run]) = (s.(['TSA_RL_Value_' run]) + s.(['TSA_RR_Value_' run])) ./2;
    
    % Difference in angle, F- R, average
        s.(['DIFF_TSA_' run]) = s.(['AVE_TSA_F_' run]) - s.(['AVE_TSA_R_' run]);

   % angle of gg plot
        s.(['Angle_' run]) = atan(s.(['Long_acc_' run])./s.(['Lat_acc_' run]));

        for i=1:length(s.(['Angle_' run])) % change so that takes both left and hand turns, magnitude and acc long less than 03
            if (abs(s.(['Angle_' run])(i)) < deg2rad(70) && abs(s.(['Angle_' run])(i)) > deg2rad(30)) && s.(['Long_acc_' run])(i) < 0
                s.(['Entry_DIFF_TSA_' run])(i) = s.(['DIFF_TSA_' run])(i);
            else
                s.(['Entry_DIFF_TSA_' run])(i) = nan;
            end
        end
        
        balance{idx} = round(mean(s.(['Entry_DIFF_TSA_' run]), "omitnan"),3);

        
% reshape to average for N continuous samples
% deletes the last k values so that there is no remainder after
% concatenation

    % get TSA data 
        to_delete = mod(int64(length(s.(['DIFF_TSA_' run]))), no_sampl);
        new_size = int64(length(s.(['DIFF_TSA_' run]))) - to_delete;

        s.(['DIFF_TSA_' run]) = smooth(mean(reshape(s.(['DIFF_TSA_' run])(1:new_size), no_sampl, [])));

       % get lap distnace and speed in order
%         s.(['Lap_Dist_' run]) = mean(reshape(s.(['Lap_Dist_' run])(1:new_size), no_sampl, []));
        s.(['Speed_' run]) = round(mean(reshape(s.(['Speed_' run])(1:new_size), no_sampl, [])));

    %create graph
color = { '[0, 0.4, 0]', '[0, 0.4, 0]', '[0, 0.4, 0]', '[0, 0.4, 0]', ...
          '[0, 0, 0.6]', '[0, 0, 0.6]', '[0, 0, 0.6]', '[0, 0, 0.6]', '[0, 0, 0.6]', ...
          '[1, 0, 0]', '[1, 0, 0]', '[1, 0, 0]' };
        style = {'--', '-'};

%         patch(s.(['Lap_Dist_' run]), s.(['DIFF_TSA_' run]),s.(['Speed_' run]), 'FaceColor', 'none', 'EdgeColor', 'interp', 'Marker', markers(idx), 'LineWidth', 1.5)
        scatter(balance{idx}, times{idx},50, "filled", 'MarkerFaceColor',color{idx});
        
        hold on


end

% pretty up the figure
grid on
x = xlabel('Entry balance, TSA, F-R','FontName', 'Serif');
set(x, 'FontSize', 24)
y = ylabel('Laptime, s', 'FontName', 'Serif');
set(y, 'FontSize', 24)
% title('Vehicle balance over a lap from Tire Slip Angles')

% ------------------------------ CHANGE AXES -----------------------------
axis([0 1.3 104.4 105.8])
%-------------------------------------------------------------------------

ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;
% h = colorbar;
% ylabel(h, 'Car speed, kph', 'FontSize', 20)

legend_strings = string(runs) + '; Laptime: ' + string(times) + '; M.D.f.O.B: ' + string(balance);
% for i = 1:idx
%     L(i) = plot(nan, nan, ['b' markers(i)]);
% end
leg = legend(legend_strings);
set(leg, 'Interpreter', 'none', 'FontSize', 10, 'Location', 'northeast');
hold off
