%% initialization of parameters/variables
tic

numFuel = 6;  
numBarge = 4;

fuelType = (1:numFuel);

timetoterminal = duration('03:00:00');
timetovessel = duration('03:00:00');

% Read the details of barge from excel for easier management
[bargeDetails, bargetxt, rawbargedata] = xlsread('bargeDetails6.xlsx');
bargeInitialCapacity = bargeDetails(1:4,1);
bargeInitialAvailtime = datetime(datestr(bargeDetails(1:4,10) + datenum('30-Dec-1899')));
% assume barge location only at oil terminal or port
bargeInitialLocation = bargeDetails(1:4,11);

% Read the details of vessel from excel for easier management
[vesselDetails, vesseltxt, rawCelldata] = xlsread('vesselDetails6.xlsx');
numVessel = length(vesselDetails(:,1));
vesselBerth = datetime(datestr(vesselDetails(:,4) + datenum('30-Dec-1899')));
vesselDepart = datetime(datestr(vesselDetails(:,5) + datenum('30-Dec-1899')));
% assume each vessel requires only one type of oil
vesselOilamount = vesselDetails(:,7);
vesselOiltransfer = minutes(vesselDetails(:,8));

scatter(1:10,vesselBerth);
hold on;
scatter(1:10,vesselDepart);

toc
%% Assignment of vessel to barge (problem with bigger number of vessels)****
tic

[Y{numVessel:-1:1}] = ndgrid(1:numBarge) ;
bargeAssign = reshape(cat(numVessel+1,Y{:}),[],numVessel) ;

assignAll = length(bargeAssign(:,1));

toc
%% pre-processing of assignments (threshold is set at 5)
tic

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

toc

%% Constraints checks
tic

assignCheckBool = zeros(assignValid,1);

for j = 1:assignValid
    
    bargeCapacity = bargeInitialCapacity;
    bargeAvailtime = bargeInitialAvailtime;
    bargeLocation = bargeInitialLocation;
    currentSelection = bargeAssign(j,:);
    
        for k = 1:numVessel
            
            currentBarge = currentSelection(1,k);
            % case 1: barge at port, ready for transfering oil
            if bargeLocation(currentBarge,1) == 1
                
                % check if oil is enough for this transfer
                if bargeCapacity(currentBarge,1) > vesselOilamount(k,1)
                                        
                    % check if the barge available time is earlier than the latest time possible to start transfering oil
                    % bargeAvailtime is the time when the barge has enough fuel arriving at the vessel and able to start transfer oil
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > bargeAvailtime(currentBarge,1) + timetovessel
                        
                        if bargeAvailtime(currentBarge,1) + timetovessel < vesselBerth(k,1) 
                            bargeAvailtime(currentBarge,1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselOiltransfer(k,1) + timetovessel;
                        end
                        bargeCapacity(currentBarge,1) = bargeCapacity(currentBarge,1) - vesselOilamount(k,1);
                        assignCheckBool(j,1) = 1;
                    % time constraint not satisfied
                    else
                        assignCheckBool(j,1) = 0;
                        break
                    end
                    
                else
                    % Need to topup bunker: top up all or only the type required?
                    topup = minutes(0.03 * (bargeInitialCapacity(currentBarge,1) - bargeCapacity(currentBarge,1)));
                    bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetoterminal + timetovessel + topup;
                    % update the new oil amount for current barge
                    bargeCapacity(currentBarge,1) = bargeInitialCapacity(currentBarge,1);
                    
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > bargeAvailtime(currentBarge,1)
                        if bargeAvailtime(currentBarge,1) < vesselBerth(k,1) 
                            bargeAvailtime(currentBarge,1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselOiltransfer(k,1);
                        end
                        bargeCapacity(currentBarge,1) = bargeCapacity(currentBarge,1) - vesselOilamount(k,1);
                        assignCheckBool(j,1) = 1;
                    else
                        assignCheckBool(j,1) = 0;
                        break
                    end
                end
            
            % case 2: barge at oil terminal, require time for add oil or go to port
            else
                % check if oil is enough for this transfer
                % maybe can simplify to: if ....
                if bargeCapacity(currentBarge,1) > vesselOilamount(k,1)
                    
                    % check if the barge available time is earlier than the latest time possible to start transfering oil
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > (bargeAvailtime(currentBarge,1) + timetovessel)
                        if bargeAvailtime(currentBarge,1) + timetovessel < vesselBerth(k,1) 
                            bargeAvailtime(currentBarge,1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentBarge,1) = timetovessel + bargeAvailtime(currentBarge,1) + vesselOiltransfer(k,1);
                        end
                        assignCheckBool(j,1) = 1;
                        bargeCapacity(currentBarge,1) = bargeCapacity(currentBarge,1) - vesselOilamount(k,1);
                        bargeLocation(currentBarge,1) = 1;
                    else
                        assignCheckBool(j,1) = 0;
                        break
                    end
                else
                    
                    % need add oil amount to be top up * time per unit for the type or add full topup time?
                    topup = minutes(0.03 * (bargeInitialCapacity(currentBarge,1) - bargeCapacity(currentBarge,1)));
                    bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetovessel + topup;
                    % update the new oil amount for current barge
                    bargeCapacity(currentBarge,1) = bargeInitialCapacity(currentBarge,1);
                                    
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > bargeAvailtime(currentBarge,1)
                        if bargeAvailtime(currentBarge,1) < vesselBerth(k,1) 
                            bargeAvailtime(currentBarge,1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselOiltransfer(k,1);
                        end
                        assignCheckBool(j,1) = 1;
                        bargeCapacity(currentBarge,1) = bargeCapacity(currentBarge,1) - vesselOilamount(k,1);
                        bargeLocation(currentBarge,1) = 1;
                    else
                        assignCheckBool(j,1) = 0;
                        break
                    end
                end  
            end     
        end
end

toc
%% Objective function evaluation
tic

% create an array indexing all feasible assignments from assignBarge cell
assignFiltered = find(assignCheckBool);

% Profit = Fuel profit - barge operating cost(in function of time?)
% must include cost, otherwise the revenue will be same since in all case assignment satisfied?
fuelProfit =30;

assignFeasible = length(assignFiltered);
profitAssign = zeros(assignFeasible, 1);

% bargeTimespend = minutes(vesselOiltransfer);

for m = 1:assignFeasible
    profitBarges = zeros(1,numBarge);
    currentAssignment = bargeAssign(assignFiltered(m,1),:);
    for n = 1:numVessel
        if currentAssignment(1,n) ~= 4
            profitBarges(1,currentAssignment(1,n)) = profitBarges(1,currentAssignment(1,n)) + fuelProfit * vesselOilamount(n,1);
        else
            profitBarges(1,n) = 0;
        end
    end
    profitAssign(m,1) = sum(profitBarges);
end

[max_revenue,best_assign] = max(profitAssign);
finalAssign = bargeAssign(assignFiltered(best_assign,1),:);

toc
%% Record arrangement of barges for the best assignment
tic

bargeCapacity = bargeInitialCapacity;
bargeAvailtime = bargeInitialAvailtime;
bargeLocation = bargeInitialLocation;

% vessel index, barge arrangement (start point, free time point, start transfer time, end transfer time, ifBacktoterminal),vessel index,
bargeArrangement = strings(numVessel,5,numBarge);

for p = 1:numVessel
    % barge is already at vessel port
    if bargeLocation(finalAssign(1,p),1) == 1
        
        bargeArrangement(p,1,finalAssign(1,p)) = "vessel port";
        
        if bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) > vesselOilamount(p,1)
            
            bargeArrangement(p,2,finalAssign(1,p)) = datestr(bargeAvailtime(finalAssign(1,p),1));
            bargeArrangement(p,5,finalAssign(1,p)) = "no";
            
            if bargeAvailtime(finalAssign(1,p),1) < vesselBerth(p,1)
                bargeAvailtime(finalAssign(1,p),1) = vesselBerth(p,1) + vesselOiltransfer(p,1);
                
                bargeArrangement(p,3,finalAssign(1,p)) = datestr(vesselBerth(p,1));
                bargeArrangement(p,4,finalAssign(1,p)) = datestr(bargeAvailtime(finalAssign(1,p),1));
               
            else
                bargeAvailtime(finalAssign(1,p),1) = bargeAvailtime(finalAssign(1,p),1) + vesselOiltransfer(p,1);
                
                bargeArrangement(p,3,finalAssign(1,p)) = bargeArrangement(p,2,finalAssign(1,p));
                bargeArrangement(p,4,finalAssign(1,p)) = bargeAvailtime(finalAssign(1,p),1);
                
            end
            bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) = bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) - vesselOilamount(p,1);
        
        else
            
            topup = minutes(fuelTopuptime(1,vesselOiltype(p,1)) * (bargeInitialCapacity(finalAssign(1,p),vesselOiltype(p,1)) - bargeCapacity(finalAssign(1,p),vesselOiltype(p,1))));
            bargeAvailtime(finalAssign(1,p),1) = bargeAvailtime(finalAssign(1,p),1) + timetoterminal + timetovessel + topup;
            bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) = bargeInitialCapacity(finalAssign(1,p),vesselOiltype(p,1));
            
            bargeArrangement(p,2,finalAssign(1,p)) = datestr(bargeAvailtime(finalAssign(1,p),1));
            bargeArrangement(p,5,finalAssign(1,p)) = "yes";
            
            if bargeAvailtime(finalAssign(1,p),1) < vesselBerth(p,1) 
                bargeAvailtime(finalAssign(1,p),1) = vesselBerth(p,1) + vesselOiltransfer(p,1);
                
                bargeArrangement(p,3,finalAssign(1,p)) = datestr(vesselBerth(p,1));
                bargeArrangement(p,4,finalAssign(1,p)) = datestr(bargeAvailtime(finalAssign(1,p),1));

            else
                bargeAvailtime(finalAssign(1,p),1) = bargeAvailtime(finalAssign(1,p),1) + vesselOiltransfer(p,1);
                
                bargeArrangement(p,3,finalAssign(1,p)) = bargeArrangement(p,2,finalAssign(1,p));
                bargeArrangement(p,4,finalAssign(1,p)) = bargeAvailtime(finalAssign(1,p),1);

            
            end
            bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) = bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) - vesselOilamount(p,1);
        end
  
    % barge starts at oil terminal
    else
        
        bargeArrangement(p,1,finalAssign(1,p)) = "oil terminal";
         
        if bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) > vesselOilamount(p,1)
            % with enough oil, diretly travel to vessel port
            bargeAvailtime(finalAssign(1,p),1) = bargeAvailtime(finalAssign(1,p),1) + timetovessel;
            
            bargeArrangement(p,2,finalAssign(1,p)) = datestr(bargeAvailtime(finalAssign(1,p),1));
            bargeArrangement(p,5,finalAssign(1,p)) = "no";
            
            if bargeAvailtime(finalAssign(1,p),1) < vesselBerth(p,1)
                bargeAvailtime(finalAssign(1,p),1) = vesselBerth(p,1) + vesselOiltransfer(p,1);
                
                bargeArrangement(p,3,finalAssign(1,p)) = datestr(vesselBerth(p,1));
                bargeArrangement(p,4,finalAssign(1,p)) = datestr(bargeAvailtime(finalAssign(1,p),1));
                
            else
                bargeAvailtime(finalAssign(1,p),1) = bargeAvailtime(finalAssign(1,p),1) + vesselOiltransfer(p,1);
                
                bargeArrangement(p,3,finalAssign(1,p)) = bargeArrangement(p,2,finalAssign(1,p));
                bargeArrangement(p,4,finalAssign(1,p)) = bargeAvailtime(finalAssign(1,p),1);
                
            end
            bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) = bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) - vesselOilamount(p,1);
            bargeLocation(finalAssign(1,p),1) = 1;
            
        else
            topup = minutes(fuelTopuptime(1,vesselOiltype(p,1)) * (bargeInitialCapacity(finalAssign(1,p),vesselOiltype(p,1)) - bargeCapacity(finalAssign(1,p),vesselOiltype(p,1))));
            bargeAvailtime(finalAssign(1,p),1) = bargeAvailtime(finalAssign(1,p),1) + timetovessel + topup;
            bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) = bargeInitialCapacity(finalAssign(1,p),vesselOiltype(p,1));
            
            bargeArrangement(p,2,finalAssign(1,p)) = datestr(bargeAvailtime(finalAssign(1,p),1));
            bargeArrangement(p,5,finalAssign(1,p)) = "yes";
            
            if bargeAvailtime(finalAssign(1,p),1) < vesselBerth(p,1) 
                bargeAvailtime(finalAssign(1,p),1) = vesselBerth(p,1) + vesselOiltransfer(p,1);
                
                bargeArrangement(p,3,finalAssign(1,p)) = datestr(vesselBerth(p,1));
                bargeArrangement(p,4,finalAssign(1,p)) = datestr(bargeAvailtime(finalAssign(1,p),1));
                
            else
                bargeAvailtime(finalAssign(1,p),1) = bargeAvailtime(finalAssign(1,p),1) + vesselOiltransfer(p,1);
                
                bargeArrangement(p,3,finalAssign(1,p)) = bargeArrangement(p,2,finalAssign(1,p));
                bargeArrangement(p,4,finalAssign(1,p)) = bargeAvailtime(finalAssign(1,p),1);
                
            end
            bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) = bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) - vesselOilamount(p,1);
        end
    end
end
    
toc

%% Tabulate the best arrangement

tic

% barge_1 = cellstr(bargeArrangement(:,:,1));
% barge_2 = cellstr(bargeArrangement(:,:,2));
% barge_3 = cellstr(bargeArrangement(:,:,3));
% barge_4 = cellstr(bargeArrangement(:,:,4));

for r = 1:numBarge
    f = figure('Position', [0 50 530 250]);
    t = uitable('Parent', f, 'Position', [0 50 530 200], 'Data', cellstr(bargeArrangement(:,:,r)));
    t.ColumnWidth = {60, 120, 120, 120, 50};
    t.ColumnName = {'Location', 'Arrives at vessel port', 'Start Transfer', 'End Transfer', 'Refuel'};
end

toc
