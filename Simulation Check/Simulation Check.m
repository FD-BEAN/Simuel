%% Load the barge and vessel information
load('simResult7_5(3 barge,no dummy).mat')


%% Simulation check

bargeCapacity = bargeInitialCapacity;
bargeAvailtime = bargeInitialAvailtime;

bargeArrangement = strings(10,8,numBarge);
counter3 = [1, 1, 1, 1];

Assign = [1 2 3 1 2 3 2 3 1 3];

% Assign = [2 1 2 1 2 1 3 1 2 3];  % Uncomment the following line and rerun to see results for unfeasible set

for p = 1:numVessel
    
    currentBarge = Assign(1,p);
    
    if bargeCapacity(currentBarge,vesselBunkertype(p,1)) >= vesselBunker(p,1)
        
        bargeArrangement(counter3(1,currentBarge),2,currentBarge) = datestr(vesselBerth(p,1));
        bargeArrangement(counter3(1,currentBarge),3,currentBarge) = datestr(vesselDepart(p,1));
        bargeArrangement(counter3(1,currentBarge),4,currentBarge) = vesselBunkertype(p,1);
        bargeArrangement(counter3(1,currentBarge),5,currentBarge) = vesselBunker(p,1);
        
        bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetovessel;
        bargeArrangement(counter3(1,currentBarge),1,currentBarge) = strcat("vessel",num2str(p));
        bargeArrangement(counter3(1,currentBarge),6,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
        
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(vesselBerth(p,1));
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
        else
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);
        counter3(1,currentBarge) = counter3(1,currentBarge) + 1;
        if bargeAvailtime(currentBarge,1) > vesselDepart(p)
            break;
        end
    else
        bargeArrangement(counter3(1,currentBarge),1,currentBarge) = "Terminal";
        bargeArrangement(counter3(1,currentBarge),6,currentBarge) = datestr(bargeAvailtime(currentBarge,1) + timetoterminal);
        bargeArrangement(counter3(1,currentBarge),7,currentBarge) = bargeArrangement(counter3(1,currentBarge),6,currentBarge);
        
        bargeArrangement(counter3(1,currentBarge),2,currentBarge) = "Nil";
        bargeArrangement(counter3(1,currentBarge),3,currentBarge) = "Nil";
        bargeArrangement(counter3(1,currentBarge),4,currentBarge) = vesselBunkertype(p,1);
        bargeArrangement(counter3(1,currentBarge),5,currentBarge) = bargeInitialCapacity(currentBarge,vesselBunkertype(p,1)) - bargeCapacity(currentBarge,vesselBunkertype(p,1));
        
        topup = minutes(0.03 * (bargeInitialCapacity(currentBarge,vesselBunkertype(p,1)) - bargeCapacity(currentBarge,vesselBunkertype(p,1))));
        
        bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1) + timetoterminal + topup);
        counter3(1,currentBarge) = counter3(1,currentBarge)+1;
        
        bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetoterminal + timetovessel + topup;
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeInitialCapacity(currentBarge,vesselBunkertype(p,1));
        bargeArrangement(counter3(1,currentBarge),1,currentBarge) = strcat("vessel",num2str(p));
        bargeArrangement(counter3(1,currentBarge),6,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
        
        bargeArrangement(counter3(1,currentBarge),2,currentBarge) = datestr(vesselBerth(p,1));
        bargeArrangement(counter3(1,currentBarge),3,currentBarge) = datestr(vesselDepart(p,1));
        bargeArrangement(counter3(1,currentBarge),4,currentBarge) = vesselBunkertype(p,1);
        bargeArrangement(counter3(1,currentBarge),5,currentBarge) = vesselBunker(p,1);
        
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(vesselBerth(p,1));
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
        else
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);
        counter3(1,currentBarge) = counter3(1,currentBarge) + 1;
        if bargeAvailtime(currentBarge,1) > vesselDepart(p)
            break;
        end
    end
end
toc
%% Tabulate the results
tic
for r = 1:numBarge
    f = figure('Name',strcat("Barge ",num2str(r)),'NumberTitle','off','Position', [240 440-(r-1)*220 830 200]);
    t = uitable('Parent', f, 'Position', [0 -15 905 220], 'Data', cellstr(bargeArrangement(:,:,r)));
    t.ColumnWidth = {70, 120, 120, 70, 90, 120, 120, 120};
    t.ColumnName = {'Destination', 'Berth Time','Departure time','Bunker Type','Transfer Amount','Barge Arrival', 'Start Transfer', 'End Transfer'};
    t.RowName = [];
end
toc