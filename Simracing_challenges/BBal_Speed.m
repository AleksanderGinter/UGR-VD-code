clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 10;

% get your path to the folder where the runs are saved
folder = 'D:\UGRacing\UGR EV24\SimRacing\Challenge4\matlab\BBAL';

manual_legend = {'Lamborghini R6', 'Lamborghini R8 | -2% BBal', 'Mercedes R4', 'Mercedes M7 | -2% BBal', 'Porsche R5', 'Porsche R6 | -2% BBal'};
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
        s.(['TSR_FL_Value_' run]) = Tire_Slip_Ratio_FL.Value;
        s.(['TSR_RL_Value_' run]) = Tire_Slip_Ratio_RL.Value;
        s.(['TSR_FR_Value_' run]) = Tire_Slip_Ratio_FR.Value;
        s.(['TSR_RR_Value_' run]) = Tire_Slip_Ratio_RR.Value;

        s.(['Lap_Dist_' run]) = Corr_Dist.Value;
        s.(['Speed_' run]) = Ground_Speed.Value;
        s.(['Lat_acc_' run]) = CG_Accel_Lateral.Value;
        s.(['Long_acc_' run]) = CG_Accel_Longitudinal.Value;

    % getting the lap started at 0
        s.(['Time_' run]) = s.(['Time_' run]) - s.(['Time_' run])(1,1);
        s.(['Lap_Dist_' run]) = s.(['Lap_Dist_' run]) - s.(['Lap_Dist_' run])(1,1);
        times{length(times) + 1} = s.(['Time_' run])(1, end);

    % stitching the values together
        s.(['AVE_TSR_F_' run]) = (s.(['TSR_FL_Value_' run]) + s.(['TSR_FR_Value_' run])) ./2;
        s.(['AVE_TSR_R_' run]) = (s.(['TSR_RL_Value_' run]) + s.(['TSR_RR_Value_' run])) ./2;
    
    % Ratio, F/R
        s.(['Ratio_TSR_' run]) = s.(['AVE_TSR_F_' run]) ./ s.(['AVE_TSR_R_' run]);

   % Cumulative difference in angle, F- R, average
%         s.(['DIFF_TSA_' run]) = cumsum(s.(['AVE_TSA_F_' run]) - s.(['AVE_TSA_R_' run]));

%         balance{idx} = round(sum(s.(['DIFF_TSA_' run]))/length(s.(['DIFF_TSA_' run])), 3);

        
% reshape to average for N continuous samples
% deletes the last k values so that there is no remainder after
% concatenation

    % get TSA data 

    %create graph
        color = {'g', 'g', 'b', 'b', 'r', 'r'};
        style_plot = {'-', '--'};
        style = {'o', 's'};

%         patch(s.(['Lap_Dist_' run]), s.(['DIFF_TSA_' run]),s.(['Speed_' run]), 'FaceColor', 'none', 'EdgeColor', 'interp', 'Marker', markers(idx), 'LineWidth', 1.5)
%         scatter(s.(['TSA_FL_Time_' run]), s.(['DIFF_TSA_' run]),18, s.(['speed_' run]), markers(idx));

%         for i=1:5:length(s.(['Ratio_TSR_' run]))
%             if s.(['AVE_TSR_R_' run])(i) < -1
%                 scatter(s.(['Lap_Dist_' run])(i), s.(['Ratio_TSR_' run])(i), 50, color{idx}, 'filled', 'Marker', style{mod(idx,2)+1});
%             end
%         end
        plot(s.(['Lap_Dist_' run]), s.(['Speed_' run]), 'LineStyle', style_plot{mod(idx,2)+1}, 'LineWidth', 1.5, 'Color', color{idx})%, 'Marker', markers(idx))
        hold on

end

% pretty up the figure
grid on
x = xlabel('Corrected Lap Distance, [m]','FontName', 'Serif');
set(x, 'FontSize', 24)
y = ylabel('Ratio of average axle slip ratios, F/R', 'FontName', 'Serif');
set(y, 'FontSize', 24)
% title('Vehicle balance over a lap from Tire Slip Angles')

% ------------------------------ CHANGE AXES -----------------------------
axis([500 700 60 260])
%-------------------------------------------------------------------------

ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;
% h = colorbar;
% ylabel(h, 'Car speed, kph', 'FontSize', 20)

legend_strings = string(manual_legend); %+ '; Laptime: ' + string(times);% + '; M.D.f.O.B: ' + string(balance);
% for i = 1:idx
%     L(i) = plot(nan, nan, ['b' markers(i)]);
% end
leg = legend(legend_strings);
set(leg, 'Interpreter', 'none', 'FontSize', 16, 'Location', 'northeast');
hold off
