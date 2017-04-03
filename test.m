close all;
% clear all;
clc;

% load meas_cv340_DoH_M_1-2000_Midline_step1;
% meas1 = meas;
% clear meas;
% 
% for i = 1 : 599
%     meas{i} = meas1{i};
% end
% save(['meas_cv340_DoH_M_1', '-', num2str(559), '_step1.mat'], 'meas', '-v7.3');
% 
% tic;
% load meas_S2_CV217_61-2060;
% meas2 = meas;
% load meas_S1_CV217_61-2060;
% meas1 = meas;
% 
% clear meas;
% 
% for i = 61 : length(meas1)
%     meas{i}.view{2} = meas1{i}.view{1};
%     meas{i}.view{3} = meas2{i}.view{2};
%     meas{i}.view{2}.nblob = meas1{i}.view{1}.nobj;
%     meas{i}.view{2}.nobj = meas1{i}.view{1}.nobj;
%     meas{i}.view{3}.nblob = meas2{i}.view{2}.nobj;
%     meas{i}.view{3}.nobj = meas2{i}.view{2}.nobj;
% end
% 
% save('meas_S_CV217_61-2060.mat', 'meas');


% load meas_cv217_midline_S1XS2_3122-4121_Midline_step1

meas1 = meas;

load meas_cv217_midline_S1XS2_2122-3121_Midline_step1

for i = 3122 : 4121
    meas{i}.view{2} = meas1{i}.view{2};
    meas{i}.view{3} = meas1{i}.view{3};
    meas{i}.view{2}.nblob = meas1{i}.view{2}.nobj;
    meas{i}.view{2}.nobj = meas1{i}.view{2}.nobj;
    meas{i}.view{3}.nblob = meas1{i}.view{3}.nobj;
    meas{i}.view{3}.nobj = meas1{i}.view{3}.nobj;
end


save('meas_cv217_midline_S1XS2_2122-4121_Midline_step1.mat', 'meas', '-v7.3')


tic;

% load meas_S2_cv213_
% 
% meas1 = meas;
% 
% load meas_cv217_midline_S1XS2_61-1060_Midline_step1
% 
% for i = 1061 : 2060
%     meas{i}.view{2} = meas1{i}.view{2};
%     meas{i}.view{3} = meas1{i}.view{3};
%     meas{i}.view{2}.nblob = meas1{i}.view{2}.nobj;
%     meas{i}.view{2}.nobj = meas1{i}.view{2}.nobj;
%     meas{i}.view{3}.nblob = meas1{i}.view{2}.nobj;
%     meas{i}.view{3}.nobj = meas1{i}.view{2}.nobj;
% end
% 
% 
% save('meas_cv217_midline_S1XS2_61-2060_Midline_step1.mat', 'meas', '-v7.3')


load meas_cv213_midline_S1XS2_4500-4999_Midline_step1
meas1 = meas;
clear meas;

load meas_cv213_midline_S1XS2_5000-5499_Midline_step1
meas2 = meas;
clear meas;

load meas_cv213_midline_S1XS2_5500-5999_Midline_step1
meas3 = meas;
clear meas;

load meas_cv213_midline_S1XS2_6000-6499_Midline_step1
meas4 = meas;
clear meas;

% load meas_cv213_midline_S1XS2_6500-6999_Midline_step1
% meas5 = meas;
% clear meas;
% 
% load meas_cv213_midline_S1XS2_7000-7499_Midline_step1
% meas6 = meas;
% clear meas;

for i = 4500 : 4999
    meas{i} = meas1{i};
end

for i = 5000 : 5499
    meas{i} = meas2{i};
end

for i = 5500 : 5999
    meas{i} = meas3{i};
end

for i = 6000 : 6499
    meas{i} = meas4{i};
end

% for i = 6500 : 6999
%     meas{i} = meas5{i};
% end
% 
% for i = 7000 : 7499
%     meas{i} = meas6{i};
% end

save('meas_cv217_midline_S1XS2_2122-4121_Midline_step1.mat', 'meas', '-v7.3')