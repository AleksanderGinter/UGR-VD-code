clear all

matrix_CLF = nan(9,9);

for run = 1:81
    matrix_CLF(mod(run-1,9)+1, ceil(run / 9)) = run;    disp(run)
end

disp(matrix_CLF)