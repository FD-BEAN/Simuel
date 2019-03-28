%% Record arrangement of barges for the best assignment
tic

load tablegeneration.mat;

bargeCapacity = bargeInitialCapacity;
bargeAvailtime = bargeInitialAvailtime;

bargeArrangement = strings(10,8,numBarge);
combinedTable = strings(2*numVessel, 9);

counter4 = 1;
counter3 = [1, 1, 1, 1];

vis = zeros(numVessel,6);
vis(:,2) = datenum(vesselDepart);
vis(:,3) = datenum(vesselBerth);
vis(:,5) = vesselBunkertype;
vis(:,6) = finalAssign;

vis_terminal = zeros(10,2);

% Assign = finalAssign;
Assign = [1,2,3,1,2,4,1,2,3,1,2,3,1,2,3];

for p = 1:numVessel
    
    currentBarge = Assign(1,p);
    
    if currentBarge == 4
        combinedTable(counter4,1) = strcat("vessel",num2str(p));
        combinedTable(counter4,2) = 4;
        combinedTable(counter4,3) = "Nil";
        combinedTable(counter4,4) = "Nil";
        combinedTable(counter4,5) = vesselBunkertype(p);
        combinedTable(counter4,6) = vesselBunker(p);
        combinedTable(counter4,7) = "Nil";
        combinedTable(counter4,8) = "Nil";
        combinedTable(counter4,9) = "Nil";
        counter4 = counter4 + 1;
        continue;
    end
    
    combinedTable(counter4,2) = currentBarge;
    
    if bargeCapacity(currentBarge,vesselBunkertype(p,1)) >= vesselBunker(p,1)
        
        bargeArrangement(counter3(1,currentBarge),2,currentBarge) = datestr(vesselBerth(p,1));
        bargeArrangement(counter3(1,currentBarge),3,currentBarge) = datestr(vesselDepart(p,1));
        bargeArrangement(counter3(1,currentBarge),4,currentBarge) = vesselBunkertype(p,1);
        bargeArrangement(counter3(1,currentBarge),5,currentBarge) = vesselBunker(p,1);
        
        combinedTable(counter4,3) = datestr(vesselBerth(p));
        combinedTable(counter4,4) = datestr(vesselDepart(p));
        combinedTable(counter4,5) = vesselBunkertype(p,1);
        combinedTable(counter4,6) = vesselBunker(p,1);
        
        bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetovessel;
        
        bargeArrangement(counter3(1,currentBarge),1,currentBarge) = strcat("vessel",num2str(p));
        bargeArrangement(counter3(1,currentBarge),6,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
        
        combinedTable(counter4,1) = strcat("vessel",num2str(p));
        combinedTable(counter4,7) = datestr(bargeAvailtime(currentBarge));
        
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(vesselBerth(p,1));
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            combinedTable(counter4,8) = datestr(vesselBerth(p));
            combinedTable(counter4,9) = datestr(bargeAvailtime(currentBarge));
            
            vis(p,1) = datenum(vesselBerth(p,1));
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
            
        else
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            combinedTable(counter4,8) = datestr(bargeAvailtime(currentBarge));
            
            vis(p,1) = datenum(bargeAvailtime(currentBarge,1));
            
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            combinedTable(counter4,9) = datestr(bargeAvailtime(currentBarge));
            
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
            
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);
        counter3(1,currentBarge) = counter3(1,currentBarge) + 1;
        counter4 = counter4 + 1;
    else
        bargeArrangement(counter3(1,currentBarge),1,currentBarge) = "Terminal";
        bargeArrangement(counter3(1,currentBarge),6,currentBarge) = datestr(bargeAvailtime(currentBarge,1) + timetoterminal);
        bargeArrangement(counter3(1,currentBarge),7,currentBarge) = bargeArrangement(counter3(1,currentBarge),6,currentBarge);
        
        bargeArrangement(counter3(1,currentBarge),2,currentBarge) = "Nil";
        bargeArrangement(counter3(1,currentBarge),3,currentBarge) = "Nil";
        bargeArrangement(counter3(1,currentBarge),4,currentBarge) = vesselBunkertype(p,1);
        bargeArrangement(counter3(1,currentBarge),5,currentBarge) = bargeInitialCapacity(currentBarge,vesselBunkertype(p,1)) - bargeCapacity(currentBarge,vesselBunkertype(p,1));
        
        combinedTable(counter4,1) = "Terminal";
        combinedTable(counter4,2) = currentBarge;
        combinedTable(counter4,3) = "Nil";
        combinedTable(counter4,4) = "Nil";
        combinedTable(counter4,5) = vesselBunkertype(p);
        combinedTable(counter4,6) = bargeInitialCapacity(currentBarge,vesselBunkertype(p)) - bargeCapacity(currentBarge,vesselBunkertype(p));
        combinedTable(counter4,7) = datestr(bargeAvailtime(currentBarge,1) + timetoterminal);
        combinedTable(counter4,8) = combinedTable(counter4,7);
        
        topup = minutes(0.03 * (bargeInitialCapacity(currentBarge,vesselBunkertype(p,1)) - bargeCapacity(currentBarge,vesselBunkertype(p,1))));
        
        bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1) + timetoterminal + topup);
        counter3(1,currentBarge) = counter3(1,currentBarge)+1;
        
        combinedTable(counter4,9) = datestr(bargeAvailtime(currentBarge) + timetoterminal + topup);
        counter4 = counter4 + 1;
        
        vis_terminal(p,1) = datenum(bargeAvailtime(currentBarge,1));
        
        bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetoterminal + timetovessel + topup;
        
        vis_terminal(p,2) = datenum(bargeAvailtime(currentBarge,1));
        
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeInitialCapacity(currentBarge,vesselBunkertype(p,1));
        bargeArrangement(counter3(1,currentBarge),1,currentBarge) = strcat("vessel",num2str(p));
        bargeArrangement(counter3(1,currentBarge),6,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
        
        bargeArrangement(counter3(1,currentBarge),2,currentBarge) = datestr(vesselBerth(p,1));
        bargeArrangement(counter3(1,currentBarge),3,currentBarge) = datestr(vesselDepart(p,1));
        bargeArrangement(counter3(1,currentBarge),4,currentBarge) = vesselBunkertype(p,1);
        bargeArrangement(counter3(1,currentBarge),5,currentBarge) = vesselBunker(p,1);
        
        combinedTable(counter4,1) = strcat("vessel",num2str(p));
        combinedTable(counter4,2) = currentBarge;
        combinedTable(counter4,3) = datestr(vesselBerth(p,1));
        combinedTable(counter4,4) = datestr(vesselDepart(p,1));
        combinedTable(counter4,5) = vesselBunkertype(p);
        combinedTable(counter4,6) = vesselBunker(p,1);
        combinedTable(counter4,7) = datestr(bargeAvailtime(currentBarge,1));
        
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(vesselBerth(p,1));
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            combinedTable(counter4,8) = datestr(vesselBerth(p,1));
            combinedTable(counter4,9) = datestr(bargeAvailtime(currentBarge));
            
            vis(p,1) = datenum(vesselBerth(p,1));
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
            
        else
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            combinedTable(counter4,8) = datestr(bargeAvailtime(currentBarge));
            
            vis(p,1) = datenum(bargeAvailtime(currentBarge,1));
            
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            combinedTable(counter4,9) = datestr(bargeAvailtime(currentBarge));
            
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);
        counter3(1,currentBarge) = counter3(1,currentBarge) + 1;
        counter4 = counter4 + 1;
    end
end
toc
%% Tabulate the best arrangement
for r = 1:numBarge-1
    f = figure('Name',strcat("Barge ",num2str(r)),'NumberTitle','off','Position', [340 440-(r-1)*220 680 200]);
    t = uitable('Parent', f, 'Position', [0 -15 905 220], 'Data', cellstr(bargeArrangement(:,:,r)));
    t.ColumnWidth = {60, 110, 110, 30, 40, 110, 110, 110};
    t.ColumnName = {'Destination', 'Berth Time','Departure time','Type','Amount','Barge Arrival', 'Start Transfer', 'End Transfer'};
    t.RowName = [];
end

%% Combined table
f1 = figure('Name','Schedule','NumberTitle','off','Position', [320 150 710 400]);
t1 = uitable('Parent', f1, 'Position', [0 -15 905 420], 'Data', cellstr(combinedTable(:,:)));
t1.ColumnWidth = {60, 30, 110, 110, 30, 40, 110, 110, 110};
t1.ColumnName = {'Destination','Barge', 'Berth Time','Departure time', 'Type','Amount','Barge Arrival', 'Start Transfer', 'End Transfer'};
t1.RowName = [];
