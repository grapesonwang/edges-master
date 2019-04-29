% clear all

% load('.\Data\lines.mat');

for i = 1:1:8
    
    p = polyfit([lines(i).point1(1), lines(i).point2(1)], [lines(i).point1(2), lines(i).point2(2)], 1);
    coor(i) = polyval(p, 512);
end

coor = sort(coor, 'descend');

for i = 1:1:4
    diff(i) = - (coor(2*i) - coor(2*i - 1));
end


