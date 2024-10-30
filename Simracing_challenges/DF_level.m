clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 10;

% get your path to the folder where the runs are saved
folder = 'D:\UGRacing\UGR EV24\SimRacing\Challenge4\matlab\DF_level';

manual_legend = {'Lamborghini R12 | FW: 1 RW: 4', 'Lamborghini R13 | FW: 0 RW: 1',...
    'Mercedes R11 | | FW: 1 RW: 5', 'Mercedes R13 | | FW: 0 RW: 3',...
    'Porsche R13 | | FW: 5 RW: 20', 'Porsche R14 | FW: 4 RW: 19', 'Porsche R16 | | FW: 1 RW: 15', 'Porsche R17 | | FW: 3 RW: 17'};
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
        s.(['Long_acc_' run]) = CG_Accel_Longitudinal.Value;
        s.(['Brake_' run]) = Brake_Pos.Value;
        s.(['Throttle_' run]) = Throttle_Pos.Value;
        s.(['Steering_' run]) = Steering_Angle.Value;
        s.(['Gear_' run]) = Gear.Value;



    % getting the lap started at 0
        s.(['Time_' run]) = s.(['Time_' run]) - s.(['Time_' run])(1,1);
        s.(['Lap_Dist_' run]) = s.(['Lap_Dist_' run]) - s.(['Lap_Dist_' run])(1,1);
        times{length(times) + 1} = s.(['Time_' run])(1, end);

        top_speed = 0;
        max_rpm_achieved = 0;
         
        % makre grpah

        color = { '[0, 0.4, 0]',  '[0, 0.4, 0]', ...
          '[0, 0, 0.6]', '[0, 0, 0.6]', ...
          '[1, 0, 0]', '[1, 0, 0]', '[1, 0, 0]', '[1, 0, 0]'};
        style = {'o', 'd','o', 'd','o', 'd', 'v', 's'};

%         patch(s.(['Lap_Dist_' run]), s.(['DIFF_TSA_' run]),s.(['Speed_' run]), 'FaceColor', 'none', 'EdgeColor', 'interp', 'Marker', markers(idx), 'LineWidth', 1.5)


        scatter(max(s.(['Lap_Dist_' run]))/ times{idx} * 3.6, max(s.(['Speed_' run])), 100,  "filled", 'Marker', style{idx}, 'MarkerFaceColor',color{idx});

        hold on

end

% pretty up the figure
grid on
x = xlabel('Mean Speed, [kph]', 'FontName', 'Serif'); 
set(x, 'FontSize', 24)
y = ylabel('Top Speed, kph]','FontName', 'Serif');
set(y, 'FontSize', 24)
% title('Vehicle balance over a lap from Tire Slip Angles')

% ------------------------------ CHANGE AXES -----------------------------
% axis([90 100 238 245])
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
