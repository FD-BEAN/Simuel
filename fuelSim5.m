%% initialization of parameters/variables
tic

numBarge = 4;
timetoterminal = duration('03:00:00');
timetovessel = duration('03:00:00');

% Read the details of barge from excel for easier management
[bargeDetails, bargetxt, rawbargedata] = xlsread('bargeDetails7.xlsx');
bargeInitialCapacity = bargeDetails(1:4,2);
bargeInitialAvailtime = datetime(datestr(bargeDetails(1:4,10) + datenum('30-Dec-1899')));
% assume barge location only at oil terminal or port
bargeInitialLocation = bargeDetails(1:4,11);

% Read the details of vessel from excel for easier management
[vesselDetails, vesseltxt, rawCelldata] = xlsread('vesselDetails7.xlsx');
numVessel = length(vesselDetails(:,1));
vesselBerth = datetime(datestr(vesselDetails(:,4) + datenum('30-Dec-1899')));
vesselDepart = datetime(datestr(vesselDetails(:,5) + datenum('30-Dec-1899')));
% assume each vessel requires only one type of oil
vesselBunker = vesselDetails(:,7);
vesselTransfertime = minutes(vesselDetails(:,8));

scatter(1:10,vesselBerth);
hold on;
scatter(1:10,vesselDepart);
%% Assignment of vessel to barge (problem with bigger number of vessels)****

[Y{numVessel:-1:1}] = ndgrid(1:numBarge) ;
bargeAssign = reshape(cat(numVessel+1,Y{:}),[],numVessel) ;

assignAll = length(bargeAssign(:,1));
%% pre-processing of assignments (threshold is set at 5)

threshold = 5;

% assume half the total number but not true, tend out to be 326176, generalized formula needed
assignDiscarded = zeros(1,326176);
counter = 1;
for i = 1:assignAll
    % threshold set at 5
    if max(histcounts(bargeAssign(i,:))) >= threshold
        assignDiscarded(1,counter) = i;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
assignValid = length(bargeAssign);
%% Constraints checks

assignCheckBool = zeros(assignValid,1);

for j = 1:assignValid
    
    bargeCapacity = bargeInitialCapacity;
    bargeAvailtime = bargeInitialAvailtime;
    bargeLocation = bargeInitialLocation;
    currentSelection = bargeAssign(j,:);
    
    for k = 1:numVessel
        
        currentBarge = currentSelection(1,k);
        % check if bunker on the barge is enough for this transfer
        if bargeCapacity(currentBarge,1) > vesselBunker(k,1)
            % check if the barge available time is earlier than the latest time possible to start transfering oil
            % bargeAvailtime is the time when the barge has enough fuel arriving at the vessel and able to start transfer oil
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetovessel;
            if (vesselDepart(k,1) - vesselTransfertime(k,1)) > bargeAvailtime(currentBarge,1)
                if bargeAvailtime(currentBarge,1) < vesselBerth(k,1)
                    bargeAvailtime(currentBarge,1) = vesselBerth(k,1) + vesselTransfertime(k,1);
                else
                    bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(k,1);
                end
                bargeCapacity(currentBarge,1) = bargeCapacity(currentBarge,1) - vesselBunker(k,1);
                assignCheckBool(j,1) = 1;
            else
                assignCheckBool(j,1) = 0; % time constraint not satisfied
                break
            end
            
        else
            % Need to topup bunker: top up all or only the type required?
            topup = minutes(0.03 * (bargeInitialCapacity(currentBarge,1) - bargeCapacity(currentBarge,1)));
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetoterminal + timetovessel + topup;
            % update the new oil amount for current barge
            bargeCapacity(currentBarge,1) = bargeInitialCapacity(currentBarge,1);            
            if (vesselDepart(k,1) - vesselTransfertime(k,1)) > bargeAvailtime(currentBarge,1)
                if bargeAvailtime(currentBarge,1) < vesselBerth(k,1)
                    bargeAvailtime(currentBarge,1) = vesselBerth(k,1) + vesselTransfertime(k,1);
                else
                    bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(k,1);
                end
                bargeCapacity(currentBarge,1) = bargeCapacity(currentBarge,1) - vesselBunker(k,1);
                assignCheckBool(j,1) = 1;
            else
                assignCheckBool(j,1) = 0;
                break
            end
        end
    end
end
%% Objective function evaluation

% create an array indexing all feasible assignments from assignBarge cell
assignFiltered = find(assignCheckBool);

% Profit = Fuel profit - barge operating cost(in function of time?)
% unit fuel profit for each type and unit barge cost, dummy penalized heavily and traveling time not included yet
% must include cost, otherwise the revenue will be same since in all case assignment satisfied
fuelProfit =30;

assignFeasible = length(assignFiltered);
profitAssign = zeros(assignFeasible, 1);

% bargeTimespend = minutes(vesselOiltransfer);

for m = 1:assignFeasible
    profitBarges = zeros(1,numBarge);
    currentAssignment = bargeAssign(assignFiltered(m,1),:);
    for n = 1:numVessel
        if currentAssignment(1,n) ~= 4
            profitBarges(1,currentAssignment(1,n)) = profitBarges(1,currentAssignment(1,n)) + fuelProfit * vesselBunker(n,1);
        else
            profitBarges(1,n) = 0;
        end
    end
    profitAssign(m,1) = sum(profitBarges);
end

[max_revenue,best_assign] = max(profitAssign);
finalAssign = bargeAssign(assignFiltered(best_assign,1),:);
%% 