function [pos_contour, nose, head_ed] = Get_Head_Rect(head_posx, head_posy, direction, rect_wd, rect_len)

%     global body_wd;
%     global head_len;

    head_ed(1) = head_posx - 0.5 * rect_len .* cos(direction);
    head_ed(2) = head_posy - 0.5 * rect_len .* sin(direction);
    
    nose(1) = head_posx + 0.5 * rect_len .* cos(direction);
    nose(2) = head_posy + 0.5 * rect_len .* sin(direction);

    pos_contour(1, 1) = nose(1) + 0.5 .* rect_wd .* sin(direction);
    pos_contour(2, 1) = nose(2) - 0.5 .* rect_wd .* cos(direction);
    pos_contour(1, 2) = head_ed(1) + 0.5 .* rect_wd .* sin(direction);
    pos_contour(2, 2) = head_ed(2) - 0.5 .* rect_wd .* cos(direction);
    pos_contour(1, 3) = head_ed(1) - 0.5 .* rect_wd .* sin(direction);
    pos_contour(2, 3) = head_ed(2) + 0.5 .* rect_wd .* cos(direction);
    pos_contour(1, 4) = nose(1) - 0.5 .* rect_wd .* sin(direction);
    pos_contour(2, 4) = nose(2) + 0.5 .* rect_wd .* cos(direction);
    pos_contour(1, 5) = pos_contour(1, 1);
    pos_contour(2, 5) = pos_contour(2, 1);
    
%     plot(pos_contour(1, 1:2), pos_contour(2, 1:2), 'c-', 'LineWidth', 2);
%     plot(pos_contour(1, 2:3), pos_contour(2, 2:3), 'b-', 'LineWidth', 2);
%     plot(pos_contour(1, 3:4), pos_contour(2, 3:4), 'r-', 'LineWidth', 2);
%     plot(pos_contour(1, :), pos_contour(2, :), 'r-', 'LineWidth', 1);
    
%     plot(head_ed(1), head_ed(2), 'c.');
%     plot(nose_posx, nose_posy, 'm.');
        
end