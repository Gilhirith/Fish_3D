function midline_ordered = Midline_Reorder(midline_disorder)

global joint_pts_tol;

for i = 1 : size(midline_disorder, 1)
   midline_dis(i, :) = (sqrt(sum((repmat(midline_disorder(i, :), size(midline_disorder, 1), 1) - midline_disorder).^2, 2)))';
   midline_joint_dis(i, :) = (sqrt(sum((repmat(midline_disorder(i, :), size(joint_pts_tol, 1), 1) - joint_pts_tol).^2, 2)))';
end

midline_idx = [];
fg = zeros(size(midline_disorder, 1), 1);
fg(1) = 1;
for i = 1 : size(midline_disorder, 1)
    tx = midline_disorder(i, 1);
    ty = midline_disorder(i, 2);
    cnt = find(midline_dis(i, :) < 2);
    if length(cnt) < 3
        break;
    end
end

cnt = 0;
clear midline_ordered;
pre = i;
fg = zeros(size(midline_disorder, 1), 1);
fg(i) = 1;
midline_ordered(1, :) = midline_disorder(i, :);
cnt = cnt + 1;
while cnt < size(midline_disorder, 1)
    vis_id = find(fg == 1);
    midline_dis(i, vis_id) = Inf;
    [minval, minidx] = min(midline_dis(i, :));
    [minval_joint, minidx_joint] = min(midline_joint_dis(i, :));
    minnum = find(midline_dis(i, :) <= 1);
    if minval > 3 || length(minidx) > 2 || length(minnum) > 1
        break;
    end
%     if minval_joint < minval
%         if cnt > size(midline_disorder, 1) * 0.2
%             break;
%         else
%             cnt = 0;
%             midline_ordered = [];
%         end
%     end
    for k = 1 : length(minidx)
        if fg(minidx(k)) == 0
            pre = i;
            i = minidx(k);
            fg(minidx(k)) = 1;
            break;
        end
    end 
    cnt = cnt + 1;
    midline_ordered(end + 1, :) = midline_disorder(i, :);
                    plot(midline_disorder(i, 1), midline_disorder(i,2), 'b-');
end


end