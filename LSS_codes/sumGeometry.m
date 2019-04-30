function F = sumGeometry(x, const)
F = [ x(2) * (1 - x(1)^const(1))/(1 - x(1)) - const(4);
         x(2) * x(1)^const(2)*(1 - x(1)^const(3)) - const(4)];
end