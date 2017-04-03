function points = DoH(img, img_bw, img_bw_label, boundary)

    global sample_ht;
    global sample_wd;
    global sigma_array;
    global nfish;
    global img_height;
    global img_width;
    global fr;
    global meas;
    
    % LoG paras
    sigma_begin = 1;
    sigma_end = 15;
    sigma_step = 1;
    sigma_array = sigma_begin : sigma_step : sigma_end;
    sigma_nb = numel(sigma_array);
    min_neighbor_dis = 35;

    % Multi Scale DoH
    snlo = zeros(img_height, img_width, sigma_nb);
    for i = 1 : sigma_nb
        sigma = sigma_array(i);
        w = 3 * sigma;
        [x y] = meshgrid(-w : w, -w : w);
        sigma2 = sigma^2;
        temp =exp(-(x.^2 + y.^2) / (2 * sigma2)) / (2 * pi * sigma2);
        mxx = temp .* (x.^2 / sigma2 - 1);
        myy = temp .* (y.^2 / sigma2 - 1);
        mxy = temp .* (x.*y / sigma2);

        dxx = imfilter(img, mxx, 'replicate');
        dyy = imfilter(img, myy, 'replicate');
        dxy = imfilter(img, mxy, 'replicate');

        snlo(:, :, i) = dxx .* dyy - dxy .^ 2;
    end

    % Find Local Maximum
    snlo_dil = imdilate(snlo, ones(3, 3, 3));
    blob_candidate_index = find(snlo == snlo_dil);
    blob_candidate_value = snlo(blob_candidate_index);
    [~, index] = sort(blob_candidate_value, 'descend');

    cnt = 1;
    k = 2;
    blob_index = blob_candidate_index(index(1));
    [lig, col, sca] = ind2sub([img_height, img_width, sigma_nb], blob_index);
    pts = [lig, col, sigma_array(sca)];
    clear head_label;
    while cnt < nfish
        blob_index = blob_candidate_index(index(k));
        k = k + 1;
        [lig, col, sca] = ind2sub([img_height, img_width, sigma_nb], blob_index);
        pt = [lig, col, sigma_array(sca)];
        dis = sum(sqrt((repmat(pt, size(pts, 1), 1) - pts).^2), 2);
        
        xc = pt(1);
        yc = pt(2);
        sigma = pt(3);
        w = 3 * sigma;
        [x y] = meshgrid(-w : w, -w : w);
        sigma2 = sigma^2;
        temp = exp(-(x.^2 + y.^2) / (2 * sigma2)) / (2 * pi * sigma2);
        mxx = temp .* (x .^ 2 / sigma2 - 1);
        myy = temp .* (y .^2 / sigma2 - 1);
        mxy = temp .* (x .* y / sigma2);

        dxx = imfilter(img, mxx, 'replicate');
        dyy = imfilter(img, myy, 'replicate');
        dxy = imfilter(img, mxy, 'replicate');

        [V, D] = eig([dxx(xc, yc), dxy(xc, yc); dxy(xc, yc), dyy(xc, yc)]);
        r = D(1, 1) / D(2, 2);
        
        if min(dis) > min_neighbor_dis && pt(3) >= 8 && r < 3
            pts(end + 1, :) = pt;
            cnt = cnt + 1;
        end
    end

    img_bw.stats = imfeature(img_bw_label, 'all');
        
    k = 1;
    meas{fr}.view{1}.nobj = 0;
    for i = 1 : size(pts, 1)
        xc = pts(i, 1);
        yc = pts(i, 2);

        sigma = pts(i, 3);
        w = 3 * sigma;
        [x y] = meshgrid(-w : w, -w : w);
        sigma2 = sigma^2;
        temp = exp(-(x.^2 + y.^2) / (2 * sigma2)) / (2 * pi * sigma2);
        mxx = temp .* (x .^ 2 / sigma2 - 1);
        myy = temp .* (y .^2 / sigma2 - 1);
        mxy = temp .* (x .* y / sigma2);

        dxx = imfilter(img, mxx, 'replicate');
        dyy = imfilter(img, myy, 'replicate');
        dxy = imfilter(img, mxy, 'replicate');

        [V, D] = eig([dxx(xc, yc), dxy(xc, yc); dxy(xc, yc), dyy(xc, yc)]);
        r = D(1, 1) / D(2, 2);
        phi = atan2(V(1, 1), V(2, 1));
        a = sigma / sqrt(r);
        b = r * a;
        rect = Get_Head_Rect(yc, xc,  -phi, 5.5 * a, 5 * b);

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
        img_small = imcomplement(img(minx : maxx, miny : maxy));
        img_rotated = imrotate(img_small, rad2deg(-phi), 'bilinear', 'crop');
        img_new = ones(48, 48);
        [ht, wd] = size(img_rotated);
        ht_add = ht - 48;
        wd_add = wd - 48;
        if ht_add < 0
            if wd_add < 0
                img_new(1 - int32(ht_add / 2) : ht - int32(ht_add / 2), 1 - int32(wd_add / 2) : wd - int32(wd_add / 2)) = img_rotated;
            else
                img_new(1 - int32(ht_add / 2) : ht - int32(ht_add / 2), :) = img_rotated(:, 1 + int32(wd_add / 2) : int32(wd_add / 2) + sample_wd);
            end
        else
            if wd_add < 0
                img_new(:, 1 - int32(wd_add / 2) : wd - int32(wd_add / 2)) = img_rotated(1 + int32(ht_add / 2) : int32(ht_add / 2) + sample_ht, :);
            else
                img_new(:, :) = img_rotated(1 + int32(ht_add / 2) : int32(ht_add / 2) + sample_ht, 1 + int32(wd_add / 2) : int32(wd_add / 2) + sample_wd);
            end
        end
        
        if mean(img_new(:, 1)) > mean(img_new(:, end))
            img_new = imrotate(img_new, 180, 'bilinear', 'crop');
            phi = phi + pi;
        end
        meas{fr}.view{1}.obj{k}.img_rotated = img_new;
        
% %         if size(img_small, 1) >= sample_wd && size(img_small, 2) >= sample_ht
        meas{fr}.view{1}.nobj = meas{fr}.view{1}.nobj + 1;
        meas{fr}.view{1}.obj{k}.img = imrotate(img_small, rad2deg(-phi), 'bilinear', 'crop');
        meas{fr}.view{1}.obj{k}.phi = phi;
        meas{fr}.view{1}.obj{k}.a = a;
        meas{fr}.view{1}.obj{k}.b = b;
        meas{fr}.view{1}.obj{k}.head_pt = pts(i, :);
        plot(pts(i, 2), pts(i, 1), 'g.');
        nose_pt(1, 1) = pts(i, 2) + 25 * cos(-phi);
        nose_pt(1, 2) = pts(i, 1) + 25 * sin(-phi);
        
% % % % % %         plot([nose_pt(1) pts(i, 2)], [nose_pt(2) pts(i, 1)], 'm-');
        
        blob_label = img_bw_label(fix(pts(i, 1)), fix(pts(i, 2)));
        if blob_label > 0
            boundary_pts = boundary{blob_label};
%                 plot(boundary_pts(:, 2), boundary_pts(:, 1), 'y.');
            dis_boundary_to_head = sqrt(sum((fliplr(boundary_pts) - repmat(nose_pt, length(boundary_pts), 1)).^2, 2));
            [min_val min_idx] = min(dis_boundary_to_head);
            meas{fr}.view{1}.obj{k}.nose_pt = [boundary_pts(min_idx, 2) boundary_pts(min_idx, 1)];
% % % % % %             plot(meas{fr}.view{1}.obj{k}.nose_pt(1), meas{fr}.view{1}.obj{k}.nose_pt(2), 'c.');
            meas{fr}.view{1}.obj{k}.blob_pts = img_bw.stats(blob_label).PixelList;
            meas{fr}.view{1}.obj{k}.boundary_pts = boundary_pts;
        end
        
        points(k, :) = [pts(i, :), phi];
        meas{fr}.view{1}.obj{k}.head_label = img_bw_label(int32(xc), int32(yc));
        k = k + 1;
% %         end
        ellipsedraw(1.5 * a, 1.5 * b, yc, xc, pi / 2 - phi);

    %     axesm mercator
%         ecc = axes2ecc(a, b);
%         [elat,elon] = ellipse1(0,0,[a axes2ecc(a, b)], phi);
    %     plotm(elat,elon,'m--')
    end
end