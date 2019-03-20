%%
clear;clc;
%% initialization of parameters/variables
tic
numBarge = 3;

timetoterminal = duration('03:00:00');
timetovessel = duration('03:00:00');

% Read the details of barge from excel for easier management
[bargeDetails, bargetxt, rawbargedata] = xlsread('bargeDetails11.xlsx');
bargeInitialCapacity = bargeDetails(1:4,3:8);
bargeInitialAvailtime = datetime(datestr(bargeDetails(1:4,10) + datenum('30-Dec-1899')));

% Read the details of vessel from excel for easier management
[vesselDetails, vesseltxt, rawCelldata] = xlsread('vesselDetails11.xlsx');
numVessel = length(vesselDetails(:,1));
vesselBerth = datetime(datestr(vesselDetails(:,4) + datenum('30-Dec-1899')));
vesselDepart = datetime(datestr(vesselDetails(:,5) + datenum('30-Dec-1899')));
% assume each vessel requires only one type of oil
vesselBunker = vesselDetails(:,7);
vesselBunkertype = vesselDetails(:,6);
vesselTransfertime = minutes(vesselDetails(:,8));
toc
%% Record arrangement of barges for the best assignment
tic
bargeCapacity = bargeInitialCapacity;
bargeAvailtime = bargeInitialAvailtime;

bargeArrangement = strings(20,6);
counter3 = 1;

% Assign = [1];
Assign = [1 2 3 1 2 3 1 2 3 1];                 %%% change the numbers in Assign[]

len = length(Assign);

for p = 1:len
    currentBarge = Assign(p);
    
    bargeArrangement(counter3,2) = currentBarge;
    
    if bargeCapacity(currentBarge,vesselBunkertype(p,1)) >= vesselBunker(p,1)
        
        bargeArrangement(counter3,3) = datestr(vesselBerth(p,1));
        bargeArrangement(counter3,4) = datestr(vesselDepart(p,1));
       
        bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetovessel;
        bargeArrangement(counter3,1) = strcat("vessel",num2str(p));
          
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3,5) = datestr(vesselBerth(p,1));
            bargeArrangement(counter3,6) = datestr(bargeAvailtime(currentBarge,1));
        else
            bargeArrangement(counter3,5) = datestr(bargeAvailtime(currentBarge,1));
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3,6) = datestr(bargeAvailtime(currentBarge,1));
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);
        counter3 = counter3 + 1;
    else
        bargeArrangement(counter3,1) = "Terminal";
        bargeArrangement(counter3,5) = datestr(bargeAvailtime(currentBarge,1) + timetoterminal);
        bargeArrangement(counter3,3) = "Nil";
        bargeArrangement(counter3,4) = "Nil";
            
        topup = minutes(0.03 * (bargeInitialCapacity(currentBarge,vesselBunkertype(p,1)) - bargeCapacity(currentBarge,vesselBunkertype(p,1))));
        
        bargeArrangement(counter3,6) = datestr(bargeAvailtime(currentBarge,1) + timetoterminal + topup);
        counter3 = counter3 + 1;
        bargeArrangement(counter3,2) = currentBarge;
        bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + timetoterminal + timetovessel + topup;
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeInitialCapacity(currentBarge,vesselBunkertype(p,1));
        bargeArrangement(counter3,1) = strcat("vessel",num2str(p));
        
        bargeArrangement(counter3,3) = datestr(vesselBerth(p,1));
        bargeArrangement(counter3,4) = datestr(vesselDepart(p,1));

        
        if bargeAvailtime(currentBarge,1) <= vesselBerth(p,1)
            bargeAvailtime(currentBarge,1) = vesselBerth(p,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3,5) = datestr(vesselBerth(p,1));
            bargeArrangement(counter3,6) = datestr(bargeAvailtime(currentBarge,1));
            
        else
            bargeArrangement(counter3,5) = datestr(bargeAvailtime(currentBarge,1));
            bargeAvailtime(currentBarge,1) = bargeAvailtime(currentBarge,1) + vesselTransfertime(p,1);
            bargeArrangement(counter3,6) = datestr(bargeAvailtime(currentBarge,1));
        end
        bargeCapacity(currentBarge,vesselBunkertype(p,1)) = bargeCapacity(currentBarge,vesselBunkertype(p,1)) - vesselBunker(p,1);
        counter3 = counter3 + 1;
    end
end
toc
%% Tabulate the best arrangement
tic

f = figure('Name','Schedule','NumberTitle','off','Position', [320 150 600 400]);
t = uitable('Parent', f, 'Position', [0 -15 905 420], 'Data', cellstr(bargeArrangement(:,:)));
t.ColumnWidth = {70, 50, 120, 120, 120, 120};
t.ColumnName = {'Destination','Barge', 'Berth Time','Departure time', 'Start Transfer', 'End Transfer'};
t.RowName = [];

toc