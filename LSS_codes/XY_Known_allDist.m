% load('.\Data\allPara.mat');

for i = 1:1:size(allPara,2)
    Dist(i,: ) = XY_Known_rollerDist(allPara(i).coor, allPara(i).diff);
end