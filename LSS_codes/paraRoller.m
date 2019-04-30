function [Lines_Num, Y_Coordinates, Roller_Dist] = paraRoller(lines)

    X_Coordinate = 512;   % This is usually the center of the X coordinate
    
    Lines_Num = size(lines, 2);
    
    for i = 1:1:size(lines, 2)
        coeff = polyfit( [lines(i).point1(1), lines(i).point2(1)], [lines(i).point1(2), lines(i).point2(2)], 1);
        Y_Coordinates(i) = round(polyval(coeff, X_Coordinate));
    end

     Y_Coordinates = sort(Y_Coordinates, 'descend');
    for i = 1:1:floor(size(lines,2) / 2)
        Roller_Dist(i) = Y_Coordinates(2*i -1) - Y_Coordinates(2*i);
    end
end