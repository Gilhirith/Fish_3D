function [res] = Cross_Product(x1, y1, x2, y2, x0, y0)

    res = (x1 - x0) .* (y2 - y0) - (x2 - x0) .* (y1 - y0);

end