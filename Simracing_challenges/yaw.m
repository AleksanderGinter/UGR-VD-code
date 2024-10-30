clear all
clf
s = struct();

% ---------------  CHANGE THESE  --------------------

% number of consecutive values that are averaged
% basically number of ms (miliseconds)
% no_sampl = 10;

% get your path to the folder where the s are saved
% folder = 'D:\UGRacing\UGR EV24\SimRacing\Challenge4\matlab\speed';

% manual_legend = {'Wings' };
  %  'Mercedes R8', 'Mercedes R9 | -2 RW', 'Mercedes R10 | -1 RW', ...
   % 'Porsche R9', 'Porsche R10 | +1 FW', 'Porsche R11 | +2 FW', 'Porsche R12 | +3 FW', 'Porsche R13 | +4 FW'};
% ----------------------------------------------------

%     scatter(temp_arrayYaw, CL_yaw./max(CL_yaw)*100, 'red','filled')
%     hold on
% 
%     random_values = 0.2 * rand(size(CL_yaw));
%     scatter(temp_arrayYaw + random_values, (CL_yaw+ random_values-0.25)./max((CL_yaw+ random_values-0.25))*100, 'blue','filled')
% 
%     random_values2 = 0.3 * rand(size(CL_yaw));
%     scatter(temp_arrayYaw + random_values2, (CL_yaw+ random_values2-0.55)./max(CL_yaw+ random_values2-0.55)*100, 'green','filled')



% get speed range correct


%// Get all MAT files in directory
% f = dir(fullfile(folder, '*.mat'));
% runs = {};
% times = {};
% balance = {};


%// For each MAT file...
% for idx = 1 : numel(f)
% % for idx = 1:1
% 
%     %// Get absolute path to MAT file - i.e. folder/file.mat
%     run = f(idx).name(1:end-4);   %get the name of the run
%     runs{length(runs) + 1} = run;
% 
%     name = fullfile(folder, f(idx).name);
    load("speed.mat");
%      = 'yaw_data';

    %getting data into structure
%         s.(['Time_' ]) = Tire_Slip_Angle_FL.Time;
%         s.(['TSA_FL_Value_' ]) = abs(Tire_Slip_Angle_FL.Value);
%         s.(['TSA_RL_Value_' ]) = abs(Tire_Slip_Angle_RL.Value);
%         s.(['TSA_FR_Value_' ]) = abs(Tire_Slip_Angle_FR.Value);
%         s.(['TSA_RR_Value_' ]) = abs(Tire_Slip_Angle_RR.Value);

%         s.(['Lap_Dist_' ]) = Corr_Dist.Value;
        s.(['Speed_' ]) = Corr_Speed.Value;
%         s.(['Long_acc_' ]) = CG_Accel_Longitudinal.Value;
%         s.(['Brake_' ]) = Brake_Pos.Value;
%         s.(['Throttle_' ]) = Throttle_Pos.Value;
%         s.(['Steering_' ]) = Steering_Angle.Value;
%         s.(['Gear_' ]) = Gear.Value;

            % get values read
%     s.(['Time_' ]) = Corr_Speed.Time;
%     s.(['Lap_Dist_' ]) = Corr_Dist.Value;
%     s.(['Speed_' ]) = Corr_Speed.Value;

    s.(['CLF_' ]) = CLA_Front_Axle.Value;
    s.(['CLR_' ]) = CLA_Rear_Axle.Value;
%     s.(['LongLT_' ]) = Load_Transfer.Value;


    % start the lap at 0
%     s.(['Time_' ]) = s.(['Time_' ]) - s.(['Time_' ])(1,1);
%     s.(['Lap_Dist_' ]) = s.(['Lap_Dist_' ]) - s.(['Lap_Dist_' ])(1,1);



    % Preallocate the arrays to the maximum possible size
%     n = length(s.(['Lap_Dist_' ]));
%     temp_arrayCLF = NaN(1, n);
%     temp_arrayCLR = NaN(1, n);
%     temp_arrayBal = NaN(1, n);

    % Get the logical indices for the condition
%     indices = s.(['Speed_' ]) > 90 & s.(['Speed_' ]) < 180 & s.(['Lap_Dist_' ]) > 100 & s.(['Lap_Dist_' ]) < 250;
%     indices = s.(['Lap_Dist_' ]) > 1000 & s.(['Lap_Dist_' ]) < 1300;
    
    % Use the indices to extract the required values
%     temp_arrayCLF(1:nnz(indices)) = s.(['CLF_' ])(indices);
%     temp_arrayCLR(1:nnz(indices)) = s.(['CLR_' ])(indices);
%     temp_arrayBal(1:nnz(indices)) = s.(['CLF_' ])(indices) ./ (s.(['CLF_' ])(indices)+s.(['CLR_' ])(indices));
% 
%     temp_arrayYaw(1:nnz(indices)) = min(s.(['TSA_RL_Value_' ])(indices), s.(['TSA_RR_Value_' ])(indices));

%     temp_arrayCLF = temp_arrayCLF(~isnan(temp_arrayCLF));
%     temp_arrayCLR = temp_arrayCLR(~isnan(temp_arrayCLR));
%     temp_arrayBal = temp_arrayBal(~isnan(temp_arrayBal));

    
    scatter(Corr_Speed.Value, (CLA_Front_Axle.Value+CLA_Rear_Axle.Value), 'red','filled')
    hold on

%     random_values = 0.2 * rand(size(CL_yaw));
%     scatter(temp_arrayYaw + random_values, CL_yaw+ random_values-0.25, 'blue','filled')
% 
%     random_values2 = 0.3 * rand(size(CL_yaw));
%     scatter(temp_arrayYaw + random_values2, CL_yaw+ random_values2-0.55, 'green','filled')

% plot([balance{1:3}], [times{1:3}], 'LineWidth', 1.5, 'LineStyle', '--', 'Color', [0, 0.4, 0]);
% plot([balance{4:6}], [times{4:6}], 'LineWidth', 1.5, 'LineStyle', '--', 'Color', [0, 0, 0.6]);
% plot([balance{7:11}], [times{7:11}], 'LineWidth', 1.5, 'LineStyle', '--', 'Color', [1, 0, 0]);


% pretty up the figure
grid on
x = xlabel('Speed, [kph]', 'FontName', 'Serif'); 
set(x, 'FontSize', 24)
y = ylabel('Total Downforce CL','FontName', 'Serif');
set(y, 'FontSize', 24)
% title('Vehicle balance over a lap from Tire Slip Angles')

% ------------------------------ CHANGE AXES -----------------------------
% axis([0 4 80 100])
%-------------------------------------------------------------------------

ax = gca;
ax.FontSize = 16;
ax.FontName = 'Serif';
ax.LineWidth = 1.25;
% h = colorbar;
% ylabel(h, 'Car speed, kph', 'FontSize', 20)

% legend_strings = string(manual_legend);% + '; Laptime: ' + string(times); % + '; M.D.f.O.B: ' + string(balance);% for i = 1:idx
% %     L(i) = plot(nan, nan, ['b' markers(i)]);
% % end
% leg = legend(legend_strings);
% set(leg, 'Interpreter', 'none', 'FontSize', 16, 'Location', 'northeast');
% hold off