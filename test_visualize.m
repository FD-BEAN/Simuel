%% Plot the best arrangement

tic

% barge_1 = cellstr(bargeArrangement(:,:,1));
% barge_2 = cellstr(bargeArrangement(:,:,2));
% barge_3 = cellstr(bargeArrangement(:,:,3));
% barge_4 = cellstr(bargeArrangement(:,:,4));

for r = 1:numBarge
    f = figure('Position', [0 50 530 250]);
    t = uitable('Parent', f, 'Position', [0 50 530 200], 'Data', cellstr(bargeArrangement(:,:,r)));
    t.ColumnWidth = {60, 120, 120, 120, 50};
    t.ColumnName = {'Location', 'Free time point', 'Start Transfer', 'End Transfer', 'Refuel'};
end

toc

