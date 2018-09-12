% matrix = eye(5);%5x5 identity matrix
% list_o_cols_to_delete = [1 3 5];
% matrix(list_o_cols_to_delete,:) = []

% x =[
% 22 23 24 23
% 24 23 24 22
% 22 23 23 23];
% histcounts(x)
% 
% a = unique(x);
% 
% out = [a,histc(x(:),a)];

% assume half the total number but not true. 
% tic
% assignDiscarded = zeros(1,326176);
% counter = 1;
% for i = 1:assignOpts
%     % threshold set at 5
%     if max(histcounts(bargeAssign(i,:))) >= 5
%         assignDiscarded(1,counter) = i;
%         counter = counter + 1;
%     end
% end
% toc
% 
% bargeAssign(assignDiscarded, :) = [];
% 
% tic
% assignFiltered = find(assignCheckBool);
% toc

%% Objective function evaluation
% maybe should integrate to the check constraints since time is needed

% create an array indexing all feasible assignments from assignBarge cell
assignFiltered = find(assignCheckBool);

% Profit = Fuel profit - barge operating cost(in function of time?)
% unit fuel profit for each type and unit barge cost, dummy set high and traveling time not included yet
fuelProfit = [30 20 15 25];
bargeCost = [2 3 4 100000];

assignFeasible = length(assignFiltered);
profitAssign = zeros(assignFeasible, 1);
profitBarges = zeros(1,numBarge);

bargeTimespend = minutes(vesselOiltransfer);

for m = 1:assignFeasible
    currentAssignment = bargeAssign(assignFiltered(m,1),:);
    for n = 1:numVessel
        profitBarges(1,n) = fuelProfit(1,vesselOiltype(n,1)) * vesselOilamount(n,1) - bargeCost(1,currentAssignment(1,n)) * bargeTimespend(n,1);
    end
    profitAssign(m,1) = sum(profitBarges);
end

[a,b] = max(profitAssign);
finalAssign = bargeAssign(assignFiltered(b,1),:);