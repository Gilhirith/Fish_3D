% function plot_traj()
close all;

global bg_frame;
global ed_frame;
global delta_frame;
global trajs;

bg_frame = 4500;
ed_frame = 6500;
delta_frame = 1;
search_radius = 50;

% load connected_trajs_CV217_2122-4121_radius50;
% load raw_trajs_CV217_2122-4121_radius50;

% load connected_trajs_CV217_2122-4121_vel40;


% % load manual_relinked_CV217_2122-4121;

% load('manual_relinked_CV213_4500-6500.mat');
% load('raw_trajs_CV217_325-865.mat');
% load('raw_trajs_CV217_61-2060.mat');


% rng(0);
% col = colormap(hsv(40));
% r = randperm(size(col, 1));
% col = col(r, :);
    
% figure;
% hold on;
% grid on;
% view(-20, 10);

% for i = 1 : 10
%     for j = 4500 : 6500
%         plot3(2000 - [trajs{trajs{i}.relink(j)}.traj{k}.pt(2), trajs{trajs{i}.relink(j)}.traj{k - 1}.pt(2)], 2000-[trajs{trajs{i}.relink(j)}.traj{k}.pt(1), trajs{trajs{i}.relink(j)}.traj{k - 1}.pt(1)], [trajs{trajs{i}.relink(j)}.bg_frame + k, trajs{trajs{i}.relink(j)}.bg_frame + k - 1] - 9549, '-', 'Color', col(tp, :), 'LineWidth', 1);
%     end
% end

% for i = 172 : delta_frame : 381
%     img = im2double(imread(['../Fish_2D_CNN/CoreView_54/CoreView_54_Master_Camera_', sprintf('%05d', i), '.bmp']));
%     figure, imshow(img);
%     hold on;
%     set(gcf,'outerposition',get(0,'screensize'));
%     [x(1), x(2)] = ginput;
%     trajs{18}.traj{i}.pt = [x(1) x(2)];
%     close all;
% end

% % load('raw_trajs_CV241_222-2221_150918.mat');
% % 
% % for j = 1 : length(trajs)
% %     trajs{j}.ed_frame = trajs{j}.bg_frame + length(trajs{j}.traj);
% %     for fr = length(trajs{j}.traj) + 1 : 300
% %         trajs{j}.traj{fr}.pt = [0 0];
% %     end
% % end
% % 
% % for i = 263 : 269
% %     trajs{3}.traj{i - 221}.pt = trajs{70}.traj{i - 262}.pt;
% % end
% % for i = 270 : 521
% %     trajs{3}.traj{i - 221}.pt = trajs{74}.traj{i - 268}.pt;
% % end
% % 
% % for i = 308 : 323
% %    trajs{4}.traj{i - 221}.pt = trajs{111}.traj{i - 307}.pt;
% % end
% % trajs{4}.traj{324 - 221}.pt = trajs{35}.traj{324 - 221}.pt;
% % trajs{4}.traj{325 - 221}.pt = trajs{35}.traj{325 - 221}.pt;
% % trajs{4}.traj{326 - 221}.pt = [418, 1461];
% % trajs{4}.traj{327 - 221}.pt = [420, 1463];
% % trajs{4}.traj{328 - 221}.pt = [422, 1465];
% % trajs{4}.traj{329 - 221}.pt = [425, 1466];
% % for i = 330 : 413
% %    trajs{4}.traj{i - 221}.pt = trajs{132}.traj{i - 329}.pt;
% % end
% % trajs{4}.traj{414 - 221}.pt = [575, 1485];
% % trajs{4}.traj{415 - 221}.pt = [575, 1482];
% % trajs{4}.traj{416 - 221}.pt = [575, 1483];
% % trajs{4}.traj{417 - 221}.pt = [578, 1482];
% % trajs{4}.traj{418 - 221}.pt = [577, 1481];
% % trajs{4}.traj{419 - 221}.pt = [579, 1479];
% % trajs{4}.traj{420 - 221}.pt = [578, 1479];
% % for i = 421 : 521
% %    trajs{4}.traj{i - 221}.pt = trajs{170}.traj{i - 420}.pt;
% % end
% % 
% % trajs{10}.traj{442 - 221}.pt = trajs{20}.traj{442 - 221}.pt;
% % for i = 443 : 521
% %    trajs{10}.traj{i - 221}.pt = trajs{176}.traj{i - 442}.pt;
% % end
% % 
% % for i = 337 : 341
% %    trajs{11}.traj{i - 221}.pt = trajs{20}.traj{i - 221}.pt;
% % end
% % for i = 342 : 521
% %    trajs{11}.traj{i - 221}.pt = trajs{139}.traj{i - 341}.pt;
% % end
% % 
% % for i = 330 : 521
% %     trajs{16}.traj{i - 221}.pt = trajs{13}.traj{i - 221}.pt;
% % end
% % 
% % for i = 300 : 329
% %     tp = trajs{16}.traj{i - 221}.pt;
% %     trajs{16}.traj{i - 221}.pt = trajs{13}.traj{i - 221}.pt;
% %     trajs{13}.traj{i - 221}.pt = tp;
% % end
% % trajs{13}.traj{330 - 221}.pt = [1589, 300];
% % for i = 331 : 340
% %     trajs{13}.traj{i - 221}.pt = trajs{130}.traj{i - 328}.pt;
% % end
% % for i = 341 : 421
% %     trajs{13}.traj{i - 221}.pt = trajs{138}.traj{i - 340}.pt;
% % end
% % trajs{13}.traj{422 - 221}.pt = [1589, 300];
% % for i = 423 : 521
% %     trajs{13}.traj{i - 221}.pt = trajs{173}.traj{i - 422}.pt;
% % end
% % 
% % trajs{14}.traj{292 - 221}.pt = trajs{67}.traj{292 - 257}.pt;
% % for i = 293 : 319
% %     trajs{14}.traj{i - 221}.pt = trajs{98}.traj{i - 292}.pt;
% % end
% % for i = 320 : 510
% %     trajs{14}.traj{i - 221}.pt = trajs{119}.traj{i - 319}.pt;
% % end
% % trajs{14}.traj{511 - 221}.pt = [168, 1700];
% % trajs{14}.traj{512 - 221}.pt = [169, 1699];
% % trajs{14}.traj{513 - 221}.pt = [175, 1694];
% % trajs{14}.traj{514 - 221}.pt = [179, 1685];
% % trajs{14}.traj{515 - 221}.pt = [178, 1674];
% % trajs{14}.traj{516 - 221}.pt = [179, 1664];
% % trajs{14}.traj{517 - 221}.pt = [172, 1648];
% % for i = 518 : 521
% %     trajs{14}.traj{i - 221}.pt = trajs{119}.traj{i - 517}.pt;
% % end
% % 
% % trajs{15}.traj{518 - 221}.pt = trajs{191}.traj{518 - 478}.pt;
% % for i = 519 : 521
% %     trajs{15}.traj{i - 221}.pt = trajs{207}.traj{i - 518}.pt;
% % end
% % 
% % trajs{19}.traj{278 - 221}.pt = trajs{35}.traj{279 - 221}.pt;
% % trajs{19}.traj{279 - 221}.pt = trajs{35}.traj{279 - 221}.pt;
% % for i = 280 : 318
% %     trajs{19}.traj{i - 221}.pt = trajs{81}.traj{i - 279}.pt;
% % end
% % trajs{19}.traj{319 - 221}.pt = [233, 1759];
% % for i = 320 : 335
% %     trajs{19}.traj{i - 221}.pt = trajs{120}.traj{i - 319}.pt;
% % end
% % trajs{19}.traj{336 - 221}.pt = [186, 1775];
% % for i = 337 : 345
% %     trajs{19}.traj{i - 221}.pt = trajs{136}.traj{i - 336}.pt;
% % end
% % trajs{19}.traj{346 - 221}.pt = [176, 1794];
% % for i = 347 : 521
% %     trajs{19}.traj{i - 221}.pt = trajs{144}.traj{i - 346}.pt;
% % end
% % 
% % for i = 444 : 521
% %     trajs{20}.traj{i - 221}.pt = trajs{178}.traj{i - 443}.pt;
% % end
% % 
% % trajs{22}.traj{322 - 221}.pt = [1339, 205];
% % for i = 323 : 521
% %     trajs{22}.traj{i - 221}.pt = trajs{124}.traj{i - 322}.pt;
% % end
% % 
% % for i = 406 : 521
% %     trajs{23}.traj{i - 221}.pt = trajs{115}.traj{i - 314}.pt;
% % end
% % 
% % trajs{26}.traj{421 - 221}.pt = [1586, 1779];
% % trajs{26}.traj{422 - 221}.pt = [1583, 1782];
% % trajs{26}.traj{423 - 221}.pt = [1582, 1781];
% % trajs{26}.traj{424 - 221}.pt = [1577, 1780];
% % for i = 425 : 521
% %     trajs{26}.traj{i - 221}.pt = trajs{174}.traj{i - 424}.pt;
% % end
% % 
% % for i = 354 : 482
% %     trajs{27}.traj{i - 221}.pt = trajs{147}.traj{i - 353}.pt;
% % end
% % trajs{27}.traj{483 - 221}.pt = [1185, 1085];
% % trajs{27}.traj{484 - 221}.pt = [1186, 1091];
% % for i = 485 : 521
% %     trajs{27}.traj{i - 221}.pt = trajs{195}.traj{i - 484}.pt;
% % end
% % 
% % for i = 498 : 506
% %     trajs{28}.traj{i - 221}.pt = trajs{199}.traj{i - 497}.pt;
% % end
% % trajs{28}.traj{507 - 221}.pt = trajs{201}.traj{509 - 508}.pt;
% % trajs{28}.traj{508 - 221}.pt = trajs{201}.traj{509 - 508}.pt;
% % for i = 509 : 521
% %     trajs{28}.traj{i - 221}.pt = trajs{201}.traj{i - 508}.pt;
% % end
% % 
% % for i = 251 : 352
% %     trajs{32}.traj{i - 221}.pt = trajs{63}.traj{i - 249}.pt;
% % end
% % trajs{32}.traj{353 - 221}.pt = [185, 1785];
% % for i = 354 : 521
% %     trajs{32}.traj{i - 221}.pt = trajs{148}.traj{i - 353}.pt;
% % end
% % 
% % trajs{33}.traj{366 - 221}.pt = [444, 1745];
% % for i = 367 : 521
% %     trajs{33}.traj{i - 221}.pt = trajs{154}.traj{i - 366}.pt;
% % end
% % 
% % trajs{34}.traj{274 - 221}.pt = [1746, 324];
% % trajs{34}.traj{275 - 221}.pt = [1763, 349];
% % trajs{34}.traj{276 - 221}.pt = [1746, 324];
% % for i = 277 : 281
% %     trajs{34}.traj{i - 221}.pt = trajs{79}.traj{i - 276}.pt;
% % end
% % for i = 282 : 284
% %     trajs{34}.traj{i - 221}.pt = trajs{25}.traj{i - 221}.pt;
% % end
% % for i = 285 : 359
% %     trajs{34}.traj{i - 221}.pt = trajs{89}.traj{i - 284}.pt;
% % end
% % trajs{34}.traj{360 - 221}.pt = [1723, 1536];
% % trajs{34}.traj{361 - 221}.pt = [1723, 1544];
% % trajs{34}.traj{362 - 221}.pt = [1723, 1550];
% % trajs{34}.traj{363 - 221}.pt = [1723, 1555];
% % trajs{34}.traj{364 - 221}.pt = [1723, 1559];
% % trajs{34}.traj{365 - 221}.pt = [1723, 1563];
% % trajs{34}.traj{366 - 221}.pt = [1723, 1567];
% % trajs{34}.traj{367 - 221}.pt = [1722, 1571];
% % trajs{34}.traj{368 - 221}.pt = [1721, 1575];
% % trajs{34}.traj{369 - 221}.pt = [1720, 1580];
% % trajs{34}.traj{370 - 221}.pt = [1719, 1584];
% % trajs{34}.traj{371 - 221}.pt = [1726, 1587];
% % trajs{34}.traj{372 - 221}.pt = [1737, 1597];
% % trajs{34}.traj{373 - 221}.pt = trajs{158}.traj{373 - 372}.pt;
% % for i = 374 : 521
% %     trajs{34}.traj{i - 221}.pt = trajs{159}.traj{i - 373}.pt;
% % end
% % 
% % for i = 506 : 521
% %     trajs{47}.traj{i - 221}.pt = trajs{35}.traj{i - 221}.pt;
% % end
% % 
% % trajs{35}.traj{502 - 221}.pt = [325, 242];
% % trajs{35}.traj{503 - 221}.pt = [327, 338];
% % trajs{35}.traj{504 - 221}.pt = [330, 336];
% % trajs{35}.traj{505 - 221}.pt = [326, 335];
% % trajs{35}.traj{506 - 221}.pt = [325, 330];
% % for i = 507 : 521
% %     trajs{35}.traj{i - 221}.pt = trajs{200}.traj{i - 506}.pt;
% % end
% % 
% % for i = 296 : 296
% %     trajs{38}.traj{i - 221}.pt = trajs{101}.traj{i - 295}.pt;
% % end
% % for i = 297 : 311
% %     trajs{38}.traj{i - 221}.pt = trajs{102}.traj{i - 296}.pt;
% % end
% % for i = 312 : 315
% %     trajs{38}.traj{i - 221}.pt = trajs{4}.traj{i - 221}.pt;
% % end
% % for i = 316 : 411
% %     trajs{38}.traj{i - 221}.pt = trajs{115}.traj{i - 314}.pt;
% % end
% % for i = 412 : 521
% %     trajs{38}.traj{i - 221}.pt = trajs{167}.traj{i - 409}.pt;
% % end
% % 
% % trajs{40}.traj{328 - 221}.pt = trajs{131}.traj{329 - 328}.pt;
% % for i = 329 : 333
% %     trajs{40}.traj{i - 221}.pt = trajs{131}.traj{i - 328}.pt;
% % end
% % trajs{40}.traj{334 - 221}.pt = trajs{131}.traj{333 - 328}.pt;
% % for i = 335 : 341
% %     trajs{40}.traj{i - 221}.pt = trajs{134}.traj{i - 334}.pt;
% % end
% % trajs{40}.traj{342 - 221}.pt = [248, 1825];
% % trajs{40}.traj{343 - 221}.pt = [261, 1825];
% % trajs{40}.traj{344 - 221}.pt = [270, 1823];
% % trajs{40}.traj{345 - 221}.pt = trajs{142}.traj{345 - 344}.pt;
% % trajs{40}.traj{346 - 221}.pt = trajs{136}.traj{345 - 336}.pt;
% % trajs{40}.traj{347 - 221}.pt = [199, 1768];
% % trajs{40}.traj{348 - 221}.pt = [190, 1746];
% % trajs{40}.traj{349 - 221}.pt = [185, 1724];
% % trajs{40}.traj{350 - 221}.pt = [177, 1704];
% % for i = 351 : 478
% %     trajs{40}.traj{i - 221}.pt = trajs{145}.traj{i - 350}.pt;
% % end
% % trajs{40}.traj{479 - 221}.pt = trajs{193}.traj{483 - 482}.pt;
% % trajs{40}.traj{480 - 221}.pt = trajs{193}.traj{483 - 482}.pt;
% % trajs{40}.traj{481 - 221}.pt = trajs{193}.traj{483 - 482}.pt;
% % trajs{40}.traj{482 - 221}.pt = trajs{193}.traj{483 - 482}.pt;
% % for i = 483 : 484
% %     trajs{40}.traj{i - 221}.pt = trajs{193}.traj{i - 482}.pt;
% % end
% % trajs{40}.traj{485 - 221}.pt = [156, 463];
% % trajs{40}.traj{486 - 221}.pt = [163, 467];
% % for i = 487 : 521
% %     trajs{40}.traj{i - 221}.pt = trajs{197}.traj{i - 486}.pt;
% % end
% % 
% % trajs{41}.traj{258 - 221}.pt = trajs{14}.traj{258 - 221}.pt;
% % trajs{41}.traj{259 - 221}.pt = trajs{14}.traj{259 - 221}.pt;
% % for i = 260 : 521
% %     trajs{41}.traj{i - 221}.pt = trajs{69}.traj{i - 259}.pt;
% % end
% % 
% % trajs{42}.traj{287 - 221}.pt = trajs{25}.traj{287 - 221}.pt;
% % trajs{42}.traj{288 - 221}.pt = trajs{25}.traj{288 - 221}.pt;
% % trajs{42}.traj{289 - 221}.pt = trajs{25}.traj{289 - 221}.pt;
% % trajs{42}.traj{290 - 221}.pt = trajs{25}.traj{290 - 221}.pt;
% % trajs{42}.traj{291 - 221}.pt = trajs{25}.traj{291 - 221}.pt;
% % trajs{42}.traj{292 - 221}.pt = trajs{25}.traj{292 - 221}.pt;
% % trajs{42}.traj{293 - 221}.pt = trajs{25}.traj{293 - 221}.pt;
% % for i = 294 : 441
% %     trajs{42}.traj{i - 221}.pt = trajs{99}.traj{i - 293}.pt;
% % end
% % trajs{42}.traj{442 - 221}.pt = trajs{99}.traj{441 - 293}.pt;
% % trajs{42}.traj{443 - 221}.pt = trajs{177}.traj{443 - 442}.pt;
% % trajs{42}.traj{444 - 221}.pt = trajs{177}.traj{443 - 442}.pt;
% % trajs{42}.traj{445 - 221}.pt = trajs{179}.traj{446 - 445}.pt;
% % trajs{42}.traj{446 - 221}.pt = trajs{179}.traj{446 - 445}.pt;
% % trajs{42}.traj{447 - 221}.pt = trajs{179}.traj{447 - 445}.pt;
% % trajs{42}.traj{448 - 221}.pt = trajs{179}.traj{448 - 445}.pt;
% % trajs{42}.traj{449 - 221}.pt = trajs{179}.traj{449 - 445}.pt;
% % trajs{42}.traj{450 - 221}.pt = trajs{179}.traj{450 - 445}.pt;
% % trajs{42}.traj{451 - 221}.pt = trajs{179}.traj{450 - 445}.pt;
% % trajs{42}.traj{452 - 221}.pt = trajs{179}.traj{450 - 445}.pt;
% % trajs{42}.traj{453 - 221}.pt = trajs{179}.traj{450 - 445}.pt;
% % trajs{42}.traj{454 - 221}.pt = trajs{179}.traj{450 - 445}.pt;
% % trajs{42}.traj{455 - 221}.pt = trajs{179}.traj{450 - 445}.pt;
% % for i = 456 : 521
% %     trajs{42}.traj{i - 221}.pt = trajs{184}.traj{i - 455}.pt;
% % end
% % 
% % trajs{43}.traj{280 - 221}.pt = trajs{88}.traj{285 - 284}.pt;
% % trajs{43}.traj{281 - 221}.pt = trajs{88}.traj{285 - 284}.pt;
% % trajs{43}.traj{282 - 221}.pt = trajs{88}.traj{285 - 284}.pt;
% % trajs{43}.traj{283 - 221}.pt = trajs{88}.traj{285 - 284}.pt;
% % trajs{43}.traj{284 - 221}.pt = trajs{88}.traj{285 - 284}.pt;
% % for i = 285 : 310
% %     trajs{43}.traj{i - 221}.pt = trajs{88}.traj{i - 284}.pt;
% % end
% % trajs{43}.traj{311 - 221}.pt = trajs{113}.traj{312 - 311}.pt;
% % for i = 312 : 341
% %     trajs{43}.traj{i - 221}.pt = trajs{113}.traj{i - 311}.pt;
% % end
% % trajs{43}.traj{342 - 221}.pt = trajs{141}.traj{343 - 342}.pt;
% % for i = 343 : 473
% %     trajs{43}.traj{i - 221}.pt = trajs{141}.traj{i - 342}.pt;
% % end
% % trajs{43}.traj{474 - 221}.pt = trajs{15}.traj{473 - 221}.pt;
% % trajs{43}.traj{475 - 221}.pt = trajs{15}.traj{473 - 221}.pt;
% % trajs{43}.traj{476 - 221}.pt = trajs{15}.traj{473 - 221}.pt;
% % trajs{43}.traj{477 - 221}.pt = trajs{15}.traj{473 - 221}.pt;
% % trajs{43}.traj{478 - 221}.pt = trajs{15}.traj{473 - 221}.pt;
% % for i = 479 : 520
% %     trajs{43}.traj{i - 221}.pt = trajs{191}.traj{i - 478}.pt;
% % end
% % trajs{43}.traj{521 - 221}.pt = trajs{208}.traj{521 - 518}.pt;
% % 
% % trajs{44}.traj{263 - 221}.pt = trajs{5}.traj{263 - 221}.pt;
% % trajs{44}.traj{264 - 221}.pt = trajs{71}.traj{264 - 263}.pt;
% % trajs{44}.traj{265 - 221}.pt = trajs{71}.traj{264 - 263}.pt;
% % trajs{44}.traj{266 - 221}.pt = trajs{71}.traj{264 - 263}.pt;
% % for i = 267 : 311
% %     trajs{44}.traj{i - 221}.pt = trajs{73}.traj{i - 266}.pt;
% % end
% % trajs{44}.traj{312 - 221}.pt = trajs{73}.traj{311 - 266}.pt;
% % trajs{44}.traj{313 - 221}.pt = trajs{73}.traj{311 - 266}.pt;
% % trajs{44}.traj{314 - 221}.pt = trajs{73}.traj{311 - 266}.pt;
% % trajs{44}.traj{315 - 221}.pt = trajs{73}.traj{311 - 266}.pt;
% % for i = 316 : 521
% %     trajs{44}.traj{i - 221}.pt = trajs{116}.traj{i - 315}.pt;
% % end
% % 
% % trajs{45}.traj{227 - 221}.pt = trajs{54}.traj{228 - 227}.pt;
% % for i = 228 : 373
% %     trajs{45}.traj{i - 221}.pt = trajs{54}.traj{i - 227}.pt;
% % end
% % trajs{45}.traj{374 - 221}.pt = trajs{25}.traj{374 - 221}.pt;
% % trajs{45}.traj{375 - 221}.pt = trajs{25}.traj{375 - 221}.pt;
% % trajs{45}.traj{376 - 221}.pt = trajs{25}.traj{376 - 221}.pt;
% % trajs{45}.traj{377 - 221}.pt = trajs{25}.traj{377 - 221}.pt;
% % trajs{45}.traj{378 - 221}.pt = trajs{25}.traj{378 - 221}.pt;
% % for i = 379 : 521
% %     trajs{45}.traj{i - 221}.pt = trajs{162}.traj{i - 377}.pt;
% % end
% % 
% % trajs{46}.traj{269 - 221}.pt = [207, 868];
% % trajs{46}.traj{270 - 221}.pt = [206, 869];
% % trajs{46}.traj{271 - 221}.pt = [204, 872];
% % for i = 272 : 272
% %     trajs{46}.traj{i - 221}.pt = trajs{75}.traj{i - 271}.pt;
% % end
% % for i = 273 : 295
% %     trajs{46}.traj{i - 221}.pt = trajs{67}.traj{i - 257}.pt;
% % end
% % trajs{46}.traj{296 - 221}.pt = trajs{103}.traj{297 - 296}.pt;
% % for i = 297 : 353
% %     trajs{46}.traj{i - 221}.pt = trajs{103}.traj{i - 296}.pt;
% % end
% % trajs{46}.traj{354 - 221}.pt = trajs{149}.traj{355 - 354}.pt;
% % for i = 355 : 462
% %     trajs{46}.traj{i - 221}.pt = trajs{149}.traj{i - 354}.pt;
% % end
% % trajs{46}.traj{463 - 221}.pt = trajs{29}.traj{463 - 221}.pt;
% % trajs{46}.traj{464 - 221}.pt = trajs{29}.traj{464 - 221}.pt;
% % for i = 465 : 482
% %     trajs{46}.traj{i - 221}.pt = trajs{189}.traj{i - 464}.pt;
% % end
% % trajs{46}.traj{483 - 221}.pt = trajs{189}.traj{482 - 464}.pt;
% % for i = 484 : 521
% %     trajs{46}.traj{i - 221}.pt = trajs{194}.traj{i - 483}.pt;
% % end
% % 
% % trajs{47}.traj{234 - 221}.pt = trajs{47}.traj{232 - 221}.pt;
% % for i = 235 : 239
% %     trajs{47}.traj{i - 221}.pt = trajs{56}.traj{i - 234}.pt;
% % end
% % for i = 240 : 250
% %     trajs{47}.traj{i - 221}.pt = trajs{32}.traj{i - 221}.pt;
% % end
% % for i = 251 : 257
% %     trajs{47}.traj{i - 221}.pt = trajs{67}.traj{258 - 257}.pt;
% % end
% % for i = 258 : 273
% %     trajs{47}.traj{i - 221}.pt = trajs{67}.traj{i - 257}.pt;
% % end
% % for i = 274 : 274
% %     trajs{47}.traj{i - 221}.pt = trajs{77}.traj{i - 273}.pt;
% % end
% % for i = 275 : 317
% %     trajs{47}.traj{i - 221}.pt = trajs{78}.traj{i - 274}.pt;
% % end
% % for i = 318 : 322
% %     trajs{47}.traj{i - 221}.pt = trajs{98}.traj{318 - 292}.pt;
% % end
% % for i = 323 : 496
% %     trajs{47}.traj{i - 221}.pt = trajs{125}.traj{i - 322}.pt;
% % end
% % for i = 497 : 501
% %     trajs{47}.traj{i - 221}.pt = trajs{28}.traj{i - 221}.pt;
% % end
% % for i = 502 : 505
% %     trajs{47}.traj{i - 221}.pt = trajs{35}.traj{i - 221}.pt;
% % end
% % 
% % trajs{48}.traj{1}.pt = trajs{50}.traj{1}.pt;
% % for i = 223 : 301
% %     trajs{48}.traj{i - 221}.pt = trajs{50}.traj{i - 222}.pt;
% % end
% % trajs{48}.traj{302 - 221}.pt = trajs{109}.traj{1}.pt;
% % trajs{48}.traj{303 - 221}.pt = trajs{109}.traj{1}.pt;
% % for i = 304 : 307
% %     trajs{48}.traj{i - 221}.pt = trajs{109}.traj{i - 303}.pt;
% % end
% % trajs{48}.traj{308 - 221}.pt = trajs{112}.traj{1}.pt;
% % trajs{48}.traj{309 - 221}.pt = trajs{112}.traj{1}.pt;
% % trajs{48}.traj{310 - 221}.pt = trajs{112}.traj{1}.pt;
% % for i = 311 : 518
% %     trajs{48}.traj{i - 221}.pt = trajs{112}.traj{i - 310}.pt;
% % end
% % trajs{48}.traj{519 - 221}.pt = trajs{112}.traj{518 - 310}.pt;
% % trajs{48}.traj{520 - 221}.pt = trajs{209}.traj{521 - 520}.pt;
% % trajs{48}.traj{521 - 221}.pt = trajs{209}.traj{521 - 520}.pt;
% % 
% % trajs{49}.traj{222 - 221}.pt = trajs{52}.traj{225 - 224}.pt;
% % trajs{49}.traj{223 - 221}.pt = trajs{52}.traj{225 - 224}.pt;
% % trajs{49}.traj{224 - 221}.pt = trajs{52}.traj{225 - 224}.pt;
% % for i = 225 : 235
% %     trajs{49}.traj{i - 221}.pt = trajs{57}.traj{236 - 235}.pt;
% % end
% % for i = 236 : 276
% %     trajs{49}.traj{i - 221}.pt = trajs{57}.traj{i - 235}.pt;
% % end
% % for i = 277 : 280
% %     trajs{49}.traj{i - 221}.pt = trajs{76}.traj{i - 272}.pt;
% % end
% % for i = 281 : 307
% %     trajs{49}.traj{i - 221}.pt = trajs{4}.traj{i - 221}.pt;
% % end
% % for i = 308 : 397
% %     trajs{49}.traj{i - 221}.pt = trajs{110}.traj{i - 307}.pt;
% % end
% % trajs{49}.traj{398 - 221}.pt = trajs{164}.traj{399 - 398}.pt;
% % for i = 399 : 454
% %     trajs{49}.traj{i - 221}.pt = trajs{164}.traj{i - 398}.pt;
% % end
% % trajs{49}.traj{455 - 221}.pt = trajs{182}.traj{455 - 454}.pt;
% % trajs{49}.traj{456 - 221}.pt = trajs{187}.traj{460 - 459}.pt;
% % trajs{49}.traj{457 - 221}.pt = trajs{187}.traj{460 - 459}.pt;
% % trajs{49}.traj{458 - 221}.pt = trajs{187}.traj{460 - 459}.pt;
% % trajs{49}.traj{459 - 221}.pt = trajs{187}.traj{460 - 459}.pt;
% % for i = 460 : 521
% %     trajs{49}.traj{i - 221}.pt = trajs{187}.traj{i - 459}.pt;
% % end
% % 
% % save('trajs_fish49_CoreView241_222-521_final.mat', 'trajs');
% % 
% % for i = 269 : delta_frame : 521
% %     img = im2double(imread(['../Fish_2D_CNN/CoreView_241/CoreView_241_Master_Camera_', sprintf('%05d', i), '.bmp']));
% %     figure, imshow(img);
% %     hold on;
% %     for j = 1 : 49
% %         j
% %         if trajs{j}.bg_frame <= i% && trajs{j}.ed_frame > i && trajs{j}.ed_frame - trajs{j}.bg_frame > 2
% %             nt = (i - trajs{j}.bg_frame) / delta_frame + 1;
% %             plot(trajs{j}.traj{nt}.pt(2), trajs{j}.traj{nt}.pt(1), 'b.');
% %             text(trajs{j}.traj{nt}.pt(2), trajs{j}.traj{nt}.pt(1), num2str(j), 'Color', 'r', 'FontSize', 15);
% %         end
% %     end
% %     saveas(gcf, ['res_CoreView241_222-521/', sprintf('%04d', i), '.jpg']);
% %     hold off;
% %     close all;
% % end
% % 
% % tic;





% load('raw_trajs_CV54_1-500_150911.mat');
% 
% % coreview54_1-300
% for j = 1 : length(trajs)
%     trajs{j}.ed_frame = trajs{j}.bg_frame + length(trajs{j}.traj);
%     for fr = length(trajs{j}.traj) + 1 : 500
%         trajs{j}.traj{fr}.pt = [0 0];
%     end
% end
% 
% for i = 172 : delta_frame : 381
%     tpt = trajs{18}.traj{i}.pt;
%     trajs{18}.traj{i}.pt = [tpt(2) tpt(1)];
% end
% 
% for i = 150 : 443
%     trajs{6}.traj{i}.pt = trajs{23}.traj{i - 149}.pt;
% end
% 
% for i = 445 : 500
% 	trajs{6}.traj{i}.pt = trajs{72}.traj{i - 444}.pt;
% end   
% 
% for i = 474 : 500
%     trajs{4}.traj{i}.pt = trajs{78}.traj{i - 473}.pt;
% end
% 
% trajs{5}.traj{457}.pt = [261, 328];
% trajs{5}.traj{458}.pt = [261, 328];
% trajs{5}.traj{459}.pt = [261, 328];
% trajs{5}.traj{460}.pt = [261, 328];
% trajs{5}.traj{461}.pt = [261, 328];
% trajs{5}.traj{462}.pt = [261, 328];
% for i = 463 : 500
%     trajs{5}.traj{i}.pt = trajs{74}.traj{i - 462}.pt;
% end
% 
% for i = 471 : 500
%     trajs{8}.traj{i}.pt = trajs{77}.traj{i - 470}.pt;
% end
% 
% for i = 317 : 320
%     trajs{9}.traj{i}.pt = trajs{56}.traj{i - 316}.pt;
% end
% 
% for i = 328 : 500
%     trajs{9}.traj{i}.pt = trajs{58}.traj{i - 327}.pt;
% end
% 
% trajs{13}.traj{403}.pt = [854, 176];
% trajs{13}.traj{404}.pt = [854, 176];
% trajs{13}.traj{405}.pt = [854, 176];
% for i = 406 : 411
%     trajs{13}.traj{i}.pt = trajs{66}.traj{i - 405}.pt;
% end
% 
% for i = 413 : 500
%     trajs{13}.traj{i}.pt = trajs{68}.traj{i - 412}.pt;
% end
% 
% for i = 172 : 500
%     trajs{17}.traj{i}.pt = trajs{25}.traj{i - 171}.pt;
% end
% 
% for i = 171 : 500
%     trajs{20}.traj{i}.pt = trajs{24}.traj{i - 170}.pt;
% end
% 
% for i = 382 : 423
%     trajs{18}.traj{i}.pt = trajs{62}.traj{i - 381}.pt;
% end
% trajs{18}.traj{424}.pt = [470, 1906];
% trajs{18}.traj{425}.pt = [470, 1906];
% for i = 426 : 500
%     trajs{18}.traj{i}.pt = trajs{70}.traj{i - 425}.pt;
% end
% 
% for i = 145 : 147
%     trajs{20}.traj{i}.pt = trajs{17}.traj{i}.pt;
% end
% 
% for i = 148 : 149
%     trajs{20}.traj{i}.pt = trajs{22}.traj{i - 147}.pt;
% end
% 
% for i = 150 : 169
%     trajs{20}.traj{i}.pt = trajs{17}.traj{i}.pt;
% end
% 
% trajs{20}.traj{170}.pt = [292, 508];
% 
% trajs{13}.traj{412}.pt = trajs{17}.traj{412}.pt;
% 
% trajs{4}.traj{467}.pt = trajs{2}.traj{467}.pt;
% trajs{4}.traj{468}.pt = trajs{2}.traj{468}.pt;
% trajs{4}.traj{469}.pt = trajs{2}.traj{469}.pt;
% trajs{4}.traj{470}.pt = trajs{2}.traj{470}.pt;
% trajs{4}.traj{471}.pt = trajs{2}.traj{471}.pt;
% trajs{4}.traj{472}.pt = trajs{2}.traj{472}.pt;
% trajs{4}.traj{473}.pt = trajs{2}.traj{473}.pt;
% 
% trajs{21}.bg_frame = ed_frame + 1;
% trajs{22}.bg_frame = ed_frame + 1;
% trajs{25}.bg_frame = ed_frame + 1;

% load('raw_trajs_CV275_2400-2512_151115.mat');





% load('raw_trajs_CV340_1-2000_thr2_radius50.mat');
load('trajs_fish27_CoreView340_1-2000_final.mat');


for i = 1 : length(trajs)
end

% edit_total{1}.list = [9550, 9880, 1;
%                     9881, 9996, 41;
%                     9997, 10085, 51;
%                     10086, 10086, 61;
%                     10087, 10087, 60;
%                     10088, 10131, 61;
%                     10132, 10148, 60];
% edit_total{2}.list = [9550, 9609, 2;
%                     9610, 9610, 0;
%                     9611, 9799, 18;
%                     9800, 10085, 37;
%                     10086, 10086, 60;
%                     10087, 10148, 70];    
% edit_total{3}.list = [9550, 9587, 3;
%                     9588, 9588, 0;
%                     9589, 9747, 3;
%                     9748, 10148, 32];
% edit_total{4}.list = [9550, 10148, 4];
% edit_total{5}.list = [9550, 10131, 5;
%                     10132, 10148, 61];
% edit_total{6}.list = [9550, 9808, 6;
%                     9809, 10046, 38;
%                     10047, 10047, 0;
%                     10048, 10085, 61;
%                     10086, 10095, 37;
%                     10096, 10100, 0;
%                     10101, 10148, 74];
% edit_total{7}.list = [9550, 9590, 7;
%                     9591, 10148, 15];
% edit_total{8}.list = [9550, 9731, 8;
%                     9733, 9734, 0;
%                     9735, 9808, 31;
%                     9809, 9822, 0;
%                     9823, 9997, 39;
%                     9998, 10009, 0;
%                     10010, 10050, 56;
%                     10051, 10058, 0;
%                     10059, 10084, 56;
%                     10085, 10085, 0;
%                     10086, 10086, 51;
%                     10087, 10087, 61;
%                     10088, 10131, 60;
%                     10132, 10138, 0;
%                     10139, 10148, 77];
% edit_total{9}.list = [9550, 9908, 9;
%                     9909, 9910, 0;
%                     9911, 10065, 9;
%                     10066, 10076, 62;
%                     10077, 10079, 65;
%                     10080, 10080, 66;
%                     10081, 10148, 65];
% edit_total{10}.list = [9550, 9784, 10;
%                     9785, 9845, 35;
%                     9846, 9950, 40;
%                     9951, 10148, 46];
% edit_total{11}.list = [9550, 10045, 11;
%                     10046, 10046, 0;
%                     10047, 10082, 60;
%                     10083, 10083, 0;
%                     10084, 10148, 69];
%                 
% add_total{1}.list = [];
% add_total{2}.list = [9610, 1579, 1240;];
% add_total{3}.list = [9588, 1434, 656];
% add_total{4}.list = [];
% add_total{5}.list = [];
% add_total{6}.list = [10047, 718, 1708;
%                     10096, 954, 1667;
%                     10097, 961, 1667;
%                     10098, 966, 1667;
%                     10099, 964, 1669;
%                     10100, 973, 1669;];
% add_total{7}.list = [];
% add_total{8}.list = [9732, 1625, 1736;
%                     9733, 1631, 1739;
%                     9734, 1634, 1742;
%                     9809, 1337, 1637;
%                     9810, 1334, 1634;
%                     9811, 1328, 1631;
%                     9812, 1325, 1628;
%                     9813, 1325, 1616;
%                     9814, 1326, 1607;
%                     9815, 1320, 1600;
%                     9816, 1303, 1596;
%                     9817, 1285, 1596;
%                     9818, 1274, 1591;
%                     9819, 1255, 1582;
%                     9820, 1241, 1575;
%                     9821, 1228, 1568;
%                     9822, 1212, 1563;
%                     9956, 558, 1773;
%                     9957, 561, 1769;
%                     9958, 564, 1765;
%                     9959, 566, 1763;
%                     9998, 628, 1713;
%                     9999, 635, 1708;
%                     10000, 638, 1708;
%                     10001, 633, 1708;
%                     10002, 638, 1706;
%                     10003, 638, 1706;
%                     10004, 635, 1708;
%                     10005, 638, 1704;
%                     10006, 647, 1704;
%                     10007, 647, 1704;
%                     10008, 645, 1704;
%                     10009, 647, 1701;
%                     10051, 638, 1694;
%                     10052, 635, 1692;
%                     10053, 638, 1694;
%                     10054, 638, 1694;
%                     10055, 638, 1692;
%                     10056, 640, 1692;
%                     10057, 635, 1692;
%                     10058, 638, 1690;
%                     10085, 642, 1704;
%                     10132, 672, 1713;
%                     10133, 677, 1715;
%                     10134, 677, 1715;
%                     10135, 681, 1715;
%                     10136, 679, 1715;
%                     10137, 681, 1713;
%                     10138, 684, 1715];
% add_total{9}.list = [9909, 817, 732;
%                     9910, 819, 735];
% add_total{10}.list = [];
% add_total{11}.list = [10046, 879, 994;
%                     10083, 1368, 854];
% 
% for i = 1 : 11
%     for j = 1 : size(edit_total{i}.list, 1)
%         for ffr = edit_total{i}.list(j, 1) : edit_total{i}.list(j, 2)
%             if edit_total{i}.list(j, 3) ~= 0
%                 trajs_final{i}.traj{ffr - bg_frame + 1} = trajs{edit_total{i}.list(j, 3)}.traj{ffr - trajs{edit_total{i}.list(j, 3)}.bg_frame + 1};
%             else
%                 trajs_final{i}.traj{ffr - bg_frame + 1}.pt = [0, 0];
%             end
%         end
%     end
%     for j = 1 : size(add_total{i}.list, 1)
%         trajs_final{i}.traj{add_total{i}.list(j, 1) - bg_frame + 1}.pt = [add_total{i}.list(j, 2), add_total{i}.list(j, 3)];
%     end
% end
% 
% clear trajs;
% for i = 1 : 11
%     trajs{i} = trajs_final{i};
% end

nt = 1;
for j = 1 : length(trajs)
%     trajs{j}.bg_frame = 9550;
%     trajs{j}.id = j;
    trajs{j}.ed_frame = trajs{j}.bg_frame + length(trajs{j}.traj);
    if length(trajs{j}.traj) > 10
        nt = nt + 1;
    end
%     for fr = length(trajs{j}.traj) + 1 : 300
%         trajs{j}.traj{fr}.pt = [0 0];
%     end
end

nt
% aviobj = avifile('CoreView_338_head.avi', 'compression', 'None', 'quality', 100);

% % CV213 325-865
% % trajs{2}.traj{738 - 325 + 1}.pt = [349, 364];
% % trajs{2}.traj{739 - 325 + 1}.pt = [350, 362];
% % for i = 452 : 865
% %     trajs{7}.traj{i - trajs{7}.bg_frame + 1}.pt = trajs{11}.traj{i - trajs{11}.bg_frame + 1}.pt;
% % end
% % trajs{7}.ed_frame = 866;
% % 
% % for i = 740 : 865
% %     trajs{2}.traj{i - trajs{2}.bg_frame + 1}.pt = trajs{16}.traj{i - trajs{16}.bg_frame + 1}.pt;
% % end
% % trajs{2}.ed_frame = 866;

% figure(1);
% imshow(img);
% hold on;
    
res = 0;
for i = 2122 : 1 : 4121
    i
    img = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/CoreView_217_Master_Camera_', sprintf('%05d', i), '.bmp']));
    figure, imshow(img);
    hold on;
    
    for j = 1 : length(trajs)
%         j
        if trajs{j}.bg_frame <= i && trajs{j}.ed_frame > i && trajs{j}.ed_frame - trajs{j}.bg_frame > 9
            nt = (i - trajs{j}.bg_frame) / delta_frame + 1;
            if size(trajs{j}.traj{nt}.pt) > 0
                if trajs{j}.traj{nt}.pt(1) > 0
                    plot(trajs{j}.traj{nt}.pt(2), trajs{j}.traj{nt}.pt(1), 'r.');
        %             plot(trajs{j}.traj{nt}.midline(:, 2), trajs{j}.traj{nt}.midline(:, 1), 'r-', 'LineWidth', 3);
                    res = res + 1;
                    text(trajs{j}.traj{nt}.pt(2), trajs{j}.traj{nt}.pt(1), num2str(j), 'Color', 'b', 'FontSize', 20);
                end
            end
        end
    end
    
%     nt = (i - trajs{1}.bg_frame) / delta_frame + 1;
%     minx = min(trajs{1}.traj{nt}.midline(:, 1));
%     maxx = max(trajs{1}.traj{nt}.midline(:, 1));
%     l1 = maxx - minx;
%     miny = min(trajs{1}.traj{nt}.midline(:, 2));
%     maxy = max(trajs{1}.traj{nt}.midline(:, 2));
%     l2 = maxy - miny;
%     if l1 < l2
%         minx = minx - fix((l2 - l1) / 2);
%         maxx = maxx + (l2 - l1 - fix((l2 - l1) / 2));
%     end
%     if l1 > l2
%         miny = miny - fix((l1 - l2) / 2);
%         maxy = maxy + (l1 - l2 - fix((l1 - l2) / 2));
%     end
%     small = img(minx - 40 : maxx + 40, miny - 40 : maxy + 40);
%     imshow(small, 'Border');
%     hold on;
%     plot(trajs{1}.traj{nt}.midline(:, 2) - miny + 41, trajs{1}.traj{nt}.midline(:, 1) - minx + 41, 'r-', 'LineWidth', 5);
%     text(trajs{1}.traj{nt}.pt(2) - miny + 41, trajs{1}.traj{nt}.pt(1) - minx + 41, num2str(1), 'Color', 'b', 'FontSize', 25);
%     plot(trajs{1}.traj{nt}.pt(2) - miny + 41, trajs{1}.traj{nt}.pt(1) - minx + 41, 'b.');
    set(gcf, 'outerposition', get(0, 'screensize'));
    saveas(gcf, ['manual_connected_CoreView217_2122-4121/', sprintf('%04d', i), '.jpg']);
%     F = getframe;
%     aviobj = addframe(aviobj, F);
    hold off;
    close all;
end

% aviobj = close(aviobj);

% save('trajs_fish20_CoreView54_1-300_final.mat', 'trajs');

tic;

% % res
% cnt = 0;
% cnt1 = 0;
% cnt2 = 0;
% cnt3 = 0;
% 
% for j = 1 : length(trajs)
%     if trajs{j}.ed_frame == -1
%         trajs{j}.ed_frame = ed_frame + 1;
%     end
%     len = (trajs{j}.ed_frame - trajs{j}.bg_frame) / delta_frame;
%     if len >= 240
%         cnt1 = cnt1 + 1;
%     end
%     if len <= 60
%         cnt3 = cnt3 + 1;
%     end
%     if len < 240 && len > 60
%         
%         cnt2 = cnt2 + 1;
%     end
% %     if (trajs{j}.ed_frame - trajs{j}.bg_frame) / delta_frame > 0.8 * (ed_frame - bg_frame + 1)
% %         
% %     end
% end
% 
% cnt1
% cnt2
% cnt3
% cnt1 + cnt2 + cnt3
% end