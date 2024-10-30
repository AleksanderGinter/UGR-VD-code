% lambo bits

laptimes1 = [45.18, 45.325, 45.17]; % R4
coast1 = [55, 55, 55];
laptimes2 = [45.44, 45.9, 45.5]; %R5, -15 diff coast
coast2 = coast1 - 15;
laptimes3 = [44.88, 45.34, 45.08]; % R6 | R4 + 10%
coast3 = coast1 + 10;
laptimes4 = [45.22, 45.55, 45.44]; %R7 +20%
coast4 = coast1 + 20;

L_trendline = [mean(laptimes2),mean(laptimes1), mean(laptimes3), mean(laptimes4)];
L_trendline_coast = [mean(coast2),mean(coast1),mean(coast3),mean(coast4)] ;

% mercedes bits

m_laps1 = [45.52, 45.46, 46.0]; % R3
m_coast1 = [45, 45, 45];
m_laps2 = [45.74, 45.48, 45.55]; % R4 + 10 diff coast
m_coast2 = m_coast1+10;
m_laps3 = [45.71, 45.98, 45.66]; % R5 | R3 - 10% coast
m_coast3 = m_coast1-10;
m_laps4 = [45.94, 45.95, 45.57]; %R6 as R3 + 20%
m_coast4 = m_coast1+20;

M_trendline = [mean(m_laps3),mean(m_laps1), mean(m_laps2), mean(m_laps4)];
M_trendline_coast = [mean(m_coast3),mean(m_coast1),mean(m_coast2),mean(m_coast4)] ;

% porsche bits
p_laps1 = [45.1, 45.0, 45.64]; % R2
p_coast1 = [60, 60, 60];
p_laps2 = [44.85, 45.18, 44.6]; % + 20% coast
p_coast2 = p_coast1+20;
p_laps3 = [45.35, 44.89, 44.76]; % +10 coast CHANGES IN POWER COAST
p_coast3 = p_coast1+10;

P_trendline = [mean(p_laps1),mean(p_laps3), mean(p_laps2)];
P_trendline_coast = [mean(p_coast1),mean(p_coast3),mean(p_coast2)];

%lambo
scatter(coast1, laptimes1, 50, 'MarkerFaceColor', [0, 0.4, 0], 'MarkerEdgeColor', 'none');
hold on
scatter(coast2, laptimes2, 50, 'MarkerFaceColor', [0, 0.4, 0], 'MarkerEdgeColor', 'none');
scatter(coast3, laptimes3, 50, 'MarkerFaceColor', [0, 0.4, 0], 'MarkerEdgeColor', 'none');
scatter(coast4, laptimes4, 50, 'MarkerFaceColor', [0, 0.4, 0], 'MarkerEdgeColor', 'none');

% merc
scatter(m_coast1, m_laps1, 50, 'MarkerFaceColor', [0, 0, 0.6], 'MarkerEdgeColor', 'none');
scatter(m_coast2, m_laps2, 50, 'MarkerFaceColor', [0, 0, 0.6], 'MarkerEdgeColor', 'none');
scatter(m_coast3, m_laps3, 50, 'MarkerFaceColor', [0, 0, 0.6], 'MarkerEdgeColor', 'none');
scatter(m_coast4, m_laps4, 50, 'MarkerFaceColor', [0, 0, 0.6], 'MarkerEdgeColor', 'none');

% porsche
scatter(p_coast1, p_laps1, 50, 'MarkerFaceColor', [1, 0, 0], 'MarkerEdgeColor', 'none');
scatter(p_coast2, p_laps2, 50, 'MarkerFaceColor', [1, 0, 0], 'MarkerEdgeColor', 'none');
scatter(p_coast3, p_laps3, 50, 'MarkerFaceColor', [1, 0, 0], 'MarkerEdgeColor', 'none', 'Marker','diamond');

plot(L_trendline_coast, L_trendline, 'LineWidth', 1.5, 'LineStyle', '--', 'Color', [0, 0.4, 0]);
plot(M_trendline_coast, M_trendline, 'LineWidth', 1.5, 'LineStyle', '--', 'Color', [0, 0, 0.6]);
plot(P_trendline_coast, P_trendline, 'LineWidth', 1.5, 'LineStyle', '--', 'Color', [1, 0, 0]);


% axis([-20 25 44.4 46.2])

grid on
x = xlabel('Coast Differential Lock, %','FontName', 'Serif');
set(x, 'FontSize', 16)
y = ylabel('Laptime, s', 'FontName', 'Serif');
set(y, 'FontSize', 16)

colors = {'[0, 0.4, 0]', '[0, 0, 0.6]', '[1, 0, 0]'};

legend_strings = {'Lamborghini', 'Mercedes', 'Porsche'};
for i = 1:3
    L(i) = plot(nan, nan, 'Color', colors{i}, 'LineStyle', '-');
end
leg = legend(L, legend_strings);
set(leg, 'Interpreter', 'none', 'FontSize', 16, 'Location', 'northeast');
hold off; % Release the current plot
