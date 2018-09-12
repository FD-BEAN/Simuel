% % initialization of parameters/variables


% prices of IFO380, IFO180, MGO, LSMGO in US$/metric tonne (Aug 24)
% need to deal with the fluctuating prices??
% fuelPrice = [463 496 665 676]; 


% numFuel = input('How many types of fuel: ');
% assume there are 4 types

numFuel = 4; 
fuelType = (1:numFuel);
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
bargeOilTypeTU = minutes(bargeDetails(:,11:14));
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


% Assignment of vessel to barge (problem with bigger number of vessels)****
% need to think another algorithm to assign the barges to vessels
[Y{numVessel:-1:1}] = ndgrid(1:numBarge) ;
bargeAssign = reshape(cat(numVessel+1,Y{:}),[],numVessel) ;
% bargeAssign = permn([1 2 3 4],10);

% pre-processing of assignments
assignOpts = length(bargeAssign(:,1));


% Constraints checks
assignCheckBool = zeros(assignOpts,1);

for j = 1:assignOpts
    
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
                    bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) = bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) - vesselOilamount(k,1);
                    
                    % check if the barge available time is earlier than the latest time possible to start transfering oil
                    % bargeAvailtime is the time when the barge has enough fuel arriving at the vessel and able to start transfer oil
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > bargeAvailtime(currentSelection(1,k),1)
                        
                        if bargeAvailtime(currentSelection(1,k),1) < vesselBerth(k,1) 
                            bargeAvailtime(currentSelection(1,k),1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + vesselOiltransfer(k,1);
                        end
                        assignCheckBool(j,1) = 1;
                    else
                        assignCheckBool(j,1) = 0;
                        break
                    end
                    
                else
                    % need add oil amount to be top up * time per unit for the type or add full topup time
                    bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + timetoterminal + timetovessel;
                    
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > bargeAvailtime(currentSelection(1,k),1)
                        if bargeAvailtime(currentSelection(1,k),1) < vesselBerth(k,1) 
                            bargeAvailtime(currentSelection(1,k),1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + vesselOiltransfer(k,1);
                        end
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
                    bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) = bargeCapacity(currentSelection(1,k),vesselOiltype(k,1)) - vesselOilamount(k,1);
                    
                    % check if the barge available time is earlier than the latest time possible to start transfering oil
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > (bargeAvailtime(currentSelection(1,k),1) + timetovessel)
                        if bargeAvailtime(currentSelection(1,k),1) < vesselBerth(k,1) 
                            bargeAvailtime(currentSelection(1,k),1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + vesselOiltransfer(k,1);
                        end
                        assignCheckBool(j,1) = 1;
                        bargeLocation(currentSelection(1,k),1) = 1;
                    else
                        assignCheckBool(j,1) = 0;
                        break
                    end
                else
                    % need to add oil top up time
                    bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + timetovessel;
                    
                    if (vesselDepart(k,1) - vesselOiltransfer(k,1)) > bargeAvailtime(currentSelection(1,k),1)
                        if bargeAvailtime(currentSelection(1,k),1) < vesselBerth(k,1) 
                            bargeAvailtime(currentSelection(1,k),1) = vesselBerth(k,1) + vesselOiltransfer(k,1);
                        else
                            bargeAvailtime(currentSelection(1,k),1) = bargeAvailtime(currentSelection(1,k),1) + vesselOiltransfer(k,1);
                        end
                        assignCheckBool(j,1) = 1;
                        bargeLocation(currentSelection(1,k),1) = 1;
                    else
                        assignCheckBool(j,1) = 0;
                        break
                    end
                end  
            end     
        end
end


    