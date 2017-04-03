load('raw_trajs_CV241_222-721_150912.mat', 'trajs');
bg_frame = 222;

cnt = 188;
id = 187;
cnt2 = 721;
cnt1 = 1;

if trajs{id}.ed_frame == -1
    trajs{id}.ed_frame = 722;
end

for i = max(trajs{id}.bg_frame, cnt1) : min(trajs{id}.ed_frame - 1, cnt2)
    img = im2double(imread(['../Fish_2D_CNN/CoreView_241/CoreView_241_Master_Camera_', sprintf('%05d', i), '.bmp']));
    [img_height img_width]  = size(img);
    img_bg = im2double(imread('bkd_241.bmp'));
    img_original = imsubtract(img_bg, img);
        
%     figure, imshow(img_original);
%     hold on;
    
    rect = Get_Head_Rect(trajs{id}.traj{i - trajs{id}.bg_frame + 1}.pt(2), trajs{id}.traj{i - trajs{id}.bg_frame + 1}.pt(1),  -trajs{id}.traj{i - trajs{id}.bg_frame + 1}.ori, 120, 120);

    minx = int32(min(rect(2, :)));
    maxx = int32(max(rect(2, :)));
    miny = int32(min(rect(1, :)));
    maxy = int32(max(rect(1, :)));
    if minx < 1
        minx = 1;
    end
    if maxx > img_height
        maxx = img_height;
    end
    if miny < 1
        miny = 1;
    end
    if maxy > img_width
        maxy = img_width;
    end
    img_small = imcomplement(img_original(minx : maxx, miny : maxy));
    img_small = imrotate(img_small, rad2deg(-trajs{id}.traj{i - trajs{id}.bg_frame + 1}.ori), 'bilinear', 'crop');
%     figure, imshow(img_small);
    imwrite(img_small, ['samples_CoreView241/fish_49_', num2str(cnt), '.bmp']);
    cnt = cnt + 1;
end

cnt