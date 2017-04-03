function dis = Dis_Line_to_Points(epiLine, pts)

    dis = (1/sqrt(sum(epiLine(1 : 2).^2))) * abs(epiLine(1) * pts(:, 1) + epiLine(2) * pts(:, 2) + repmat(epiLine(3), 1, size(pts, 1)));
    
end