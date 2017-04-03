function Xp = Reproject_to_2D(Xc, kc, fc, cc, alpha_c)

Xn = [Xc(1, :) ./ Xc(3, :); Xc(2, :) ./ Xc(3, :)];

x = Xn(1, :);
y = Xn(2, :);
r = sqrt(x .^ 2 + y .^ 2);

dx = [2 * kc(3) * x .* y + kc(4) * (r .^ 2 + 2 * x .^ 2); kc(3) * (r .^ 2 + 2 * y .^ 2) + 2 * kc(4) .* x .* y];

Xd(1, :) = (1 + kc(1) * r .^ 2 + kc(2) * r .^ 4 + kc(5) * r .^ 6) .* Xn(1, :) + dx(1, :);
Xd(2, :) = (1 + kc(1) * r .^ 2 + kc(2) * r .^ 4 + kc(5) * r .^ 6) .* Xn(2, :) + dx(2, :);

Xp = [fc(1) * (Xd(1, :) + alpha_c * Xd(2, :)) + cc(1); fc(2) * Xd(2, :) + cc(2)];

