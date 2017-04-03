function tracking_CNN

    global cnn;
    global meas;
    global img1;
    global trajs;
    
    sample_ht = 48;
    sample_wd = 48;
    
    cor = 0;
    err = 0;
    
    for fr = 734 : 2000
        fr
        img = im2double(imread(['E:/FtpRoot/Dataset/20160617/27_Stone/CoreView_340_Flare_4M180_NCL_(2)_', sprintf('%05d', fr), '.bmp']));
        [WD, HT] = size(img);
        figure, imshow(img);
        hold on;
            
        train_x = [];
        
        fg = zeros(length(meas{fr}.view{1}.obj), 1);
        for fish = 1 : length(meas{fr}.view{1}.obj)
            
            pos = fliplr(meas{fr}.view{1}.obj{fish}.head_pt(1 : 2));

            xc = pos(1, 1);
            yc = pos(1, 2);

            phi = meas{fr}.view{1}.obj{fish}.phi;

            rect = Get_Head_Rect(xc, yc, -phi, 180, 180);
            plot(rect(1, :), rect(2, :), 'c-', 'LineWidth', 2);
            minx = int32(min(rect(2, :)));
            maxx = int32(max(rect(2, :)));
            miny = int32(min(rect(1, :)));
            maxy = int32(max(rect(1, :)));
            if minx < 1 || maxx > WD || miny < 1 || maxy > HT
                fg(fish) = 1;
                continue;
            end
            img_small = img(minx : maxx, miny : maxy);

            img_rot = imrotate(img_small, rad2deg(-phi), 'bilinear', 'crop');

%             imwrite(img_rot, ['./raw_samples_CV340/fish_sample_CV340_', num2str(fish), '_', num2str(fix((fr + 1) / 2)), '.bmp']);
%             close all;

            [ht, wd] = size(img_rot);
            ht_add = ht - sample_ht;
            wd_add = wd - sample_wd;

            img_new = ones(sample_ht, sample_wd);
            if ht_add < 0
                if wd_add < 0
                    img_new(1 - int32(ht_add / 2) : ht - int32(ht_add / 2), 1 - int32(wd_add / 2) : wd - int32(wd_add / 2)) = img_rot;
                else
                    img_new(1 - int32(ht_add / 2) : ht - int32(ht_add / 2), :) = img_rot(:, 1 + int32(wd_add / 2) : int32(wd_add / 2) + sample_wd);
                end
            else
                if wd_add < 0
                    img_new(:, 1 - int32(wd_add / 2) : wd - int32(wd_add / 2)) = img_rot(1 + int32(ht_add / 2) : int32(ht_add / 2) + sample_ht, :);
                else
                    img_new(:, :) = img_rot(1 + int32(ht_add / 2) : int32(ht_add / 2) + sample_ht, 1 + int32(wd_add / 2) : int32(wd_add / 2) + sample_wd);
                end
            end

            if mean(img_new(:, 1)) > mean(img_new(:, end))
                img_new = imrotate(img_new, 180, 'bilinear', 'crop');
            end
            
            

            res = imcomplement(imcomplement(img1) .* imcomplement(img_new));
%                 figure, imshow(res);


            res = res - min(res(:));
            res = res / max(res(:));
%                 figure, imshow(res);


            tp_mean = mean(res(:));
            res = (res - mean(res(:))) / std(res(:));
%             figure, imshow(res);
            img_bw = imcomplement(im2bw(res, 0.5));

            img_bw_label = bwlabel(img_bw);
            stats = imfeature(img_bw_label, 'all');

            areas = [stats.Area];
            index_areas = find(areas == max(areas));
            img_bw2 = ismember(img_bw_label, index_areas);

            idx1 = find(img_bw == 1);
            idx2 = find(img_bw2 == 1);
            idx_noise = setdiff(idx1, idx2);

            idx = find(res >= mean(res(:)) + 0.2);
            res(idx) = tp_mean;
            res(idx_noise) = tp_mean;
            res = res - min(res(:));
            res = res / max(res(:));
                
%             figure, imshow(res);
            
            train_x(end + 1, :) = res(:);
            
        end
        train_x = double(reshape(train_x', sample_wd, sample_ht, size(train_x, 1)));
        net = cnnff(cnn, train_x);
        [~, h] = max(net.o);
        
        k = 1;
        for fish = 1 : length(meas{fr}.view{1}.obj)
            if fg(fish) == 1
                continue;
            end
           plot(meas{fr}.view{1}.obj{fish}.head_pt(2), meas{fr}.view{1}.obj{fish}.head_pt(1), 'r.');
           text(meas{fr}.view{1}.obj{fish}.head_pt(2), meas{fr}.view{1}.obj{fish}.head_pt(1), num2str(h(k)), 'Color', 'b', 'FontSize', 20);
           k = k + 1;
        end
        
        saveas(gcf, ['res_CNN_340/fr_', num2str(fr), '.jpg']);
        hold off;
        close all;
        
%         if mod(fr, 2) == 1
%             for i = 1 : length(meas{fr}.view{1}.obj)
%                 if norm(trajs{h(i)}.traj{fr}.head_pt(1 : 2) - meas{fr}.view{1}.obj{i}.head_pt(1 : 2)) < 50
%                     cor = cor + 1;
%                 else
%                     err = err + 1;
%                 end
%                 
%             end
%         end
    end
    
    err
    cor
end