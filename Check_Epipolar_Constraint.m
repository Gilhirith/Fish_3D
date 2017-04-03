function ok = Check_Epipolar_Constraint(pt, img_bw)

global F_matrix;
global Cam_Para;
global patch_size;

patch_size = 51;

[img_height, img_width] = size(img_bw);

x_l = max(1, pt(1) - fix(patch_size / 2));
y_l = max(1, pt(2) - fix(patch_size / 2));

if x_l + patch_size - 1 > img_height
    x_l = img_height - patch_size + 1;
end

if y_l + patch_size - 1 > img_width
    y_l = img_width - patch_size + 1;
end

img_patch = img_bw(x_l : x_l + patch_size - 1, y_l : y_l + patch_size - 1);
% figure, imshow(img_patch);

if mean(double(img_patch)) > 0.3
    ok = 1;
else
    ok = 0;
end

end