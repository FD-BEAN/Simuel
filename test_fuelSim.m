tic
[Y{numVessel:-1:1}] = ndgrid(1:4) ;
bargeAssign = reshape(cat(numVessel+1,Y{:}),[],numVessel) ;

assignAll = length(bargeAssign(:,1));
toc
%% pre-processing of assignments (threshold is set at 5)
tic
threshold = 5;

% assume half the total number but not true, tend out to be 326176, generalized formula needed
assignDiscarded = zeros();
counter = 1;
for i = 1:assignAll
    % threshold set at 5
    if max(histcounts(bargeAssign(i,:))) >= threshold || length(find(bargeAssign(i,:) == 4)) >= 3 || sum(diff([0 find(diff(bargeAssign(i,:))) numel(bargeAssign(i,:))]) >= 4) >= 1 || bargeAssign(i,1) == 4
        assignDiscarded(1,counter) = i;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
assignValid = length(bargeAssign);
toc