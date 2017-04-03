function Cal_Camera_Para()

global img_ori_S1;
global img_ori_M;
global img_ori_S2;
global F_matrix;
global Cam_Para;

addpath(genpath('D:/Uriel/TOOLBOX_calib/'));


% fr = 4851;
% 
% img_ori_M = im2double(imread(['E:/FtpRoot/Dataset/CoreView_213/', 'CoreView_213_Master_Camera_', sprintf('%05d', fr), '.bmp']));
% img_ori_S1 = im2double(imread(['E:/FtpRoot/Dataset/CoreView_213/', 'CoreView_213_Slave1_Camera_', sprintf('%05d', fr), '.bmp']));
% img_ori_S2 = im2double(imread(['E:/FtpRoot/Dataset/CoreView_213/', 'CoreView_213_Slave2_Camera_', sprintf('%05d', fr), '.bmp']));

% figure, imshow(img_ori_M);
% hold on;
% figure, imshow(img_ori_S1);
% figure, imshow(img_ori_S2);
fc_left = [ 6531.17204   6498.73361 ];
cc_left = [ 816.34605   847.43732 ];
alpha_c_left = [ 0.00000 ];
kc_left = [ 0.15667   -7.27311   -0.02792   0.00267  0.00000 ];
KK_M = [fc_left(1), alpha_c_left * fc_left(1), cc_left(1); 0, fc_left(2), cc_left(2); 0, 0, 1];

fc_right = [ 6408.00463   6564.31765 ];
cc_right = [ 594.81024   1011.88275 ];
alpha_c_right = [ 0.00000 ];
kc_right = [ 0.05866   0.63860   0.00481   -0.01736  0.00000 ];
KK_S1 = [fc_right(1), alpha_c_right * fc_right(1), cc_right(1); 0, fc_right(2), cc_right(2); 0, 0, 1];

% Master
Cam_Para{1}.fc = fc_left;
Cam_Para{1}.cc = cc_left;
Cam_Para{1}.alpha_c = alpha_c_left;
Cam_Para{1}.kc = kc_left;
Cam_Para{1}.KK = KK_M;

% Slave1
Cam_Para{2}.fc = fc_right;
Cam_Para{2}.cc = cc_right;
Cam_Para{2}.alpha_c = alpha_c_right;
Cam_Para{2}.kc = kc_right;
Cam_Para{2}.KK = KK_S1;

% M X S1
om_M_S1 = [ -0.20458   -2.18689  -2.10014 ];
T_M_S1 = [ 727.29681   -7972.81881  9308.51564 ];

F_matrix{1}.F = Cal_Fundermental_Matrix(fc_left, cc_left, alpha_c_left, fc_right, cc_right, alpha_c_right, om_M_S1, T_M_S1);
F_matrix{1}.om = om_M_S1;
F_matrix{1}.T = T_M_S1;

fc_right = [ 6341.32788   6463.15242 ];
cc_right = [ 592.85286   1197.72907 ];
alpha_c_right = [ 0.00000 ];
kc_right = [ 0.14542   -2.56116   0.00746   -0.02330  0.00000 ];
KK_S2 = [fc_right(1), alpha_c_right * fc_right(1), cc_right(1); 0, fc_right(2), cc_right(2); 0, 0, 1];

% M X S2
om_M_S2 = [ -1.27501   -1.15107  -1.06142 ];
T_M_S2 = [ 757.84022   -8058.18916  9360.78271 ];

% Slave2
Cam_Para{3}.fc = fc_right;
Cam_Para{3}.cc = cc_right;
Cam_Para{3}.alpha_c = alpha_c_right;
Cam_Para{3}.kc = kc_right;
Cam_Para{3}.KK = KK_S2;

F_matrix{2}.F = Cal_Fundermental_Matrix(fc_left, cc_left, alpha_c_left, fc_right, cc_right, alpha_c_right, om_M_S2, T_M_S2);
F_matrix{2}.om = om_M_S2;
F_matrix{2}.T = T_M_S2;

% % % test S1 X S2
% % inaccurate
% % fc_left = [ 6404.79410150265 6378.28656636883 ];
% % cc_left = [ 569.504909220689 1006.02637361565 ];
% % alpha_c_left = [ 0.00000 ];
% % kc_left = [ -0.0781617291320467 1.27095807516352 0.00896313625143325 -0.00977881685361113 0 ];
% % 
% % fc_right = [ 6457.38316594136 6468.64178888438 ];
% % cc_right = [ 1061.83077345038 928.720394376929 ];
% % alpha_c_right = [ 0.00000 ];
% % kc_right = [ 0.00337005610885815 3.27830605646774 0.00261275235632639 -0.00477799884957491 0 ];
% % 
% % om_S1_S2 = [ -0.0420653488884417 1.41052364736745 -0.0258701815903775 ];
% % T_S1_S2 = [ -9598.49730439660 14.7607006738545 8558.50822313743 ];

% S1 X S2
% accurate
fc_left = [ 6482.99875   6489.61975 ];
cc_left = [ 1019.50000   1023.50000 ];
alpha_c_left = [ 0.00000 ];
kc_left = [ 0.06156   4.40339   0.00965   0.01636  0.00000 ];

fc_right = [ 6344.69883   6395.28118 ];
cc_right = [ 1019.50000   1023.50000 ];
alpha_c_right = [ 0.00000 ];
kc_right = [ 0.13000   -0.70324   -0.00692   0.00607  0.00000 ];

om_S1_S2 = [ -0.04322   1.55557  -0.03821 ];
T_S1_S2 = [ -9204.60809   151.57563  9194.06484 ];

F_matrix{3}.F = Cal_Fundermental_Matrix(fc_left, cc_left, alpha_c_left, fc_right, cc_right, alpha_c_right, om_S1_S2, T_S1_S2);
F_matrix{3}.om = om_S1_S2;
F_matrix{3}.T = T_S1_S2;

% matchedPoints1 = [1225, 1225; 841, 608; 383, 772; 749, 1341; 820, 767; 1049, 1133; 766, 1208; 543, 860; 791, 624; 898, 892; 600, 692; 1092, 1542; 1607, 1547; 713, 1285; 1150, 1106; 1031, 1785; 1044, 1791; 1101, 1717; 1869, 224; 349, 459];
% matchedPoints2 = [1184, 1218; 659, 1055; 756, 1616; 1307, 1755; 788, 1195; 1106, 1290; 1177, 1615; 850, 1529; 668, 1108; 897, 1228; 706, 1328; 1476, 1784; 1437, 1711; 1255, 1742; 1084, 1187; 1708, 1775; 1718, 1769; 1638, 1741; 270, 1706; 380, 1971];

% % % for CV_213 M X S1
% points_M = [478, 321; 889, 384; 1810, 1065; 603, 1545; 86, 814; 106, 1184; 254, 866; 1355, 792; 1243, 202; 964, 193];
% points_S1 = [1605, 1508; 1183, 1745; 350, 1688; 1493, 1618; 1986, 1511; 1936, 1412; 1808, 1387; 765, 1449; 818, 1486; 1100, 1621];
% 
% F_matrix{1}.F = estimateFundamentalMatrix(points_M', points_S1','Method','Norm8Point');
% 
% % % for CV_213 M X S2
% points_M = [391, 1679; 1716, 1955; 264, 1485; 615, 1447; 421, 959; 953, 789; 368, 195; 746, 338; 738, 1281; 543, 732];
% points_S2 = [1768, 1855; 1907, 1462; 1542, 1614; 1511, 1678; 1008, 1608; 884, 1666; 239, 1714; 452, 1540; 1330, 1345; 810, 1283];
% 
% F_matrix{2}.F = estimateFundamentalMatrix(points_M', points_S2','Method','Norm8Point');


% % % % % % I1 = imread('CoreView_55_S_1.bmp');
% % % % % figure, imshow(img_ori_M);
% % % % % hold on;
% % % % % 
% % % % % % points = [96, 498; 584, 325; 804, 108; 1074, 526; 1389, 400; 1916, 928];
% % % % % plot(points_M(:, 1), points_M(:, 2), 'b.');
% % % % % points_e = points_M(:, 1 : 2)';
% % % % % % points_e = flipud(points_e);
% % % % % figure, imshow(img_ori_S2);
% % % % % hold on;
% % % % % epiLines = epipolarLine(F_matrix{2}.F, points_e);
% % % % % epi_pts = lineToBorderPoints(epiLines, size(img_ori_S2))';
% % % % % % plot(xl(1, :), xl(2, :), 'r.');
% % % % % line(epi_pts(:, [1,3])', epi_pts(:, [2,4])');
% % % % % 
% % % % % tic;

% % test S1 X S2 bi-direction
% figure, imshow(img_ori_S1);
% hold on;
% points_e1 = [727.8 1502; 756 1648; 1357 1818; 1456 1743; 946 1647; 1606 1475; 1789 1633]';
% points_e2 = [356 1864; 266 1706; 512 1567; 557 1571; 587 1858; 850 1528; 755 1850; 905 1776; 857 1735; 847 1528]';
% % points_e2 = [281 1706; 599 1853; 575 1571; 863 1523; 770 1850; 869 1733]';
% % points_e2 = [283 1756; 467 1660; 553 1798; 867 1635; 990 1751; 1013 1784; 1115 1794; 1487 1731; 1031 1404; 1276, 1496]';
% % points_e2 = flipud(points_e2);
% epiLines = epipolarLine(F', points_e2);
% epi_pts = lineToBorderPoints(epiLines, size(img_ori_S1))';
% % plot(matchedPoints2(:, 1), matchedPoints2(:, 2), 'r.');
% % plot(xl(1, :), xl(2, :), 'r.');
% line(epi_pts(:, [1,3])', epi_pts(:, [2,4])');
% plot(points_e1(1, :), points_e1(2, :), 'r.');
% 
% figure, imshow(img_ori_S2);
% hold on;
% epiLines = epipolarLine(F, points_e1);
% epi_pts = lineToBorderPoints(epiLines, size(img_ori_S2))';
% line(epi_pts(:, [1,3])', epi_pts(:, [2,4])');
% plot(points_e2(1, :), points_e2(2, :), 'r.');

% % % % pt_M = [79 211];
% % % % 
% % % % % plot(pt_M(1), pt_M(2), 'r.');
% % % % pt_S1 = [1973 1563];
% % % % pt_S2 = [171 1642];
% % % % 
% % % % figure, imshow(img_ori_S2);
% % % % hold on;
% % % % plot(pt_S2(1), pt_S2(2), 'b.');
% % % % % [XL, XR] = stereo_triangulation(pt_M', pt_S1', F_matrix{1}.om, F_matrix{1}.T', Cam_Para{1}.fc, Cam_Para{1}.cc, Cam_Para{1}.kc, Cam_Para{1}.alpha_c, Cam_Para{2}.fc, Cam_Para{2}.cc, Cam_Para{2}.kc, Cam_Para{2}.alpha_c);
% % % % % plot3(XL(1), XL(2), XL(3), 'r.');
% % % % [XL, XR] = stereo_triangulation(pt_M', pt_S2', F_matrix{2}.om, F_matrix{2}.T', Cam_Para{1}.fc, Cam_Para{1}.cc, Cam_Para{1}.kc, Cam_Para{1}.alpha_c, Cam_Para{3}.fc, Cam_Para{3}.cc, Cam_Para{3}.kc, Cam_Para{3}.alpha_c);
% % % % % plot3(XL(1), XL(2), XL(3), 'r.');
% % % % XR2 = Translate_to_Right_View(XL, F_matrix{2}.om, F_matrix{2}.T);
% % % % Xp = Reproject_to_2D(XR2, Cam_Para{3}.kc, Cam_Para{3}.fc, Cam_Para{3}.cc, Cam_Para{3}.alpha_c);
% % % % plot(Xp(1, :), Xp(2, :), 'r.');
% % % % % text(Xp(1, :), Xp(2, :), num2str(obj), 'Color', 'b', 'FontSize',
% 25);





% % % close all;
% % % img_path = 'E:/FtpRoot/Dataset/CoreView_217/';
% % % img_ori_M = im2double(imread([img_path, 'CoreView_217_Master_Camera_', sprintf('%05d', 347), '.bmp']));
% % % figure, imshow(img_ori_M);
% % % hold on;
% % % pt_M = [1042; 463];
% % % epiLines = epipolarLine(F_matrix{1}.F, pt_M);
% % % img_ori_S1 = im2double(imread([img_path, 'CoreView_217_Slave1_Camera_', sprintf('%05d', 347), '.bmp']));
% % % figure, imshow(img_ori_S1);
% % % hold on;
% % % epi_pts = lineToBorderPoints(epiLines, size(img_ori_S1))';
% % % line(epi_pts(:, [1,3])', epi_pts(:, [2,4])');
% % % 
% % % epiLines = epipolarLine(F_matrix{2}.F, pt_M);
% % % img_ori_S2 = im2double(imread([img_path, 'CoreView_217_Slave2_Camera_', sprintf('%05d', 347), '.bmp']));
% % % figure, imshow(img_ori_S2);
% % % hold on;
% % % epi_pts = lineToBorderPoints(epiLines, size(img_ori_S2))';
% % % line(epi_pts(:, [1,3])', epi_pts(:, [2,4])');




end
