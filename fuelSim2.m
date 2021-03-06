%% Updates:

% dummy cost and profit changed to 0
% record the barge plan for the best assignment in bargeArrangement

%% initialization of parameters/variables

tic

% prices of IFO380, IFO180, MGO, LSMGO in US$/metric tonne (Aug 24)
% need to deal with the fluctuating prices??
% fuelPrice = [463 496 665 676]; 

% numFuel = input('How many types of fuel: ');
% assume there are 4 types

numFuel = 4;  
fuelType = (1:numFuel);

% unit top up time for the four types of oil (assumed numbers)
fuelTopuptime = [0.04 0.06 0.05 0.08];

%{
numBarge = input('Total number of barges: ');
bargeSequence = (1:numBarge);
bargeCapacity = zeros(1,numBarge);
timeTopups = strings(1,numBarge);
bargeAvailtime = strings(1,numBarge);


for i = 1:numBarge
    % capacity in m cubic or tonne?
    fprintf('Total fuel capacity of barge %d ',i)
    bargeCapacity(1,i) = input('is: ');
    fprintf('Fuel top-up time (hh:mm:ss) for barge %d ',i)
    cout1 = 'is: ';
    timeTopups(1,i) = duration(str2double(strsplit(input(cout1,'s'), ':')));
end
timeTopup = duration(timeTopups);
%}

% Read the details of barge from excel for easier management
[bargeDetails, bargetxt, rawbargedata] = xlsread('bargeDetails.xlsx');
numBarge = length(bargeDetails(:,1));
bargeInitialCapacity = bargeDetails(:,3:6);
bargeTopuptime = minutes(bargeDetails(:,7));
bargeInitialAvailtime = datetime(datestr(bargeDetails(:,9) + datenum('30-Dec-1899')));
% assume barge location only at oil terminal or port
bargeInitialLocation = bargeDetails(:,10);

% assume travel time is constant
% cout2 = 'The time taken (hh:mm:ss) for barge to reach oil terminal (Jurong Island): ';
% timetoterminal = duration(input(cout2,'s'));
timetoterminal = duration('01:00:00');
% cout3 = 'The time taken (hh:mm:ss) for the barge to reach vessels: ';
% timetovessel = duration(input(cout3,'s'));
timetovessel = duration('01:00:00');


% Read the details of vessel from excel for easier management
[vesselDetails, vesseltxt, rawCelldata] = xlsread('vesselDetails.xlsx');
numVessel = length(vesselDetails(:,1));
vesselSequence = (1:numVessel);
vesselBerth = datetime(datestr(vesselDetails(:,4) + datenum('30-Dec-1899')));
vesselDepart = datetime(datestr(vesselDetails(:,5) + datenum('30-Dec-1899')));
% time duration for vessel stay at port
vesselStay = vesselDepart - vesselBerth; 
% assume each vessel requires only one type of oil
vesselOiltype = vesselDetails(:,6); 
vesselOilamount = vesselDetails(:,7);
vesselOiltransfer = minutes(vesselDetails(:,8));

% Different types of oil on the ship, need to take into consideration??
bargeOilavail = zeros(numBarge,numFuel); 

toc

%% Assignment of vessel to barge (problem with bigger number of vessels)****

tic

% need to think another algorithm to assign the barges to vessels
[Y{numVessel:-1:1}] = ndgrid(1:numBarge) ;
bargeAssign = reshape(cat(numVessel+1,Y{:}),[],numVessel) ;
% bargeAssign = permn([1 2 3 4],10);

% pre-processing of assignments
assignOpts = length(bargeAssign(:,1));

toc

%% pre-processing of assignments (threshold is set at 5)

tic

threshold = 5;

% assume half the total number but not true, tend out to be 326176, generalized formula needed???
assignDiscarded = zeros(1,326176);
counter = 1;
for i = 1:assignOpts
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

assignCheckBool = zeros(assignOpts,1);

for j = 1:assignValid
    
    bargeCapacity = bargeInitialCapacity;
    bargeAvailtime = bargeInitialAvailtime;
    bargeLocation = bargeInitialLocation;
    currentSelection = bargeAssign(j,:);
    
        for k = 1:numVessel
            
            % case 1: barge at port, ready for transfering oil
            if bargeLocation(currentSelection(1,k),1) == 1
                
                % check if oil is enough for this transfer
                % maybe can simplify to: if ....
                if bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) > vesselOilamount(k,1)
                                        
                    % check if the barge available time is earlier than the latest time possible to start transfering oil
                    % bargeAvailtime is the time when the barge has enough fuel arriving at the vessel and able to start transfer oil
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > bargeAvailtime(currentSelection(1,k),1)
                        
                        if bargeAvailtime(currentSelection(1,k),1) < vesselBerth(k,1) 
                            bargeAvailtime(currentSelection(1,k),1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            
                            bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + vesselOiltransfer(k,1);
                        end
                        bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) = bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) - vesselOilamount(k,1);
                        assignCheckBool(j,1) = 1;
                    else
                        assignCheckBool(j,1) = 0;
                        break
                    end
                    
                else
                    % need add oil amount to be top up * time per unit for the type or add full topup time???
                    topup = minutes(fuelTopuptime(1,vesselOiltype(k,1)) * (bargeInitialCapacity(currentSelection(1,k),vesselOiltype(k,1)) - bargeCapacity(currentSelection(1,k),vesselOiltype(k,1))));
                    bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + timetoterminal + timetovessel + topup;
                    % update the new oil amount for current barge
                    bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) = bargeInitialCapacity(currentSelection(1,k),vesselOiltype(k,1));
                    
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > bargeAvailtime(currentSelection(1,k),1)
                        if bargeAvailtime(currentSelection(1,k),1) < vesselBerth(k,1) 
                            bargeAvailtime(currentSelection(1,k),1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + vesselOiltransfer(k,1);
                        end
                        bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) = bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) - vesselOilamount(k,1);
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
                if bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) > vesselOilamount(k,1)
                    
                    % check if the barge available time is earlier than the latest time possible to start transfering oil
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > (bargeAvailtime(currentSelection(1,k),1) + timetovessel)
                        if bargeAvailtime(currentSelection(1,k),1) < vesselBerth(k,1) 
                            bargeAvailtime(currentSelection(1,k),1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + vesselOiltransfer(k,1);
                        end
                        assignCheckBool(j,1) = 1;
                        bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) = bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) - vesselOilamount(k,1);
                        bargeLocation(currentSelection(1,k),1) = 1;
                    else
                        assignCheckBool(j,1) = 0;
                        break
                    end
                else
                    
                    % need add oil amount to be top up * time per unit for the type or add full topup time???
                    topup = minutes(fuelTopuptime(1,vesselOiltype(k,1)) * (bargeInitialCapacity(currentSelection(1,k),vesselOiltype(k,1)) - bargeCapacity(currentSelection(1,k),vesselOiltype(k,1))));
                    bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + timetovessel + topup;
                    % update the new oil amount for current barge
                    bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) = bargeInitialCapacity(currentSelection(1,k),vesselOiltype(k,1));
                                    
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > bargeAvailtime(currentSelection(1,k),1)
                        if bargeAvailtime(currentSelection(1,k),1) < vesselBerth(k,1) 
                            bargeAvailtime(currentSelection(1,k),1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + vesselOiltransfer(k,1);
                        end
                        assignCheckBool(j,1) = 1;
                        bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) = bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) - vesselOilamount(k,1);
                        bargeLocation(currentSelection(1,k),1) = 1;
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
% maybe should integrate to the check constraints since time is needed

tic

% create an array indexing all feasible assignments from assignBarge cell
assignFiltered = find(assignCheckBool);

% Profit = Fuel profit - barge operating cost(in function of time?)
% unit fuel profit for each type and unit barge cost, dummy penalized heavily and traveling time not included yet
fuelProfit = [30 20 15 0];
bargeCost = [2 3 4 0];

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
        
        bargeArrangement(p,1,finalAssign(1,p)) = "1";
        
        if bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) > vesselOilamount(p,1)
            
            bargeArrangement(p,2,finalAssign(1,p)) = datestr(bargeAvailtime(finalAssign(1,p),1));
            bargeArrangement(p,5,finalAssign(1,p)) = "0";
            
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
            bargeArrangement(p,5,finalAssign(1,p)) = "1";
            
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
        
        bargeArrangement(p,1,finalAssign(1,p)) = "0";
         
        if bargeCapacity(finalAssign(1,p),vesselOiltype(p,1)) > vesselOilamount(p,1)
            % with enough oil, diretly travel to vessel port
            bargeAvailtime(finalAssign(1,p),1) = bargeAvailtime(finalAssign(1,p),1) + timetovessel;
            
            bargeArrangement(p,2,finalAssign(1,p)) = datestr(bargeAvailtime(finalAssign(1,p),1));
            bargeArrangement(p,5,finalAssign(1,p)) = "0";
            
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
            bargeArrangement(p,5,finalAssign(1,p)) = "1";
            
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
