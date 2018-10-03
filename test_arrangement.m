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
