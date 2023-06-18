clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 100;

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
        times{length(times) + 1} = s.(['Time_' run])(1, end);

        % high frequency spikes filter
        to_delete = mod(int64(length(s.(['Lat_acc_' run]))), no_sampl);
        new_size = int64(length(s.(['Lat_acc_' run]))) - to_delete;

        s.(['Lat_acc_' run]) = mean(reshape(s.(['Lat_acc_' run])(1:new_size), no_sampl, []));

       % get lap distnace and speed in order
        s.(['Long_acc_' run]) = mean(reshape(s.(['Long_acc_' run])(1:new_size), no_sampl, []));
        s.(['Speed_' run]) = mean(reshape(s.(['Speed_' run])(1:new_size), no_sampl, []));


        x = reshape(s.(['Lat_acc_' run]), [], 1);
        y = reshape(s.(['Long_acc_' run]), [], 1);

    % graph convex hull, convert struct to col vectors
        [gg_shape, area] = convhull(x, y);

        colors = ['r', 'g', 'b', 'c', 'm'];

        fn = cscvn([x(gg_shape,1)';y(gg_shape,1)']);
        fnplt(fn, '--', colors(idx));
        fnprime = fnder(fn);
        Kofs = @(s) [1 -1]*(fnval(fn,s) .* flipud(fnval(fnprime,s)));
        area_gg{length(area_gg) + 1} = round(1/2*integral(Kofs,fn.breaks(1),fn.breaks(end)),2);
        hold on
    
    % scatter points
        sz=3;
        c = colors(idx);
%         scatter(s.(['Lat_acc_' run]), s.(['Long_acc_' run]), sz, c)
end

% pretty up the figure
grid on
x = xlabel('Long. acceleration, g','FontName', 'Serif');
set(x, 'FontSize', 24)
y = ylabel('Lat. acceleration, g', 'FontName', 'Serif');
set(y, 'FontSize', 24)
title(string(round(1000/no_sampl,0)) + 'Hz')


axis([-5 5 -4 3])

ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;

legend_strings = string(runs) + '; Laptime: ' + string(times) + '; Area: ' + string(area_gg);
leg = legend(legend_strings);
set(leg, 'Interpreter', 'none', 'FontSize', 16);
hold off