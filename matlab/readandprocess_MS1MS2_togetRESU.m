% to process MS1, MS2 and get the final results...
% by Zhongda ZENG, SEP-03-2014

function [data_afterMS1, data_afterMS1MS2_all, data_afterMS1MS2_final] = readandprocess_MS1MS2_togetRESU
clear
%%
filepath_MS1 = findobj(0, 'tag', 'new_finder_01'); filepath_MS1 = get(filepath_MS1, 'String');
filepath_MS2 = findobj(0, 'tag', 'new_finder_02'); filepath_MS2 = get(filepath_MS2, 'String');
tol_tR = findobj(0, 'tag', 'new_finder_05'); tol_tR = get(tol_tR, 'String'); tol_tR = str2num(tol_tR);
tol_mz = findobj(0, 'tag', 'new_finder_06'); tol_mz = get(tol_mz, 'String'); tol_mz = str2num(tol_mz);
info = findobj(0, 'tag', 'new_finder_08'); % info = get(info, 'String');
MS2_intensity = findobj(0, 'tag', 'new_finder_09'); MS2_intensity = get(MS2_intensity, 'String'); MS2_intensity = str2num(MS2_intensity);
diff_MS2MS1 = findobj(0, 'tag', 'new_finder_10'); diff_MS2MS1 = get(diff_MS2MS1, 'String'); diff_MS2MS1 = str2num(diff_MS2MS1);

%%
thefiles = dir(fullfile(filepath_MS1,'*'));
thefiles = {thefiles.name}';
thefiles_i = thefiles(3);
thefiles_i = thefiles_i{1};
thefiles_i = thefiles_i(1 : length(thefiles_i));
thefiles_i_name = thefiles_i;
thefiles_i = importdata([filepath_MS1,'\',thefiles_i_name]);
before_pretreatment = thefiles_i.data;

index_file = before_pretreatment(:,1);
mz = before_pretreatment(:,1);
Rt = before_pretreatment(:,2);
Int = before_pretreatment(:,3:size(before_pretreatment,2));
[max_Int,index_CE]=max(Int,[],2);
CE = index_CE;
data_afterMS1 = [index_file,index_CE,index_file,Rt,mz,max_Int,CE];
set(info, 'String', 'MS1 pretreatment is finished.'); pause(3);
save resu_read_pretreat_match_MS1 data_afterMS1

%%
data_afterMS1MS2 = [];
used_posi = [];
coll_temp = [];
%%
% to load txt data one by one automatically
filepath_MS2 = ['fullfile(' '''' filepath_MS2 '''' ')'];
filepath_MS2 = eval(filepath_MS2);
thefiles = dir(fullfile(filepath_MS2,'*'));
thefiles = {thefiles.name}';
for i_new = 3 : length(thefiles)
    filename = thefiles(i_new);
    filename = filename{1};
    set(info, 'String', ['TO read data: loading MS2-' filename]); pause(1);
    toopen = ['fidin = fopen(' '''' filepath_MS2 '\' filename '''' ');'  ]; % Open file
    eval(toopen);
    fidout1 = fopen('thedata.txt', 'w'); % Creat thedata.txt
    fidout2 = fopen('thechar.txt', 'w'); % Creat thedata.txt
    num = 1;
    while ~feof(fidin) 
        tline = fgetl(fidin); 
        if double(tline(1))>= 48 && double(tline(1))<= 57
            %         fprintf(fidout1, '%s\n\n', tline); 
            fprintf(fidout1, '%s\n', tline); 
            mark_datachar(num) = 1;
            num = num + 1;
            %         continue 
        else
            %         fprintf(fidout2, '%s\n\n', tline); 
            fprintf(fidout2, '%s\n', tline); 
            mark_datachar(num) = 0;
            num = num + 1;
        end
    end
    fclose(fidout1); fclose(fidout2);
    thedata = importdata('thedata.txt'); 
    thechar = importdata('thechar.txt'); 
    mark_datachar = mark_datachar';
    num1 = 1; num2 = 1;
    for i = 1 : length(mark_datachar)
        if mod(i, 1000) == 0
            set(info, 'String', ['TO read data: converting -' num2str(i) ' / ' num2str(length(mark_datachar))]); pause(0.0001);
        end
        if mark_datachar(i) == 1
            thecell{i} = {thedata(num1, :)};
            %thecell{i} = mat2cell(thedata(num1, :));
            num1 = num1 + 1;
        else
            thecell{i} = thechar(num2);
            num2 = num2 + 1;
        end
        %     save test thecell
    end
    thecell = thecell';
    clc;
    % -THE END-
    
    % % developed to delete the data NOT wanted
    % % by Zhongda ZENG @ DICP, NOV-26-2013
    % % inputs: thecell, mark_datachar obtained from program toreadtextfile
    % % MS2_intensity, the tolerance of intensity of MS2
    % % diff_MS2MS1, the m/z difference of MS2 and MS1
    % function [thecell, mark_datachar, thestart, theend, posi_p1, posi_p2] = todeldata_MS2(thecell, mark_datachar, MS2_intensity, diff_MS2MS1)
    % % global thevoltage MS2_intensity diff_MS2MS1 mz_division MS1_betvoltage_deltamz num_MS1 MS1_involtage_deltatR MS1_betvoltage_deltatR_sec MS1_betvoltage_deltatR_per
    %
    clc;
    posi_p1 = [];
    m = length(thecell);
    thestart = []; theend = [];
    for i = 1 : m
        if mod(i, 1000) == 0
            set(info, 'String', ['TO delete ions: 1 of 4 -' num2str(i) ' / ' num2str(m)]); pause(0.0001);
        end
        i_mark_datachar = mark_datachar(i);
        if i_mark_datachar == 0
            i_thecell = thecell{i};
            tofind = length(cell2mat(strfind(i_thecell, 'BEGIN IONS')));
            if tofind == 1
                thestart = [thestart; i];
            end
            tofind = length(cell2mat(strfind(i_thecell, 'END IONS')));
            if tofind == 1
                theend = [theend; i];
            end
        else
            i_thecell = thecell{i};
            i_thecell = cell2mat(i_thecell);
        end
    end
    for i = 1 : m
        if mod(i, 1000) == 0
            set(info, 'String', ['TO delete ions: 2 of 4 -' [num2str(i) ' / ' num2str(m)]]); pause(0.0001);
        end
        i_mark_datachar = mark_datachar(i);
        if i_mark_datachar == 0
            i_thecell = thecell{i};
            %% to del the data with charge > 1
            tofind = length(cell2mat(strfind(i_thecell, 'CHARGE')));
            if tofind == 1
                i_thestart = find(thestart < i); i_thestart = thestart(i_thestart);
                i_theend = find(theend > i); i_theend = theend(i_theend);
                posi1 = abs(i - i_thestart); posi1 = find(posi1 == min(posi1)); posi1 = i_thestart(posi1);
                posi2 = abs(i - i_theend); posi2 = find(posi2 == min(posi2)); posi2 = i_theend(posi2);
                posi_p1 = [posi_p1; [posi1 : posi2]'];
            end
            %% to del the data with diff_MS2MS1 difference between MS1 and MS2
            tofind = length(cell2mat(strfind(i_thecell, 'PEPMASS')));
            if tofind == 1
                i_thecell = i_thecell{1};
                MS1 = str2num(i_thecell(9 : length(i_thecell)));
                temp = i + 2 : length(mark_datachar);
                mark_datachar_toend_0 = find(mark_datachar(temp) == 0);
                temp = temp(mark_datachar_toend_0(1)) - 1;
                for j = i + 2 : temp
                    j_thecell = thecell{j};
                    j_thecell = cell2mat(j_thecell);
                    if MS1 - j_thecell(1) <= diff_MS2MS1
                        posi_p1 = [posi_p1; j];
                    end
                end
            end
        else
            i_thecell = thecell{i};
            i_thecell = cell2mat(i_thecell);
            %% to del the data with intensity smaller than MS2_intensity
            if i_thecell(2) <= MS2_intensity
                posi_p1 = [posi_p1; i];
            end
        end
    end
    posi_p1 = unique(posi_p1);
    thecell(posi_p1) = []; mark_datachar(posi_p1) = [];
    % load test
    %% new finding of thestart & theend
    posi_p2 = [];
    m = length(thecell);
    thestart = []; theend = [];
    for i = 1 : m
        if mod(i, 1000) == 0
            set(info, 'String', ['TO delete ions: 3 of 4 -' num2str(i) ' / ' num2str(m)]); pause(0.0001);
        end
        i_mark_datachar = mark_datachar(i);
        if i_mark_datachar == 0
            i_thecell = thecell{i};
            tofind = length(cell2mat(strfind(i_thecell, 'BEGIN IONS')));
            if tofind == 1
                thestart = [thestart; i];
            end
            tofind = length(cell2mat(strfind(i_thecell, 'END IONS')));
            if tofind == 1
                theend = [theend; i];
            end
        end
    end
    posi3 = [];
    thestart_orig = thestart; theend_orig = theend;
    for i = 1 : length(thestart)
        if mod(i, 1000) == 0
            set(info, 'String', ['TO delete ions: 4 of 4 -' num2str(i) ' / ' num2str(length(thestart))]); pause(0.0001);
        end
        if theend(i) - thestart(i) == 4
            posi3 = [posi3; i];
            posi_p2 = [posi_p2; [thestart(i) : theend(i)]'];
            thestart_orig(i : end) = thestart_orig(i : end) - 5; theend_orig(i : end) = theend_orig(i : end) - 5;
        end
    end
    thestart = thestart_orig; theend = theend_orig;
    thestart(posi3) = []; theend(posi3) = [];
    posi_p2 = unique(posi_p2);
    thecell(posi_p2) = []; mark_datachar(posi_p2) = [];
    %     save test3 thecell mark_datachar thestart theend posi_p1 posi_p2
    %% to start combine MS1 & MS2
    for j_new = 1 : length(thestart)
        if mod(j_new, 1000) == 0
            set(info, 'String', ['MATCH: MS1 & MS1 - MS2, ' num2str(j_new) ' / ' num2str(length(thestart))]); pause(0.0001);
        end
        %_________________________________________________________

        if strcmp('PEPMASS',thecell{thestart(j_new) + 2}{1}(1 : 7)) == 1
            theMS1 = thecell{thestart(j_new) + 2};
            theMS1 = theMS1{1};
            theMS1 = str2num(theMS1(9 : length(theMS1)));
            thetR1 = thecell{thestart(j_new) + 3};
            thetR1 = thetR1{1};
            thetR1 = str2num(thetR1(13 : length(thetR1)));
        else
            theMS1 = thecell{thestart(j_new) + 3};
            theMS1 = theMS1{1};
            theMS1 = str2num(theMS1(9 : length(theMS1)));
            thetR1 = thecell{thestart(j_new) + 2};
            thetR1 = thetR1{1};
            thetR1 = str2num(thetR1(13 : length(thetR1)));
        end
        %_________________________________________________________
        %         save test data_afterMS1 thetR1 theMS1 tol_tR tol_mz
        posi1 = find(abs(data_afterMS1(:, 4) - thetR1) <= tol_tR*60); posi2 = find(abs(data_afterMS1(:, 5) - theMS1) <= tol_mz);
        posi12 = intersect(posi1, posi2);
        if length(posi12) >= 1
            posi12 = posi12(1);
            used_posi = [used_posi; posi12];
            coll_temp = [];
            for k_new = thestart(j_new) + 4 : theend(j_new) - 1
                temp = thecell{k_new};
                temp = temp{1};
                %_______________
                temp = temp(:,1:2);
                %_______________
                temp = [thetR1 theMS1 temp];
%                 coll_temp = [coll_temp; [data_afterMS1(posi12, :) temp i_new - 2]];
                %_______________________________________________________________________________________________________
                coll_temp = [coll_temp; [data_afterMS1(posi12, :) temp str2double(cell2mat(regexp(filename,'\d', 'match')))]];%20190110-ZFJ
                %_______________________________________________________________________________________________________
            end
            data_afterMS1MS2 = [data_afterMS1MS2; coll_temp];
        end
    end
end
[mmm, nnn] = size(data_afterMS1);
thevector = [1 : mmm];
notincluded = setxor(thevector, used_posi);
coll_temp = [data_afterMS1(notincluded, :) 0 * ones(length(notincluded), 5)];
data_afterMS1MS2 = [data_afterMS1MS2; coll_temp];
data_afterMS1MS2_all = data_afterMS1MS2;
%% to extract the exact INFO corresponding to the target voltage
data_afterMS1MS2_final = [];
theunique = data_afterMS1MS2(:, 1);
theunique = unique(theunique);
m = length(theunique);
for i = 1 : m
    thei = theunique(i);
    posi = find(data_afterMS1MS2(:, 1) == thei);
    temp = data_afterMS1MS2(posi, :);
    posi = find(temp(:, 12) == max(temp(:, 12)));
    temp = temp(posi(1), :);
    data_afterMS1MS2_final = [data_afterMS1MS2_final; temp];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dlmwrite('data_afterMS1MS2_all.csv', data_afterMS1MS2_all, 'precision', 8);
dlmwrite('data_afterMS1MS2_final.csv', data_afterMS1MS2_final, 'precision', 8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ADDED -20141226
% to refine the results of data_afterMS1MS2_final
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

resu_refine_data_afterMS1MS2_final = [X(:,4), X(:,9), X(:,10), X(:,11), X(:,12)];
%%    
dlmwrite('resu_refine_data_afterMS1MS2_final.csv', resu_refine_data_afterMS1MS2_final, 'precision', 8);

result_columns_name = {'Retention_time', 'Precusor_ion', 'Product_ion', 'Intensity', ' Collision_energy'};
result_data = table(X(:,4), X(:,9), X(:,10), X(:,11), X(:,12),  'VariableNames', result_columns_name);
writetable(result_data, 'MRM transition list.csv');

delete('thedata.txt');delete('thechar.txt');
delete('resu_read_pretreat_match_MS1.mat');
time=datestr(now); time = strrep(time,':','_');
mkdir(strcat(time)); movefile('*.csv',time);
clc
set(info, 'String', 'Picking is Finished'); 
% -THE END-
