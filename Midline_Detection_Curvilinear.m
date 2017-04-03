function Midline_Detection_Curvilinear(boundary, view_id)

global img;
global img_height;
global img_width;
global midline_pts;
global fr;
global min_midline_len;
global meas;
global joint_pts_tol;
global avg_head_width;
global CNN_sample_ht;
global CNN_sample_wd;
global nseg;
global ang_data;
global bg_frame;
global nfish;
global ang_data_fg;
global img_bw_label;

label = zeros(img_height, img_width);

sigma_begin = 1;
sigma_end  = 100;
sigma_step = 1;
thres = 1;
sigma_array =sigma_begin:sigma_step:sigma_end;
sigma_nb = numel(sigma_array);

snlo = zeros(img_height,img_width,sigma_nb);

sigma = sigma_array(10); % edit fish:10 line: 4
w = 30; %3 * sigma
[x y] = meshgrid(-w : w, -w : w);
sigma2 = sigma^2;
temp = exp(-(x.^2 + y.^2) / (2 * sigma2)) / (2 * pi * sigma2);

% % for dark line
% mxx = temp .* (x.^2 / sigma2 - 1);
% % figure, mesh(x, y, mxx);
% myy = temp .* (y.^2 / sigma2 - 1);
% % figure, mesh(x, y, myy);
% mxy = temp .* (x .* y / sigma2);
% % figure, mesh(x, y, mxy);
% mx = temp .* (-x);
% % figure, mesh(x, y, mx);
% my = temp .* (-y);
% % figure, mesh(x, y, my);

mxx = -temp .* (x.^2 / sigma2 - 1);
% figure, mesh(x, y, mxx);
myy = -temp .* (y.^2 / sigma2 - 1);
% figure, mesh(x, y, myy);
mxy = -temp .* (x .* y / sigma2);
% figure, mesh(x, y, mxy);
mx = -temp .* (-x);
% figure, mesh(x, y, mx);
my = -temp .* (-y);
% figure, mesh(x, y, my);


dxx = imfilter(img,mxx,'replicate');
dyy = imfilter(img,myy,'replicate');
dxy = imfilter(img,mxy,'replicate');
dx = imfilter(img,mx,'replicate');
dy = imfilter(img,my,'replicate');
% figure, imshow(dxx);
% figure, imshow(dyy);
% figure, imshow(dxy);
% figure, imshow(dx);
% figure, imshow(dy);

num = 1;
% tic
idx = find(img >= 0.001);
s = size(img);

maxt = -1e10;
mint = 1e10;

if fr == bg_frame
    for i = 1 : nfish
        ang_data_fg(i) = 0;
        ang_data{i}.active = 0;
    end
else
    for i = 1 : nfish
        ang_data{i}.active = ang_data_fg(i);
        ang_data_fg(i) = 0;
    end
end


for i = 1 : length(idx)
    id = idx(i);
%     tic;
    [EigVector(1 : 2, 1 : 2), ev] = eig([dxx(id), dxy(id); dxy(id), dyy(id)]);
%     toc;
%     Del = dxx(id).*dyy(id)-dxy(id).^2;
    if abs(ev(1, 1)) > abs(ev(2, 2))
        nx = EigVector(1,1);
        ny = EigVector(1,2);
%         order2 = abs(ev(id, 1)); 
    else
        nx = EigVector(2,1);
        ny = EigVector(2,2);
%         order2 = abs(ev(id, 2)); 
    end
    tp = sqrt(nx^2 + ny^2);
    nx = nx / tp;
    ny = ny / tp;
    theta = atan2(ny, nx);

    t = - (dx(id) * nx + dy(id) * ny) / (dxx(id) * nx^2 + 2 * dxy(id) * nx * ny + dyy(id) * ny^2);
    maxt = max((dxx(id) * nx^2 + 2 * dxy(id) * nx * ny + dyy(id) * ny^2), maxt);
    mint = min((dxx(id) * nx^2 + 2 * dxy(id) * nx * ny + dyy(id) * ny^2), mint);
    px = t * nx;
    py = t * ny;
    if px >= -thres && px <= thres && py <= thres && py >= -thres% && (dxx(id) * nx^2 + 2 * dxy(id) * nx * ny + dyy(id) * ny^2) > 0 %  && order2 > 8 && order2 < 15
        [row, col] = ind2sub(s, id);
%         quiver(col, row, nx * 10, ny * 10); %for dark line: quiver(col, row, nx * 10, ny * 10);
        label(row, col) = 1;
%         sequence(num) = order2;
        num = num + 1;
    end
end
% maxt
% mint
% toc;

% figure, imshow(label, []);
small_Ivessel_skel = bwmorph(label, 'skel', Inf);
joint_pts = bwmorph(small_Ivessel_skel, 'branchpoints');
% small_Ivessel_skel = bwmorph(small_Ivessel_skel, 'spur', 5);
% figure, imshow(small_Ivessel_skel);
% hold on;
idx2 = find(small_Ivessel_skel == 1);
[I, J] = ind2sub(s, idx2);
% plot(J, I, 'g.');

midline_pts = small_Ivessel_skel - joint_pts;
joint_pts_set = joint_pts;

while length(find(joint_pts == 1)) > 0
    midline_label = bwlabel(midline_pts);
%     figure, imshow(midline_pts);
%     hold on;
    midline.stats = imfeature(midline_label, 'all');
    areas = [midline.stats.Area];
    idx_skel = find(areas > 10);
    midline_pts = ismember(midline_label, idx_skel);
    joint_pts = bwmorph(midline_pts, 'branchpoints');
    midline_pts = midline_pts - joint_pts;
    joint_pts_set = joint_pts_set + joint_pts;
    idx2 = find(joint_pts == 1);
    [I, J] = ind2sub(s, idx2);
%     plot(J, I, 'b.');
end

idx = find(joint_pts_set == 1);

joint_pts_tol = [];
[joint_pts_tol(:, 2), joint_pts_tol(:, 1)] = ind2sub(s, idx);
% plot(joint_pts_tol(:, 1), joint_pts_tol(:, 2), 'b.');
midline_label = bwlabel(midline_pts);
midline.stats = imfeature(midline_label, 'all');

img_bw.stats = imfeature(img_bw_label, 'all');
fg = zeros(length(img_bw.stats), 1);
% if fr > bg_frame + delta_frame
%     for i = 1 : nfish
%         ang_data{i}.delta_midline_ang(fr, 2 : nseg) = ang_data{i}.delta_midline_ang(fr - delta_frame, 2 : nseg);
%         tp = ang_data{i}.delta_ori(end);
%         ang_data{i}.delta_ori(fr, 1) = tp;
%         ang_data{i}.delta_vel_ang(fr, 1) = 0;
%         ang_data{i}.vel(fr, 1 : 2) = ang_data{i}.vel(fr - delta_frame, 1 : 2);
%     end
% end

meas{fr}.view{view_id}.nobj = 0;
for i = 1 : length(midline.stats)
    if midline.stats(i).Area > min_midline_len
        tp_midline_pts = midline.stats(i).PixelList;
%         plot(tp_midline_pts(:, 1), tp_midline_pts(:, 2), 'y.');
        clear midline_pts;
        midline_pts = Midline_Reorder(tp_midline_pts);
        
        midline_pts = Smooth_2D(midline_pts);
        midline_pts = Smooth_2D(midline_pts);
        midline_pts = Smooth_2D(midline_pts);
        midline_pts2 = resample_equal(midline_pts, 20);
        
%         plot(midline_pts2(:, 1), midline_pts2(:, 2), 'r.');
        ang1 = atan2(midline_pts2(2, 2) - midline_pts2(1, 2), midline_pts2(2, 1) - midline_pts2(1, 1));
        rect_1 = Get_Head_Rect(midline_pts2(1, 1), midline_pts2(1, 2), ang1, avg_head_width * 2, avg_head_width * 3);
        ang2 = atan2(midline_pts2(end, 2) - midline_pts2(end - 1, 2), midline_pts2(end, 1) - midline_pts2(end - 1, 1));
        rect_2 = Get_Head_Rect(midline_pts2(end, 1), midline_pts2(end, 2), ang2, avg_head_width * 2, avg_head_width * 3);

        minx = int32(min(rect_1(2, :)));
        maxx = int32(max(rect_1(2, :)));
        miny = int32(min(rect_1(1, :)));
        maxy = int32(max(rect_1(1, :)));
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
        img_small1 = imcomplement(img(minx : maxx, miny : maxy));
        
        minx = int32(min(rect_2(2, :)));
        maxx = int32(max(rect_2(2, :)));
        miny = int32(min(rect_2(1, :)));
        maxy = int32(max(rect_2(1, :)));
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
        img_small2 = imcomplement(img(minx : maxx, miny : maxy));
        
        if mean(img_small1(:)) > mean(img_small2(:))
            midline_pts2 = flipud(midline_pts2);
        end
        
        midline_pts2 = midline_pts2(2 : end, :);
        ang1 = atan2(midline_pts2(2, 2) - midline_pts2(1, 2), midline_pts2(2, 1) - midline_pts2(1, 1));
        rect_1 = Get_Head_Rect(midline_pts2(1, 1), midline_pts2(1, 2), ang1, avg_head_width * 6, avg_head_width * 6);
        
        minx = int32(min(rect_1(2, :)));
        maxx = int32(max(rect_1(2, :)));
        miny = int32(min(rect_1(1, :)));
        maxy = int32(max(rect_1(1, :)));
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
        clear img_small1;
        img_small1 = imcomplement(img(minx : maxx, miny : maxy));
%         figure, imshow(img_small1);
%         plot(rect_1(1, :), rect_1(2, :), 'b-', 'LineWidth', 1);
        
        meas{fr}.view{view_id}.nobj = meas{fr}.view{view_id}.nobj + 1;
        meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.head_pt = [midline_pts2(1, 1), midline_pts2(1, 2)];
        meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.ori = -ang1; 

        nose_pt(1, 1) = midline_pts2(1, 1) - 20 * cos(ang1);
        nose_pt(1, 2) = midline_pts2(1, 2) - 20 * sin(ang1);
        
        plot([nose_pt(1) midline_pts2(1, 1)], [nose_pt(2) midline_pts2(1, 2)], 'm-');
        [ht, wd] = size(img_small1);
        
        img_small1 = imrotate(img_small1, rad2deg(ang1), 'bilinear', 'crop');
        meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.head_img_ori = img_small1;
        
        ht_add = ht - CNN_sample_ht;
        wd_add = wd - CNN_sample_wd;
        if ht_add >= 0 && wd_add >= 0
            mid_ht = int32(ht / 2);
            mid_wd = int32(wd / 2);
            img_new = ones(CNN_sample_ht, CNN_sample_wd);
            if ht_add < 0
                if wd_add < 0
                    img_new(1 - int32(ht_add / 2) : ht - int32(ht_add / 2), 1 - int32(wd_add / 2) : wd - int32(wd_add / 2)) = img_small1;
                else
                    img_new(1 - int32(ht_add / 2) : ht - int32(ht_add / 2), :) = img_small1(:, 1 + int32(wd_add / 2) : int32(wd_add / 2) + CNN_sample_wd);
                end
            else
                if wd_add < 0
                    img_new(:, 1 - int32(wd_add / 2) : wd - int32(wd_add / 2)) = img_small1(1 + int32(ht_add / 2) : int32(ht_add / 2) + CNN_sample_ht, :);
                else
                    img_new(:, :) = img_small1(1 + int32(ht_add / 2) : int32(ht_add / 2) + CNN_sample_ht, 1 + int32(wd_add / 2) : int32(wd_add / 2) + CNN_sample_wd);
                end
            end

            if mean(img_new(:, 1)) > mean(img_new(:, end))
                img_new = imrotate(img_new, 180, 'bilinear', 'crop');
                meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.ori = meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.ori + pi;
                if meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.ori > 2 * pi
                    meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.ori = meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.ori - 2 * pi;
                end
            end

%             close all;
%             figure, imshow(img_new);

%             imwrite(img_small1, ['.\samples_10_big\big_', num2str(minidx), '_', num2str(fr / 2), '.bmp']);
            
            midline_pts2 = resample_equal(midline_pts2, nseg);
%             plot(midline_pts2(:, 1), midline_pts2(:, 2), 'r.','MarkerSize', 10);
            meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.midline = midline_pts2;
            for j = 2 : nseg
                meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.midline_ang(j) = acos(dot(midline_pts2(j + 1, :) - midline_pts2(j, :), midline_pts2(j, :) - midline_pts2(j - 1, :)) / (norm(midline_pts2(j + 1, :) - midline_pts2(j, :)) * norm(midline_pts2(j, :) - midline_pts2(j - 1, :))));
                if Cross_Product(midline_pts2(j - 1, 1), midline_pts2(j - 1, 2), midline_pts2(j + 1, 1), midline_pts2(j + 1, 2), midline_pts2(j, 1), midline_pts2(j, 2)) < 0
                    meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.midline_ang(j) = -meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.midline_ang(j);
                end
            end

            meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.midline_ang = real(meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.midline_ang);
            
            tp_mean = mean(img_new(:));
            img_new = (img_new - mean(img_new(:))) / std(img_new(:));
            idx = find(img_new >= mean(img_new(:)));
            img_new(idx) = tp_mean;
            img_new = img_new - min(img_new(:));
            img_new = img_new / max(img_new(:));
            meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.head_img_sample = img_new;
            blob_label = 0;
            for midi = 1 : 9
                blob_label = max(blob_label, img_bw_label(fix(midline_pts2(midi, 2)), fix(midline_pts2(midi, 1))));
            end
            if blob_label > 0
%                 blob_label
                fg(blob_label) = 1;
                meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.valid = 1;
                meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.blob_pts = img_bw.stats(blob_label).PixelList;
                boundary_pts = boundary{blob_label};
%                 plot(boundary_pts(:, 2), boundary_pts(:, 1), 'y.');
                dis_boundary_to_head = sqrt(sum((fliplr(boundary_pts) - repmat(nose_pt, length(boundary_pts), 1)).^2, 2));
                [min_val min_idx] = min(dis_boundary_to_head);
                meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.nose_pt = [boundary_pts(min_idx, 2) boundary_pts(min_idx, 1)];
% % %                 plot(meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.nose_pt(1), meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.nose_pt(2), 'c.');
% % %                 text(meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.nose_pt(1), meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.nose_pt(2), num2str(meas{fr}.view{view_id}.nobj), 'Color', 'b', 'FontSize', 20);
%                 text(meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.nose_pt(1), meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.nose_pt(2), num2str(blob_label), 'Color', 'b', 'FontSize', 20);
            else
                meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nobj}.valid = 0;
            end
%             for j = 1 : 10
%                 if mod(fr, 2) == 1
%                     tp = fr + 1;
%                 else
%                     tp = fr;
%                 end
%                 tp = tp / 2;
%                 dis(j) = sum((midline_pts2(1, :) - fish{j}.pts(tp, :)).^2);
%             end
%             [mindis, minidx] = min(dis);

            plot(midline_pts2(:, 1), midline_pts2(:, 2), 'g-', 'LineWidth', 1);
            plot(midline_pts2(1, 1), midline_pts2(1, 2), 'r.');
%             text(midline_pts2(1, 1), midline_pts2(1, 2), num2str(minidx), 'Color', 'm', 'FontSize', 20);
            
% % % %             ang_data{minidx}.midline_ang(fr / delta_frame, :) = meas{fr}.obj{meas{fr}.nobj}.midline_ang;
% % % %             ang_data{minidx}.ori(fr / delta_frame, :) = -ang1;
% % % %             if -ang1 > pi
% % % %                 ang_data{minidx}.ori(fr / delta_frame, :) = ang_data{minidx}.ori(fr / delta_frame, :) - 2 * pi;
% % % %             end
% % % %             if -ang1 < -pi
% % % %                 ang_data{minidx}.ori(fr / delta_frame, :) = ang_data{minidx}.ori(fr / delta_frame, :) + 2 * pi;
% % % %             end
% % % %                 
% % % %             ang_data{minidx}.midline{fr / delta_frame}.pt = midline_pts2;
% % % % %             midline_pts2 = resample_equal(midline_pts, 20);
% % % % 
% % % %             if fr > bg_frame && ang_data{minidx}.active == 1
% % % %                 ang_data{minidx}.vel(fr / delta_frame, :) = ang_data{minidx}.midline{fr / delta_frame}.pt(1, :) - ang_data{minidx}.midline{fr / delta_frame - 1}.pt(1, :);
% % % %                 ang_data{minidx}.vel_ang(fr / delta_frame, :) = atan2(ang_data{minidx}.midline{fr / delta_frame}.pt(1, 2) - ang_data{minidx}.midline{fr / delta_frame - 1}.pt(1, 2), ang_data{minidx}.midline{fr / delta_frame}.pt(1, 1) - ang_data{minidx}.midline{fr / delta_frame - 1}.pt(1, 1));
% % % %                 if fr > bg_frame + delta_frame
% % % %                     ang_data{minidx}.delta_vel_ang(fr / delta_frame, :) = ang_data{minidx}.vel_ang(fr / delta_frame, :) - ang_data{minidx}.vel_ang(fr / delta_frame - 1, :);
% % % %                     if ang_data{minidx}.delta_vel_ang(fr / delta_frame, :) > pi
% % % %                         ang_data{minidx}.delta_vel_ang(fr / delta_frame, :) = ang_data{minidx}.delta_vel_ang(fr / delta_frame, :) - 2 * pi;
% % % %                     end
% % % %                     if ang_data{minidx}.delta_vel_ang(fr / delta_frame, :) < -pi
% % % %                         ang_data{minidx}.delta_vel_ang(fr / delta_frame, :) = ang_data{minidx}.delta_vel_ang(fr / delta_frame, :) + 2 * pi;
% % % %                     end
% % % %                 end
% % % %                 ang_data{minidx}.delta_ori(fr / delta_frame, :) = ang_data{minidx}.ori(fr / delta_frame) - ang_data{minidx}.ori(fr / delta_frame - 1, :);
% % % %                 if ang_data{minidx}.delta_ori(fr / delta_frame, :) > pi
% % % %                     ang_data{minidx}.delta_ori(fr / delta_frame, :) = ang_data{minidx}.delta_ori(fr / delta_frame, :) - 2 * pi;
% % % %                 end
% % % %                 if ang_data{minidx}.delta_ori(fr / delta_frame, :) < -pi
% % % %                     ang_data{minidx}.delta_ori(fr / delta_frame, :) = ang_data{minidx}.delta_ori(fr / delta_frame, :) + 2 * pi;
% % % %                 end
% % % %                 ang_data{minidx}.delta_midline_ang(fr / delta_frame, :) = ang_data{minidx}.midline_ang(fr / delta_frame, :) - ang_data{minidx}.midline_ang(fr / delta_frame - 1, :);
% % % %                 for j = 2 : nseg
% % % %                     if ang_data{minidx}.delta_midline_ang(fr / delta_frame, j) > pi
% % % %                         ang_data{minidx}.delta_midline_ang(fr / delta_frame, j) = ang_data{minidx}.delta_midline_ang(fr / delta_frame, j) - 2 * pi;
% % % %                     end
% % % %                     if ang_data{minidx}.delta_midline_ang(fr / delta_frame, j) < -pi
% % % %                         ang_data{minidx}.delta_midline_ang(fr / delta_frame, j) = ang_data{minidx}.delta_midline_ang(fr / delta_frame, j) + 2 * pi;
% % % %                     end
% % % %                 end
% % % %             
% % % %             end
% % % %             ang_data_fg(minidx) = 1;
%             close all;
        end

    end
end

no_midline_idx = find(fg == 0);
meas{fr}.view{view_id}.nblob = meas{fr}.view{view_id}.nobj;
for i = 1 : length(no_midline_idx)
    meas{fr}.view{view_id}.nblob = meas{fr}.view{view_id}.nblob + 1;
    meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.head_pt = img_bw.stats(no_midline_idx(i)).Centroid;
    meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.nose_pt = meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.head_pt;
    meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.valid = 1;
    meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.blob_pts = img_bw.stats(no_midline_idx(i)).PixelList;
% % %     plot(meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.nose_pt(1), meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.nose_pt(2), 'c.');
% % %     text(meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.blob_pts(1, 1), meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.blob_pts(1, 2), num2str(meas{fr}.view{view_id}.nblob), 'Color', 'b', 'FontSize', 20);
%     text(meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.blob_pts(1, 1), meas{fr}.view{view_id}.obj{meas{fr}.view{view_id}.nblob}.blob_pts(1, 2), num2str(no_midline_idx(i)), 'Color', 'b', 'FontSize', 20);
end

end