%% Record arrangement of barges for the best assignment
tic
bargeCapacity = bargeInitialCapacity;
bargeAvailtime = bargeInitialAvailtime;
bargeLocation = bargeInitialLocation;

bargeArrangement = strings(10,4,numBarge);
counter3 = ones(4,1);

% Assign = finalAssign;
Assign = [1,1,2,1,4,2,4,3,4,1];

for p = 1:numVessel
    
    currentBarge = Assign(1,p);
    if bargeCapacity(currentBarge,vesselBunkertype(p,1)) >= vesselBunker(p,1)
        bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetovessel;
        bargeArrangement(counter3,1,currentBarge) = strcat("vessel",num2str(p));
        bargeArrangement(counter3,2,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
        
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);          
            bargeArrangement(counter3,3,currentBarge) = datestr(vesselBerth(p,1));
            bargeArrangement(counter3,4,currentBarge) = datestr(bargeAvailtime(currentBarge,1));    
        else         
            bargeArrangement(counter3,3,currentBarge) = datestr(bargeAvailtime(currentBarge,1)); 
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);          
            bargeArrangement(counter3,4,currentBarge) = datestr(bargeAvailtime(currentBarge,1));      
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1); 
        counter3 = counter3 + 1;
    else   
        bargeArrangement(counter3,1,currentBarge) = "Terminal";
        bargeArrangement(counter3,2,currentBarge) = datestr(bargeAvailtime(currentBarge,1) + timetoterminal);
        bargeArrangement(counter3,3,currentBarge) = bargeArrangement(p,2,currentBarge);
        
        topup = minutes(0.03 * (bargeInitialCapacity(currentBarge,vesselBunkertype(p,1)) - bargeCapacity(currentBarge,vesselBunkertype(p,1))));
        
        bargeArrangement(counter3,4,currentBarge) = datestr(bargeAvailtime(currentBarge,1) + timetoterminal + topup);
        counter3 = counter3+1;    
        bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetoterminal + timetovessel + topup;
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeInitialCapacity(currentBarge,vesselBunkertype(p,1));     
        bargeArrangement(counter3,1,currentBarge) = strcat("vessel",num2str(p));
        bargeArrangement(counter3,2,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
        
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);         
            bargeArrangement(counter3,3,currentBarge) = datestr(vesselBerth(p,1));
            bargeArrangement(counter3,4,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
        else
            
            bargeArrangement(counter3,3,currentBarge) = datestr(bargeAvailtime(currentBarge,1));           
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);           
            bargeArrangement(counter3,4,currentBarge) = datestr(bargeAvailtime(currentBarge,1));   
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);
       couter3 = counter3 + 1;
    end
end
toc
%% Tabulate the best arrangement
tic
for r = 1:numBarge
    f = figure('Position', [400 200 440 250]);
    t = uitable('Parent', f, 'Position', [0 50 440 200], 'Data', cellstr(bargeArrangement(:,:,r)));
    t.ColumnWidth = {60, 120, 120, 120};
    t.ColumnName = {'Location', 'Arrival time', 'Start Transfer', 'End Transfer'};
    t.RowName = [];
end
toc