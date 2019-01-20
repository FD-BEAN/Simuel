testNum = [1 2 3 4 1 2 3 4 1 2 3 4 1 2 3];
% testNum = [1 2 3 1 2 3 1 2 3 1 2 3 1 2 3];
% testNum = [1 2 1 2 1 2 1 2 1 2];   this case not possible due to filter
% testNum = [1 1 1 1 1 1 1 1 1 1];   this case not possible due to filter

lenNum = length(unique(testNum));

p1 = find(testNum == 1);
p2 = find(testNum == 2);
p3 = find(testNum == 3);
p4 = find(testNum == 4);

expNum = perms([1 2 3 4]);
newNum = zeros(24,10);

tic
for i = 1:24
        newNum(i,p1) = expNum(i,1);
        newNum(i,p2) = expNum(i,2);
        newNum(i,p3) = expNum(i,3);
        newNum(i,p4) = expNum(i,4);
end
toc

disp(newNum);