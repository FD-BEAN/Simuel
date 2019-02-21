% do not pregenerate assignments

%% initialization of parameters/variables
clear;clc;
load('C:\Users\SF314-51-71UP\Documents\MATLAB\data_1234123123.mat');
%% Constraints checks
tic

initAss = [1 1 1 1 1 1 1 1 1 1];

saveAss = zeros(1000000,10);


saveCount = 1;
stopPoint = 0;

while (sum(initAss) ~= 40)
    
    if saveAss(1,1) ~= 0
        if max(histcounts(initAss)) >= 5 || length(find(initAss == 4)) >= 3
            if initAss(10) == 4
                for addOne = [10 9 8 7 6 5 4 3 2 1]
                    if initAss(addOne) ~= 4
                        initAss(addOne) = initAss(addOne) + 1;
                        initAss(addOne+1:10) = 1;
                        break;
                    end
                end
            else
                initAss(10) = initAss(10) + 1;
            end
            continue;
        end
    end
    
    if stopPoint < 5
        bargeCapacity = bargeInitialCapacity;
        bargeAvailtime = bargeInitialAvailtime;
        start = 1;
        stopPoint = 0;
        jplusCriteria = 1;
    else
        bargeCapacity = bargeTempCapacity;
        bargeAvailtime = bargeTempAvailtime;
        start = 5;
        stopPoint = 4;
        jplusCriteria = 5;
    end
    
    for k = start:numVessel
        
        if stopPoint == 4
            bargeTempCapacity = bargeCapacity;
            bargeTempAvailtime = bargeAvailtime;
        end
        
        stopPoint = stopPoint + 1;
        currentBarge = initAss(1,k);
        
        if currentBarge == 4
            jplusCriteria = jplusCriteria + 1;
            if jplusCriteria == 11
                saveAss(saveCount,:) = initAss;
                saveCount = saveCount + 1;
                stopPoint = 0;
                for addOne = [10 9 8 7 6 5 4 3 2 1]
                    
                    if addOne == 6
                        stopPoint = 0;
                    end
                    
                    if initAss(addOne) ~= 4
                        initAss(addOne) = initAss(addOne) + 1;
                        initAss(addOne+1:10) = 1;
                        break;
                    end
                end
            end
            continue
        end
        % check if bunker on the barge is enough for this transfer
        if bargeCapacity(currentBarge,vesselBunkertype(k,1)) >= vesselBunker(k,1)
            % check if the barge available time is earlier than the latest time possible to start transfering oil
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetovessel;
            if (vesselDepart(k,1) - vesselTransfertime(k,1)) >= bargeAvailtime(currentBarge,1)
                if bargeAvailtime(currentBarge,1) < vesselBerth(k,1)
                    bargeAvailtime(currentBarge,1) = vesselBerth(k,1) + vesselTransfertime(k,1);
                else
                    bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(k,1);
                end
                bargeCapacity(currentBarge,vesselBunkertype(k,1)) = bargeCapacity(currentBarge,vesselBunkertype(k,1)) - vesselBunker(k,1);
                
                jplusCriteria = jplusCriteria + 1;
            else
                %check first number until the stop point if they are the same
                
                if initAss(stopPoint) == 4
                    initAss(stopPoint) = 1;
                    initAss(stopPoint+1:10) = 1;
                else
                    initAss(stopPoint) = initAss(stopPoint) + 1;
                    initAss(stopPoint+1:10) = 1;
                end
                break
            end
            
        else
            topup = minutes(0.03 * (bargeInitialCapacity(currentBarge,vesselBunkertype(k,1)) - bargeCapacity(currentBarge,vesselBunkertype(k,1))));
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetoterminal + timetovessel + topup;
            % update the new oil amount for current barge
            bargeCapacity(currentBarge,vesselBunkertype(k,1)) = bargeInitialCapacity(currentBarge,vesselBunkertype(k,1));
            if (vesselDepart(k,1) - vesselTransfertime(k,1)) >= bargeAvailtime(currentBarge,1)
                if bargeAvailtime(currentBarge,1) < vesselBerth(k,1)
                    bargeAvailtime(currentBarge,1) = vesselBerth(k,1) + vesselTransfertime(k,1);
                else
                    bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(k,1);
                end
                bargeCapacity(currentBarge,vesselBunkertype(k,1)) = bargeCapacity(currentBarge,vesselBunkertype(k,1)) - vesselBunker(k,1);
                
                jplusCriteria = jplusCriteria + 1;
                
            else
                
                if initAss(stopPoint) == 4
                    initAss(stopPoint) = 1;
                    initAss(stopPoint+1:10) = 1;
                else
                    initAss(stopPoint) = initAss(stopPoint) + 1;
                    initAss(stopPoint+1:10) = 1;
                end
                break
            end
        end
        
        if jplusCriteria == 11
            saveAss(saveCount,:) = initAss;
            saveCount = saveCount + 1;
            stopPoint = 0;
            for addOne = [10 9 8 7 6 5 4 3 2 1]
                if addOne == 6
                    stopPoint = 0;
                end
                
                if initAss(addOne) ~= 4
                    initAss(addOne) = initAss(addOne) + 1;
                    initAss(addOne+1:10) = 1;
                    break;
                end
            end
        end
        
    end
end
toc
%% Objective function evaluation
tic
% create an array indexing all feasible assignments from assignBarge cell

counter = 1;
for i = 1:(saveCount-1)
    if max(histcounts(saveAss(i,:))) < threshold && length(find(saveAss(i,:) == 4)) < 4
        assignFiltered(counter,:) = saveAss(i,:);
        counter = counter + 1;
    end
end

fuelProfit =30;

assignFeasible = length(assignFiltered);
profitAssign = zeros(assignFeasible, 1);

for m = 1:assignFeasible
    profitBarges = zeros(1,numBarge);
    currentAssignment = assignFiltered(m,:);
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
finalAssign = assignFiltered(best_assign,:);
toc
%% Record arrangement of barges for the best assignment
tic
bargeCapacity = bargeInitialCapacity;
bargeAvailtime = bargeInitialAvailtime;

bargeArrangement = strings(10,8,numBarge);
counter3 = [1, 1, 1, 1];

vis = zeros(10,6);
vis(:,2) = datenum(vesselDepart);
vis(:,3) = datenum(vesselBerth);
vis(:,5) = vesselBunkertype;
vis(:,6) = finalAssign';

vis_terminal = zeros(10,2);

Assign = finalAssign;
% Assign = [1,1,2,1,4,2,4,3,4,1];

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
            
            vis(p,1) = datenum(vesselBerth(p,1));
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
            
        else
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            vis(p,1) = datenum(bargeAvailtime(currentBarge,1));
            
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
            
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);
        counter3(1,currentBarge) = counter3(1,currentBarge) + 1;
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
        
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(vesselBerth(p,1));
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            vis(p,1) = datenum(vesselBerth(p,1));
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
            
        else
            bargeArrangement(counter3(1,currentBarge),7,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            vis(p,1) = datenum(bargeAvailtime(currentBarge,1));
            
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3(1,currentBarge),8,currentBarge) = datestr(bargeAvailtime(currentBarge,1));
            
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);
        counter3(1,currentBarge) = counter3(1,currentBarge) + 1;
    end
end
toc
%% Tabulate the best arrangement
tic
for r = 1:numBarge
    f = figure('Position', [240 440-(r-1)*170 830 200]);
    t = uitable('Parent', f, 'Position', [0 -15 905 220], 'Data', cellstr(bargeArrangement(:,:,r)));
    t.ColumnWidth = {70, 120, 120, 70, 90, 120, 120, 120};
    t.ColumnName = {'Destination', 'Berth Time','Departure time','Bunker Type','Bunker Amount','Barge Arrival', 'Start Transfer', 'End Transfer'};
    t.RowName = [];
end
toc

%% figure
%%% time and numerical axis cannot exist in one graph
figure('Name','Barge-Vessel Arrangements','NumberTitle','off','Position',[650 150 600 400])
xlabel('Vessel Number')
ylabel('Datetime')
yLabel = datestr(7.370612e+05:0.000002e+05:7.370632e+05,31);
set(gca,'YTickLabel',yLabel);
set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10]);
axis([0,11,737061.2,737063.2]);
for i = 1:10
    if vis(i,6) == 4
        text(i-0.6,(vis(i,2)+vis(i,3))/2,'Dummy')
        plot([i,i],[vis(i,2),vis(i,3)],'LineWidth',4,'color','b')
        text(i-0.1,vis(i,3)-0.05,num2str(vis(i,5)),'color','b')
    else
        rectangle('Position',[i-0.25,vis(i,1),0.5,vis(i,4)-vis(i,1)],'EdgeColor','k','LineWidth',2)
        text(i-0.1,(vis(i,4)+vis(i,1))/2,num2str(vis(i,6)))
        hold on
        plot([i,i],[vis(i,1),vis(i,3)],'LineWidth',4,'color','b')
        plot([i,i],[vis(i,2),vis(i,4)],'LineWidth',4,'color','b')
        text(i-0.1,vis(i,3)-0.05,num2str(vis(i,5)),'color','b')
    end
end

for j = 1:10
    if vis_terminal(j,1) ~= 0
        rectangle('Position',[j-0.25,vis_terminal(j,1),0.5,vis_terminal(j,2)-vis_terminal(j,1)],'FaceColor','r','LineWidth',2)
    end
end


figure('Name','Legend','NumberTitle','off','Position',[30 150 600 400])
rectangle('Position',[4.75,2,0.5,1],'LineWidth',2)
rectangle('Position',[4.75,1.5,0.5,0.5],'FaceColor','r','LineWidth',2)
hold on
plot([5,5],[3,4],'LineWidth',4,'color','b')
plot([5,5],[1,1.5],'LineWidth',4,'color','b')
xlim([0 10]);
ylim([0 5]);
set(gca,'ytick',[1 2 3 4 5]);
set(gca,'YTickLabel',yLabel);
text(1.8,4, 'vessel depart time');
text(1.8,1, 'vessel arrival time');
text(1.8,2, 'start transfer time');
text(1.8,3, 'end transfer time');
text(4.9,2.5,'1');
text(5.5,2.5,'Barge number');
text(5.5,1.75,'Terminal Topup');
text(4.9,0.85,'1','color','b');
text(5.5,0.85,'Bunker Type')%% figure

