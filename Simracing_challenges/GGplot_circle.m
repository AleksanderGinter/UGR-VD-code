clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 10;

% get your path to the folder where the runs are saved
folder = 'D:\UGRacing\UGR EV24\SimRacing\Challenge2\data_for_submission\GG_plot';

manual_legend =  {'R1, Baseline', 'R2, +1L, +2R PSI', 'R4, +1 PSI', 'R6, +3 PSI'};
manual_times = {'1:37.388', '1:36.946', '1:36.702', '1:37.214'};
% ----------------------------------------------------


% get speed range correct


%// Get all MAT files in directory
f = dir(fullfile(folder, '*.mat'));
runs = {};
times = {};
area_gg = {};

% 
% %// Get baseline 
%         load("GG plot\COHEN_stint_106.mat")
%         base = 'base';
%         s.(['Time_' base]) = Corr_Dist.Time;
%         s.(['Lap_Dist_' base]) = Corr_Dist.Value;
%         s.(['Speed_' base]) = Ground_Speed.Value;
%         s.(['Lat_acc_' base]) = CG_Accel_Lateral.Value;
%         s.(['Long_acc_' base]) = CG_Accel_Longitudinal.Value;
% 
%     % getting the lap started at 0
%         s.(['Time_' base]) = s.(['Time_' base]) - s.(['Time_' base])(1,1);
%         s.(['Lap_Dist_' base]) = s.(['Lap_Dist_' base]) - s.(['Lap_Dist_' base])(1,1);
%         times{length(times) + 1} = s.(['Time_' base])(1, end);
% 
%         % high frequency spikes filter
%         to_delete = mod(int64(length(s.(['Lat_acc_' base]))), no_sampl);
%         new_size = int64(length(s.(['Lat_acc_' base]))) - to_delete;
% 
%         s.(['Lat_acc_' base]) = mean(reshape(s.(['Lat_acc_' base])(1:new_size), no_sampl, []));
% 
%        % get lap distnace and speed in order
%         s.(['Long_acc_' base]) = mean(reshape(s.(['Long_acc_' base])(1:new_size), no_sampl, []));
%         s.(['Speed_' base]) = mean(reshape(s.(['Speed_' base])(1:new_size), no_sampl, []));
%         s.(['Lap_Dist_' base]) = mean(reshape(s.(['Lap_Dist_' base])(1:new_size), no_sampl, []));
% 
%        % get magnitude of acceleration
%         s.(['RMS_Acc_' base]) = (sqrt(s.(['Lat_acc_' base]).^2 + s.(['Long_acc_' base]).^2));
% 


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
        

%         for i =1:length(s.(['Long_acc_' run]))
% 
%             if s.(['Lat_acc_' run])(i) < -2
%                 s.(['Lat_acc_' run])(i) = 0;
%             end
%         end

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
        s.(['Lap_Dist_' run]) = mean(reshape(s.(['Lap_Dist_' run])(1:new_size), no_sampl, []));



       % get magnitude of acceleration and delta between baseline
        th = linspace(0,2*pi);
        s.(['RMS_Acc_' run]) = (sqrt(s.(['Lat_acc_' run]).^2 + s.(['Long_acc_' run]).^2));
        Radius = quantile(s.(['RMS_Acc_' run]), 0.95);
        x = Radius*cos(th);
        y = Radius*sin(th);
       
%         s.(['RMS_Acc_Delta_' run]) = cumsum(s.(['RMS_Acc_' run])(1:495) - s.(['RMS_Acc_COHEN_stint_106'])(1:495));


%         x = reshape(s.(['Lat_acc_' run]), [], 1);
%         y = reshape(s.(['Long_acc_' run]), [], 1);
% 
%     % graph convex hull, convert struct to col vectors
%         [gg_shape, area] = convhull(x, y);

        colors = ['r', 'g', 'b', 'c', 'm'];
% 
%         fn = cscvn([x(gg_shape,1)';y(gg_shape,1)']);
%         fnplt(fn, '--', colors(idx));
%         fnprime = fnder(fn);
%         Kofs = @(s) [1 -1]*(fnval(fn,s) .* flipud(fnval(fnprime,s)));
%         area_gg{length(area_gg) + 1} = round(1/2*integral(Kofs,fn.breaks(1),fn.breaks(end)),2);
%         hold on
    
 
    % scatter points
        sz=3;
        c = colors(idx);
%          scatter(s.(['Lat_acc_' run]), s.(['Long_acc_' run]), sz, c)
        plot(x, y, 'LineWidth', 1.5, 'Color', c)
        hold on
end

% pretty up the figure
grid on
x = xlabel('Lat. acceleration, g','FontName', 'Serif');
set(x, 'FontSize', 24)
y = ylabel('Long. acceleration, g', 'FontName', 'Serif');
set(y, 'FontSize', 24)
title('G-G plot vs tyre pressures')

x0=10;
y0=10;
width=900;
height=700;
set(gcf,'position',[x0,y0,width,height])


axis([-3 3 -2 2])

ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;

legend_strings = string(manual_legend);% + '; Laptime: ' + string(manual_times);% + '; Area: ' + string(area_gg);
leg = legend(legend_strings);
set(leg, 'Interpreter', 'none', 'FontSize', 16);
hold off