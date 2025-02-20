function evalDist = distRoller(allPara, standardData, Tolerance)

    j = 1;
    inter = 6;
    standardLinesNum = length(standardData.standard_coor)

    for i = 1:1:size(allPara, 2)
        if allPara(i).num == standardLinesNum
            temp_coor = sort(allPara(i).coor, 'descend')
            error_coor = abs(temp_coor - standardData.standard_coor)
            flag = length(error_coor(error_coor > Tolerance))
            
            if flag == 0
                evalDist(j).num = allPara(i).num;
                evalDist(j).coor = allPara(i).coor;
                evalDist(j).diff = allPara(i).diff;
                evalDist(j).ortin = i;
                evalDist(j).dist = rollerDist(allPara(i).coor, allPara(i).diff); 
                
                j = j+1
            end
        end        
    end
    
end

function temp_dist = rollerDist(coor, diff)
format long;

num_coor = length(coor);
num_diff = length(diff);
if num_coor ~= 2*num_diff
    disp('Coordinate numbers do not match');
else
    XY = XY_Computation(coor, diff)
    x = XY(1);
    y = XY(2);
end

for i = 1:1:num_diff
    para1 = coor(i) - (2*i -1);
    para2 = diff(i);
    temp_dist(i) = y*x^para1 * (1-x^para2) /(1-x);
end
end

