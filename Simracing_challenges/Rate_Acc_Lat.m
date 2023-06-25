clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 500;

% get your path to the folder where the runs are saved
folder = 'D:\UGRacing\UGR EV23\VD\Challenge4';

manual_legend = {'Final setup', 'Stock setup'};
% ----------------------------------------------------


% get speed range correct


%// Get all MAT files in directory
f = dir(fullfile(folder, '*.mat'));
runs = {};
times = {};
area_gg = {};


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
        s.(['Lat_acc_' run]) = CG_Accel_Lateral.Value;
        s.(['Long_acc_' run]) = CG_Accel_Longitudinal.Value;

    % getting the lap started at 0
        s.(['Time_' run]) = s.(['Time_' run]) - s.(['Time_' run])(1,1);
        s.(['Lap_Dist_' run]) = s.(['Lap_Dist_' run]) - s.(['Lap_Dist_' run])(1,1);
        time = s.(['Time_' run])(1, end);
        times{length(times) + 1} = time;

    % get rate of acceleration
    for i = 1:numel(s.(['Lat_acc_' run]))-1
        s.(['RLat_acc_' run])(i) = (s.(['Lat_acc_' run])(i+1) - s.(['Lat_acc_' run])(i)) ./ (no_sampl/1000);

    end

    % high frequency spikes filter
        to_delete = mod(int64(length(s.(['Lat_acc_' run]))), no_sampl);
        new_size = int64(length(s.(['Lat_acc_' run]))) - to_delete;

        s.(['RLat_acc_' run]) = mean(reshape(s.(['RLat_acc_' run])(1:new_size), no_sampl, []));

       % get lap distnace and speed in order
        s.(['Lap_Dist_' run]) = mean(reshape(s.(['Lap_Dist_' run])(1:new_size), no_sampl, []));
        s.(['Speed_' run]) = mean(reshape(s.(['Speed_' run])(1:new_size), no_sampl, []));

    %create graph
        markers = ['', '', '^', '<', '+'];

        patch(s.(['Lap_Dist_' run]), s.(['RLat_acc_' run]), s.(['Speed_' run]), 'FaceColor', 'none', 'EdgeColor', 'interp', 'LineWidth', 1.5) % 'Marker', markers(idx), 
%         scatter(s.(['Lap_Dist_' run]), s.(['LTF_' run]),18, s.(['Speed_' run]), markers(idx));
%         plot(s.(['Lap_Dist_' run]), s.(['DIFF_TSA_' run]), 'LineWidth', 0.75)
        colormap jet
        hold on

end






% pretty up the figure
grid on
x = xlabel('Corrected Lap Distance, [m]','FontName', 'Serif');
set(x, 'FontSize', 24)
y = ylabel('Rate of Lateral Acc, [ms^{-3}]', 'FontName', 'Serif');
set(y, 'FontSize', 24)

% ------------------------------ CHANGE AXES -----------------------------
axis([0 7000 -0.1 0.1])
%-------------------------------------------------------------------------

ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;
h = colorbar;
ylabel(h, 'Car speed, kph', 'FontSize', 20)

legend_strings = string(manual_legend) + '; Laptime: ' + string(times); % + '; Mean LTF: ' + string(balance);
% for i = 1:idx
%     L(i) = plot(nan, nan, ['b' markers(i)]);
% end
leg = legend(legend_strings);
set(leg, 'Interpreter', 'none', 'FontSize', 16);
hold off

