clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 10;

% get your path to the folder where the runs are saved
folder = 'D:\UGRacing\UGR EV24\SimRacing\Challenge4\matlab\FD';

manual_legend = {'Lamborghini R6 | 12/47 FD', 'Lamborghini R10 | 10/47 FD', 'Mercedes R7 | 14/48 FD', 'Mercedes M8 | 12/50 FD', 'Porsche R7 | 14/53 FD', 'Porsche R8 | 10/45 FD'};
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
        s.(['Time_' run]) = Corr_Dist.Time;
        s.(['Lap_Dist_' run]) = Corr_Dist.Value;
        s.(['Speed_' run]) = Ground_Speed.Value;

        s.(['Gear_' run]) = Gear.Value;
        s.(['RPM_' run]) = Engine_RPM.Value;
        s.(['MAX_RPM_' run]) = Max_RPM.Value;

        s.(['Throttle_' run]) = Throttle_Pos.Value;
        s.(['Brake_' run]) = Brake_Pos.Value;


    % getting the lap started at 0
        s.(['Time_' run]) = s.(['Time_' run]) - s.(['Time_' run])(1,1);
        s.(['Lap_Dist_' run]) = s.(['Lap_Dist_' run]) - s.(['Lap_Dist_' run])(1,1);
        times{length(times) + 1} = s.(['Time_' run])(1, end);

        top_speed = 0;
        max_rpm_achieved = 0;
         

        for i=1:length(s.(['Lap_Dist_' run]))
            if s.(['Gear_' run])(i) == max(s.(['Gear_' run])) && s.(['Throttle_' run])(i) == 100
                if s.(['RPM_' run])(i) > max_rpm_achieved
                    max_rpm_achieved = s.(['RPM_' run])(i);
                    top_speed = s.(['Speed_' run])(i);
                end
            end
        end

        % makre grpah

        color = { '[0, 0.4, 0]', '[0, 0.4, 0]', ...
          '[0, 0, 0.6]', '[0, 0, 0.6]', ...
          '[1, 0, 0]', '[1, 0, 0]' };
        style = {'o', 'd'};

%         patch(s.(['Lap_Dist_' run]), s.(['DIFF_TSA_' run]),s.(['Speed_' run]), 'FaceColor', 'none', 'EdgeColor', 'interp', 'Marker', markers(idx), 'LineWidth', 1.5)
        scatter(max_rpm_achieved / max(s.(['MAX_RPM_' run])) * 100 , top_speed, 100,  "filled", 'Marker', style{mod(idx,2)+1}, 'MarkerFaceColor',color{idx});

        hold on

end

% pretty up the figure
grid on
x = xlabel('% of maximum RPM at top gear and speed', 'FontName', 'Serif'); 
set(x, 'FontSize', 24)
y = ylabel('Top speed, [kph]','FontName', 'Serif');
set(y, 'FontSize', 24)
% title('Vehicle balance over a lap from Tire Slip Angles')

% ------------------------------ CHANGE AXES -----------------------------
axis([90 100 238 245])
%-------------------------------------------------------------------------

ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;
% h = colorbar;
% ylabel(h, 'Car speed, kph', 'FontSize', 20)

legend_strings = string(runs); %+ '; Laptime: ' + string(times);% + '; M.D.f.O.B: ' + string(balance);
% for i = 1:idx
%     L(i) = plot(nan, nan, ['b' markers(i)]);
% end
leg = legend(manual_legend);
set(leg, 'Interpreter', 'none', 'FontSize', 16, 'Location', 'northwest');
hold off
