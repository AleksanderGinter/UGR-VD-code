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


    % high frequency spikes filter
        to_delete = mod(int64(length(s.(['Lat_acc_' run]))), no_sampl);
        new_size = int64(length(s.(['Lat_acc_' run]))) - to_delete;

        s.(['Lat_acc_' run]) = mean(reshape(s.(['Lat_acc_' run])(1:new_size), no_sampl, []));

       % get lap distnace and speed in order
        s.(['Long_acc_' run]) = mean(reshape(s.(['Long_acc_' run])(1:new_size), no_sampl, []));
        s.(['Speed_' run]) = mean(reshape(s.(['Speed_' run])(1:new_size), no_sampl, []));
    


        x = reshape(s.(['Lat_acc_' run]), [], 1);
        y = reshape(s.(['Long_acc_' run]), [], 1);
        z = reshape(s.(['Speed_' run]), [], 1);

    % graph convex hull, convert struct to col vectors, use absolute value
    % of lateral g
        [gg_shape, area] = convhull(x, y, z, 'Simplify', true);

    % calcualte enclosed area by the convex hull
        area_gg{length(area_gg) + 1} = round(area, 0);


    % graphs
        colors = ['r', 'g', 'b', 'c', 'm'];

        trisurf(gg_shape, x,y,z ,"Edgecolor",colors(idx), 'Facecolor', colors(idx), 'Facealpha', 0.1, 'Linestyle', '--', 'Linewidth', 1.2, 'MarkerEdgeColor', colors(idx))
%         view(-70, 10)

%         fn = cscvn([x(gg_shape,1)';y(gg_shape,1)']);
%         fnplt(fn, '--', colors(idx));
%         fnprime = fnder(fn);
%         Kofs = @(s) [1 -1]*(fnval(fn,s) .* flipud(fnval(fnprime,s)));
%         area_gg{length(area_gg) + 1} = round(1/2*integral(Kofs,fn.breaks(1),fn.breaks(end)),2);
        hold on
    
    % scatter points, plot only nth point
        sz=10;
        c = colors(idx);
        n = 150;

%         scatter(x(1:n:end), y(1:n:end), sz, c, "filled", 'HandleVisibility', 'off')
end

% pretty up the figure
grid on
x = xlabel('Lat. acceleration, g','FontName', 'Serif');
set(x, 'FontSize', 24)
y = ylabel('Long. acceleration, g', 'FontName', 'Serif');
set(y, 'FontSize', 24)
z = zlabel('Speed, kph','FontName', 'Serif');
set(z, 'FontSize', 24)


ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;

legend_strings = string(runs) + '; Laptime: ' + string(times) + '; Volume: ' + string(area_gg);
leg = legend(legend_strings);
set(leg, 'Interpreter', 'none', 'FontSize', 16);
hold off