function cst_mtx = cal_cst_mtx(fr, pts)

global meas;
global delta_frame;
global search_radius;
% search_radius = 50;
n_meas = meas{fr}.view{1}.nobj;
n_obj = size(pts, 1);

cst_mtx = Inf * ones(n_obj, n_meas);

for i = 1 : n_obj
    for j = 1 : n_meas
%         rect = Get_Head_Rect(yc, xc,  -phi, 5.5 * a, 5 * b);
%         cst_mtx = image_similarity();
        dis = sqrt(sum((pts(i, 1 : 2) - meas{fr}.view{1}.obj{j}.head_pt(1 : 2)).^2, 2));
        if dis < search_radius
            cst_mtx(i, j) = dis;
        end
    end
end

end
