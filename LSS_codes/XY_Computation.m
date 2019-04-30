function X = XY_Computation(coor, diff)
format long;
const(1) = diff(1);
const(2) = coor(1) - coor(3);
const(3) = diff(2);
const(4) = 1.85;

syms x y;
eq1 = (1-x^const(1))/(x^const(2)*(1- x^const(3))) -1 ==0;
solx  = solve(eq1, x);
% realx = solx;
solx = abs(double(solx))

eq2 = y *(1 - solx^const(1))/(1 - solx) - const(4) ==0;
soly = solve(eq2, y);
soly = double(soly)

X = [solx, soly];
% x0 = [1.005, 0.015];
% x0 = [1.0028658, 0.010852];
% options = optimset('Display', 'off');
% x = fsolve(@(x) sumGeometry(x, const), x0, options);
end