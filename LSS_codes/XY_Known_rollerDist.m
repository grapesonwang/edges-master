function temp_dist = rollerDist(coor, diff)
%% long format used to do data processing
format long;
x = 1.007835394289457;
y = 0.007060949659788;

% x = 1.0028658382047198;
% y = 0.010852799221328105;


for i = 1:1:length(diff)
    para1 = coor(1) - coor(2*i -1);
    para2 = diff(i);
    temp_dist(i) = y*(x^para1) * (1-x^para2) /(1-x);
end
end