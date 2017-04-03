% function Manual_Mark()

close all;
clear all;
clc;

global sample_bg_frame;
global sample_ed_frame;
global sample_delta_frame;
global nfish;

nfish = 1;
sample_bg_frame = 1;
sample_ed_frame = 5;
sample_delta_frame = 2;

% manually mark a single fish in all frmaes
for fish = 1 : 1
%     clear x;
    t = 1;
    for fr = sample_bg_frame : sample_delta_frame : sample_ed_frame
        fr
        img_original = im2double(imread(['E:/FtpRoot/Dataset/20160617/27_Stone/CoreView_340_Flare_4M180_NCL_(2)_', sprintf('%05d', fr), '.bmp']));
%         img_original = im2double(imread(['CoreView_257\\CoreView_257_Master_Camera_', sprintf('%04d', fr), '.bmp']));
        figure, imshow(img_original);
        set(gcf,'outerposition',get(0,'screensize'));
        [x(fr, 1), x(fr, 2)] = ginput;
        close all;
        t = t + 1;
    end
    save(['fish_340_', num2str(fish), '_', num2str(sample_bg_frame), '-', num2str(sample_ed_frame), '.mat'], 'x');
end