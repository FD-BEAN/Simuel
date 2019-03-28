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

%% figure
%%% time and numerical axis cannot exist in one graph
figure('Name','Barge-Vessel Arrangements','NumberTitle','off','Position',[650 150 600 400])
xlabel('Vessel Number')
ylabel('Datetime')

set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]);
axis([0,16,datenum(vesselBerth(1))-0.5,datenum(vesselDepart(15))+0.5]);

for i = 1:15
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
