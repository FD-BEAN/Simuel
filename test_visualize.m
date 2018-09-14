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
