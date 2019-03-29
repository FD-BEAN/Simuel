%% initialization of parameters/variables
clear;clc;
%% initialization of parameters/variables
tic
numBarge = 4;

timetoterminal = duration('03:00:00');
timetovessel = duration('03:00:00');

% Read the details of barge from excel for easier management
[bargeDetails, bargetxt, rawbargedata] = xlsread('bargeperformance2.xlsx');
bargeInitialCapacity = bargeDetails(1:4,3:8);
bargeInitialAvailtime = datetime(datestr(bargeDetails(1:4,10) + datenum('30-Dec-1899')));

% Read the details of vessel from excel for easier management
[vesselDetails, vesseltxt, rawCelldata] = xlsread('vesselperformance2.xlsx');
numVessel = length(vesselDetails(:,1));
vesselBerth = datetime(datestr(vesselDetails(:,4) + datenum('30-Dec-1899')));
vesselDepart = datetime(datestr(vesselDetails(:,5) + datenum('30-Dec-1899')));
% assume each vessel requires only one type of oil
vesselBunker = vesselDetails(:,7);
vesselBunkertype = vesselDetails(:,6);
vesselTransfertime = minutes(vesselDetails(:,8));
load nodum.mat;
assignValid = length(bargeAssign);

scatter(1:numVessel,vesselBerth);
hold on;
scatter(1:numVessel,vesselDepart);
toc
%% Constraints checks
tic

assignCheckBool = ones(assignValid,1);
stopVessel = zeros(assignValid,1);

j= 1;
jplusCriteria = 1;

while (j <= assignValid )
    
    if assignCheckBool(j,1) == 0
        j = j + 1;
        continue;
    end
    
    stopPoint = 0;
    
    bargeCapacity = bargeInitialCapacity;
    bargeAvailtime = bargeInitialAvailtime;
    currentSelection = bargeAssign(j,:);
    
    
    
    jplusCriteria = 1;
    
    for k = 1:numVessel
        stopPoint = stopPoint + 1;
        currentBarge = currentSelection(1,k);
        
        
        
        if currentBarge == 4
            jplusCriteria = jplusCriteria + 1;
            if jplusCriteria == numVessel+1
                j = j + 1;
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
                assignCheckBool(j,1) = 1;
                
                jplusCriteria = jplusCriteria + 1;
            else
                assignCheckBool(j,1) = 0; % time constraint not satisfied
                stopVessel(j,1) = stopPoint;
                %check first number until the stop point if they are the same
                
                for t = j:assignValid
                    if bargeAssign(t,1:stopPoint) == currentSelection(1,1:stopPoint)
                        assignCheckBool(t,1) = 0;
                    else
                        break
                    end
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
                assignCheckBool(j,1) = 1;
                
                jplusCriteria = jplusCriteria + 1;
                
            else
                assignCheckBool(j,1) = 0;
                stopVessel(j,1) = stopPoint;
                
                for t = j:assignValid
                    if bargeAssign(t,1:stopPoint) == currentSelection(1,1:stopPoint)
                        assignCheckBool(t,1) = 0;
                    else
                        break
                    end
                end
                break
            end
        end
        
        if jplusCriteria == numVessel+1
            j = j + 1;
        end
        
    end
end
toc
%% Objective function evaluation
tic
% create an array indexing all feasible assignments from assignBarge cell
assignFiltered = find(assignCheckBool);

fuelProfit =30;

assignFeasible = length(assignFiltered);
profitAssign = zeros(assignFeasible, 1);

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
toc
%% Record arrangement of barges for the best assignment
tic
bargeCapacity = bargeInitialCapacity;
bargeAvailtime = bargeInitialAvailtime;

bargeArrangement = strings(10,8,numBarge);
combinedTable = strings(2*numVessel, 9);

counter4 = 1;
counter3 = [1, 1, 1, 1];


% 
Assign = finalAssign;    %uncomment this line and comment next line to see the actual results
% Assign = [1,2,3,1,2,4,1,2,3,1,2,3,1,2,3];

vis = zeros(numVessel,6);
vis(:,2) = datenum(vesselDepart);
vis(:,3) = datenum(vesselBerth);
vis(:,5) = vesselBunkertype;
vis(:,6) = Assign;

vis_terminal = zeros(numVessel,2);

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
for r = 1:3
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

%% figure
%%% time and numerical axis cannot exist in one graph
figure('Name','Barge-Vessel Arrangements','NumberTitle','off','Position',[650 150 600 400])
xlabel('Vessel Number')
ylabel('Datetime')

set(gca,'xtick',1:numVessel);
axis([0,numVessel+1,datenum(vesselBerth(1))-0.5,datenum(vesselDepart(numVessel))+0.5]);

for i = 1:numVessel
    if vis(i,6) == 4
        plot([i,i],[vis(i,2),vis(i,3)],'LineWidth',4,'color','b')
        text(i-0.1,vis(i,3)-0.05,num2str(vis(i,5)),'color','b')
        text(i-0.6,(vis(i,2)+vis(i,3))/2,'Dum','FontWeight','bold')
    else
        rectangle('Position',[i-0.25,vis(i,1),0.5,vis(i,4)-vis(i,1)],'EdgeColor','k','LineWidth',2)
        text(i-0.1,(vis(i,4)+vis(i,1))/2,num2str(vis(i,6)))
        hold on
        plot([i,i],[vis(i,1),vis(i,3)],'LineWidth',4,'color','b')
        plot([i,i],[vis(i,2),vis(i,4)],'LineWidth',4,'color','b')
        text(i-0.1,vis(i,3)-0.05,num2str(vis(i,5)),'color','b')
    end
end

for j = 1:numVessel
    if vis_terminal(j,1) ~= 0
        rectangle('Position',[j-0.25,vis_terminal(j,1),0.5,vis_terminal(j,2)-vis_terminal(j,1)],'EdgeColor','r','LineWidth',2)
    end
end

yLabel = datestr(cellfun(@str2num,get(gca,'YTickLabel'))*10^5,31);
set(gca,'YTickLabel',yLabel);
%% legend
figure('Name','Legend','NumberTitle','off','Position',[30 150 600 400])
rectangle('Position',[4.75,2,0.5,1],'LineWidth',2)
rectangle('Position',[4.75,1.5,0.5,0.5],'EdgeColor','r','LineWidth',2)
hold on
plot([5,5],[3,4],'LineWidth',4,'color','b')
plot([5,5],[1,2],'LineWidth',4,'color','b')
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