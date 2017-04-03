function Reconstruction()

global trajs_3d;
global match_idx_s1;
global match_idx_s2;

for obj = 1 : 
[XL,XR] = stereo_triangulation(xr(:, 1), xl(:, 1), om, T', fc_left, cc_left, kc_left, alpha_c_left, fc_right, cc_right, kc_right, alpha_c_right);


end