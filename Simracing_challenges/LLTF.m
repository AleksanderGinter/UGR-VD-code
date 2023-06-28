clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
no_sampl = 600;

% get your path to the folder where the runs are saved
folder = 'D:\UGRacing\UGR EV23\VD\Challenge4';

manual_legend = {'Final setup', 'Stock setup'};
% ----------------------------------------------------


% get speed range correct


%// Get all MAT files in directory
f = dir(fullfile(folder, '*.mat'));
runs = {};
times = {};
balance = {};
CoG = 0.457;

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
        s.(['Tire_Load_FL_' run]) = Tire_Load_FL.Value;
        s.(['Tire_Load_RL_' run]) = Tire_Load_RL.Value;
        s.(['Tire_Load_FR_' run]) = Tire_Load_FR.Value;
        s.(['Tire_Load_RR_' run]) = Tire_Load_RR.Value;

        s.(['Lap_Dist_' run]) = Corr_Dist.Value;
        s.(['Speed_' run]) = Ground_Speed.Value;

    % getting the lap started at 0
        s.(['Time_' run]) = s.(['Time_' run]) - s.(['Time_' run])(1,1);
        s.(['Lap_Dist_' run]) = s.(['Lap_Dist_' run]) - s.(['Lap_Dist_' run])(1,1);
        times{length(times) + 1} = s.(['Time_' run])(1, end);

    % stitching the values together
    % get load diff on tires, left - right tires
        s.(['L_front_' run]) = abs((s.(['Tire_Load_FL_' run]) - s.(['Tire_Load_FR_' run])));
        s.(['L_rear_' run]) = abs((s.(['Tire_Load_RL_' run]) - s.(['Tire_Load_RR_' run])));
    
    % Front load transfer, % ((Front DIFF) / (Front DIFF + Rear DIFF))
        s.(['LTF_' run]) = 100*CoG - s.(['L_front_' run])  ./ ( s.(['L_front_' run]) + s.(['L_rear_' run])) .* 100;

        balance{idx} = round(sum(s.(['LTF_' run]))/ length(s.(['LTF_' run])), 3);

        
% reshape to average for N continuous samples
% deletes the last k values so that there is no remainder after
% concatenation

    % get TSA data 
        to_delete = mod(int64(length(s.(['LTF_' run]))), no_sampl);
        new_size = int64(length(s.(['LTF_' run]))) - to_delete;

        s.(['LTF_' run]) = mean(reshape(s.(['LTF_' run])(1:new_size), no_sampl, []));

       % get lap distnace and speed in order
        s.(['Lap_Dist_' run]) = mean(reshape(s.(['Lap_Dist_' run])(1:new_size), no_sampl, []));
        s.(['Speed_' run]) = round(mean(reshape(s.(['Speed_' run])(1:new_size), no_sampl, [])));

    %create graph
        markers = ['', '', '^', '<', '+'];

        patch(s.(['Lap_Dist_' run]), s.(['LTF_' run]), s.(['Speed_' run]), 'FaceColor', 'none', 'EdgeColor', 'interp', 'LineWidth', 1.5) % 'Marker', markers(idx), 
%         scatter(s.(['Lap_Dist_' run]), s.(['LTF_' run]),18, s.(['Speed_' run]), markers(idx));
%         plot(s.(['Lap_Dist_' run]), s.(['DIFF_TSA_' run]), 'LineWidth', 0.75)
        colormap jet
        hold on

end






% pretty up the figure
grid on
x = xlabel('Corrected Lap Distance, [m]','FontName', 'Serif');
set(x, 'FontSize', 24)
y = ylabel('LLTF, %', 'FontName', 'Serif');
set(y, 'FontSize', 24)

% ------------------------------ CHANGE AXES -----------------------------
% axis([0 7000 -5 5])
%-------------------------------------------------------------------------

ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;
h = colorbar;
ylabel(h, 'Car speed, kph', 'FontSize', 20)

legend_strings = string(manual_legend) + '; Laptime: ' + string(times) + '; Mean LLTF, %: ' + string(balance);
% for i = 1:idx
%     L(i) = plot(nan, nan, ['b' markers(i)]);
% end
leg = legend(legend_strings);
set(leg, 'Interpreter', 'none', 'FontSize', 16);
hold off

