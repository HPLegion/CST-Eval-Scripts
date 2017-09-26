function [emit_x, emit_y] = emittance(ts_coordinates)

x= ts_coordinates.x;
xp= ts_coordinates.xprime;
y= ts_coordinates.y;
yp= ts_coordinates.yprime;

msk = ~isnan(x);
x = x(msk);
y = y(msk);
xp = xp(msk);
yp = yp(msk);

emit_x = sqrt(det(cov(x,xp)));
emit_y = sqrt(det(cov(y,yp)));

end

