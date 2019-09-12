% to process MS1
% by Zhongda ZENG, SEP-03-2014
% Revised by Zheng Fujian, 2018-09-17
function [data_afterMS1] = read_pretreat_match_MS1
clc; % close all;

filepath_MS1 = findobj(0, 'tag', 'new_finder_01'); filepath_MS1 = get(filepath_MS1, 'String');
info = findobj(0, 'tag', 'new_finder_08'); % info = get(info, 'String');

thefiles = dir(fullfile(filepath_MS1,'*'));
thefiles = {thefiles.name}';
thefiles_i = thefiles(3);
thefiles_i = thefiles_i{1};
thefiles_i = thefiles_i(1 : length(thefiles_i));
thefiles_i_name = thefiles_i;
thefiles_i = importdata([filepath_MS1,'\',thefiles_i_name]);
before_pretreatment = thefiles_i.data;

index_file = before_pretreatment(:,1);
mz = before_pretreatment(:,2);
Rt = before_pretreatment(:,5);
Int = before_pretreatment(:,10:12);
[max_Int,index_CE]=max(Int,[],2);
CE = index_CE;
MS2_qulity =[];
for i = 1:length(CE)
    ramdom_num = randi(100,1);
    MS2_qulity(i,1) = ramdom_num;
end
data_afterMS1 = [index_file,index_CE,index_file,Rt,mz,max_Int,CE,MS2_qulity];
set(info, 'String', 'MS1 pretreatment is finished.'); pause(3);
save resu_read_pretreat_match_MS1 data_afterMS1

% THE END
