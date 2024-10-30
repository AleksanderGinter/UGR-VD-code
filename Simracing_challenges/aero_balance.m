clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 10;

% get your path to the folder where the runs are saved
folder = 'D:\UGRacing\UGR EV24\SimRacing\Challenge4\matlab\aero_balance';

manual_legend = {'Lamborghini R10', 'Lamborghini R11 | -2 RW', 'Lamborghini R11 | -2 RW','Lamborghini R11 | -2 RW','Lamborghini R12 | -1 RW', ...
    'Mercedes R8', 'Mercedes R9 | -2 RW', 'Mercedes R10 | -1 RW', 'Mercedes R10 | -1 RW', 'Mercedes R10 | -1 RW',...
    'Porsche R9', 'Porsche R10 | +1 FW', 'Porsche R11 | +2 FW','Porsche R11 | +2 FW','Porsche R11 | +2 FW', 'Porsche R12 | +3 FW', 'Porsche R13 | +4 FW'};
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


        s.(['AVE_TSA_F_' run]) = (s.(['TSA_FL_Value_' run]) + s.(['TSA_FR_Value_' run])) ./2;
        s.(['AVE_TSA_R_' run]) = (s.(['TSA_RL_Value_' run]) + s.(['TSA_RR_Value_' run])) ./2;
    
    % Difference in angle, F- R, average
        s.(['DIFF_TSA_' run]) = s.(['AVE_TSA_F_' run]) - s.(['AVE_TSA_R_' run]);

        

        % makre grpah

        color = { '[0, 0.4, 0]', '[0, 0.4, 0]','[0, 0.4, 0]','[0, 0.4, 0]', '[0, 0.4, 0]', ...
          '[0, 0, 0.6]', '[0, 0, 0.6]', '[0, 0, 0.6]', '[0, 0, 0.6]','[0, 0, 0.6]', ...
          '[1, 0, 0]', '[1, 0, 0]', '[1, 0, 0]', '[1, 0, 0]','[1, 0, 0]','[1, 0, 0]','[1, 0, 0]' };
        style = {'o', 'd','d','d', 'v', 'o', 'd', 'v', 'v', 'v', 'o', 'd', 'v','v','v' '^', 's'};

%         patch(s.(['Lap_Dist_' run]), s.(['DIFF_TSA_' run]),s.(['Speed_' run]), 'FaceColor', 'none', 'EdgeColor', 'interp', 'Marker', markers(idx), 'LineWidth', 1.5)

        for i=1:length(s.(['Lap_Dist_' run]))
            if s.(['Speed_' run])(i) >= 135
                s.(['DIFF_TSA_Balance_' run])(i) = s.(['DIFF_TSA_' run])(i);
            else
                s.(['DIFF_TSA_Balance_' run])(i) = nan;
            end
        end

        balance{idx} = round(mean(s.(['DIFF_TSA_Balance_' run]), "omitnan"),3);

        scatter(balance{idx}, times{idx}, 100,  "filled", 'Marker', style{idx}, 'MarkerFaceColor',color{idx});
        hold on

end


plot([balance{1:3}], [times{1:3}], 'LineWidth', 1.5, 'LineStyle', '--', 'Color', [0, 0.4, 0]);
plot([balance{4:6}], [times{4:6}], 'LineWidth', 1.5, 'LineStyle', '--', 'Color', [0, 0, 0.6]);
plot([balance{7:11}], [times{7:11}], 'LineWidth', 1.5, 'LineStyle', '--', 'Color', [1, 0, 0]);


% pretty up the figure
grid on
x = xlabel('High speed balance, TSA, [deg]', 'FontName', 'Serif'); 
set(x, 'FontSize', 24)
y = ylabel('Laptime, s','FontName', 'Serif');
set(y, 'FontSize', 24)
% title('Vehicle balance over a lap from Tire Slip Angles')

% ------------------------------ CHANGE AXES -----------------------------
% axis([0.4 0.65 103 106])
%-------------------------------------------------------------------------

ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;
% h = colorbar;
% ylabel(h, 'Car speed, kph', 'FontSize', 20)

% legend_strings = string(manual_legend); %+ '; Laptime: ' + string(times);% + '; M.D.f.O.B: ' + string(balance);
% % for i = 1:idx
% %     L(i) = plot(nan, nan, ['b' markers(i)]);
% % end
% leg = legend(legend_strings);
% set(leg, 'Interpreter', 'none', 'FontSize', 16, 'Location', 'southwest');
% hold off
