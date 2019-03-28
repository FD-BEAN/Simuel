%% Record arrangement of barges for the best assignment
tic

load graphgeneration.mat;

bargeCapacity = bargeInitialCapacity;
bargeAvailtime = bargeInitialAvailtime;

bargeArrangement = strings(10,8,numBarge);
combinedTable = strings(2*numVessel, 9);




% Assign = finalAssign;
Assign = [1,2,3,1,2,4,1,2,3,1,2,3,1,2,3];

vis = zeros(numVessel,6);
vis(:,2) = datenum(vesselDepart);
vis(:,3) = datenum(vesselBerth);
vis(:,5) = vesselBunkertype;
vis(:,6) = Assign;

vis_terminal = zeros(numVessel,2);

for p = 1:numVessel
    
    currentBarge = Assign(1,p);
    
    if bargeCapacity(currentBarge,vesselBunkertype(p,1)) >= vesselBunker(p,1)      
        bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetovessel;
        
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);
            
            vis(p,1) = datenum(vesselBerth(p,1));
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
            
        else            
            vis(p,1) = datenum(bargeAvailtime(currentBarge,1));
            
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);
            
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
            
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);

    else
        topup = minutes(0.03 * (bargeInitialCapacity(currentBarge,vesselBunkertype(p,1)) - bargeCapacity(currentBarge,vesselBunkertype(p,1))));
        
        vis_terminal(p,1) = datenum(bargeAvailtime(currentBarge,1));
        
        bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetoterminal + timetovessel + topup;
        
        vis_terminal(p,2) = datenum(bargeAvailtime(currentBarge,1));
        
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeInitialCapacity(currentBarge,vesselBunkertype(p,1));
        
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);
            
            vis(p,1) = datenum(vesselBerth(p,1));
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
            
        else
            vis(p,1) = datenum(bargeAvailtime(currentBarge,1));
            
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);
            
            vis(p,4) = datenum(bargeAvailtime(currentBarge,1));
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);

    end
end
toc

%% figure
figure('Name','Barge-Vessel Arrangements','NumberTitle','off','Position',[650 150 600 400])
xlabel('Vessel Number')
ylabel('Datetime')

set(gca,'xtick',1:numVessel);
axis([0,16,datenum(vesselBerth(1))-0.5,datenum(vesselDepart(15))+0.5]);

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

for j = 1:15
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

