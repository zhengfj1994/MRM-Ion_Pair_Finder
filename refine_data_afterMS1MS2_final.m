% to refine the results of data_afterMS1MS2_final
%%

function [resu_refine_data_afterMS1MS2_final] = refine_data_afterMS1MS2_final(tol_tR, tol_mz)

X = csvread('data_afterMS1MS2_final.csv');
posi_DEL = [];
% DEL the par~child correlation ions
[m, n] = size(X);
for i = 1 : m - 1
    par_tR = X(i, 4); par_mz = X(i, 5);
    for j = i + 1 : m
        child_tR = X(j, 9); child_mz = X(j, 11);
        if abs(par_tR - child_tR) <= tol_tR && abs(par_mz - child_mz) <= tol_mz
            posi_DEL = [posi_DEL; i];
        end
    end
end
X(posi_DEL, :) = [];

resu_refine_data_afterMS1MS2_final = X;

% THE END
