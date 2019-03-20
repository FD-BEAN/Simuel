% do not pregenerate assignments
% 15 vessels

%% initialization of parameters/variables
clear;clc;
%% initialization of parameters/variables
tic
numBarge = 4;

timetoterminal = duration('03:00:00');
timetovessel = duration('03:00:00');

% Read the details of barge from excel for easier management
[bargeDetails, bargetxt, rawbargedata] = xlsread('bargeDetails11.xlsx');
bargeInitialCapacity = bargeDetails(1:4,3:8);
bargeInitialAvailtime = datetime(datestr(bargeDetails(1:4,10) + datenum('30-Dec-1899')));

% load the details of vessel from excel
[vesselDetails, vesseltxt, rawCelldata] = xlsread('vesselDetails_15_nd.xlsx');
numVessel = length(vesselDetails(:,1));
vesselBerth = datetime(datestr(vesselDetails(:,4) + datenum('30-Dec-1899')));
vesselDepart = datetime(datestr(vesselDetails(:,5) + datenum('30-Dec-1899')));
% assume each vessel requires only one type of oil
vesselBunker = vesselDetails(:,7);
vesselBunkertype = vesselDetails(:,6);
vesselTransfertime = minutes(vesselDetails(:,8));
%
% scatter(1:numVessel,vesselBerth);
% hold on;
% scatter(1:numVessel,vesselDepart);
% toc
%% Constraints checks
tic

initAss = ones(1,numVessel);

saveAss = zeros(10000000,numVessel);

saveCount = 1;

stopPoint = 1;

bargeTempCapacity = bargeInitialCapacity;
bargeTempAvailtime = bargeInitialAvailtime;

while (initAss(1)+sum(initAss(14:15))) ~= (12)
    %     while (initAss(1) ~= 4)
    
    if saveAss(1,1) ~= 0
        if max(histcounts(initAss)) >= 7 || sum(diff([0 find(diff(initAss)) numel(initAss)]) >= 4) >= 1 || length(find(initAss == 1)) <= 3 || length(find(initAss == 2)) <= 3 || length(find(initAss == 3)) <= 3            
            %                     if max(histcounts(initAss)) >= 7 || length(find(initAss == 4)) >= 3
            if initAss(15) == 4
                for addOne = [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
                    if initAss(addOne) ~= 4
                        initAss(addOne) = initAss(addOne) + 1;
                        initAss(addOne+1:15) = 1;
                        stopPoint = 1;
                        break;
                    end
                end
            else
                initAss(15) = initAss(15) + 1;
            end
                        
            continue;
        end
    end
    
    if stopPoint == 1
        bargeCapacity = bargeInitialCapacity;
        bargeAvailtime = bargeInitialAvailtime;
    else
        bargeCapacity = bargeTempCapacity;
        bargeAvailtime = bargeTempAvailtime;
    end
    
    
    
    
    for k = stopPoint:numVessel
        
        bargeTempCapacity = bargeCapacity;
        bargeTempAvailtime = bargeAvailtime;
        
        currentBarge = initAss(1,k);
        
        if currentBarge == 4
            stopPoint = stopPoint + 1;
            if stopPoint == 16
                stopPoint = 1;
                saveAss(saveCount,:) = initAss;
                saveCount = saveCount + 1;
                for addOne = [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
                    if initAss(addOne) ~= 4
                        initAss(addOne) = initAss(addOne) + 1;
                        initAss(addOne+1:15) = 1;
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
                
                stopPoint = stopPoint + 1;
            else
                %check first number until the stop point if they are the same
                
                
                initAss(stopPoint) = initAss(stopPoint) + 1;
                initAss(stopPoint+1:15) = 1;
                
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
                
                stopPoint = stopPoint + 1;
                
            else
                
                
                initAss(stopPoint) = initAss(stopPoint) + 1;
                initAss(stopPoint+1:15) = 1;
                
                break
            end
        end
        
        if stopPoint == 16
            stopPoint = 1;
            saveAss(saveCount,:) = initAss;
            saveCount = saveCount + 1;
            for addOne = [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
                if initAss(addOne) ~= 4
                    initAss(addOne) = initAss(addOne) + 1;
                    initAss(addOne+1:15) = 1;
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

fuelProfit =30;

assignFeasible = saveCount - 1;
profitAssign = zeros(assignFeasible, 1);

for m = 1:assignFeasible
    profitBarges = zeros(1,numBarge);
    currentAssignment = saveAss(m,:);
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
finalAssign = saveAss(best_assign,:);
toc
%% Record arrangement of barges for the best assignment
tic
bargeCapacity = bargeInitialCapacity;
bargeAvailtime = bargeInitialAvailtime;

bargeArrangement = strings(10,8,numBarge);
counter3 = [1, 1, 1, 1];

vis = zeros(15,6);
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
    f = figure('Name',strcat("Barge ",num2str(r)),'NumberTitle','off','Position', [240 440-(r-1)*170 830 200]);
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

set(gca,'xtick',1:numVessel);
axis([0,numVessel+1,datenum(vesselBerth(1))-0.5,datenum(vesselDepart(15))+0.5]);

for i = 1:15
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

