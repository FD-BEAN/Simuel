numBarge = 4;

timetoterminal = duration('03:00:00');
timetovessel = duration('03:00:00');

% Read the details of barge from excel for easier management
[bargeDetails, bargetxt, rawbargedata] = xlsread('bargeDetails12.xlsx');
bargeInitialCapacity = bargeDetails(1:4,3:8);
bargeInitialAvailtime = datetime(datestr(bargeDetails(1:4,10) + datenum('30-Dec-1899')));

% Read the details of vessel from excel for easier management
[vesselDetails, vesseltxt, rawCelldata] = xlsread('vesselDetails12.xlsx');
numVessel = length(vesselDetails(:,1));
vesselBerth = datetime(datestr(vesselDetails(:,4) + datenum('30-Dec-1899')));
vesselDepart = datetime(datestr(vesselDetails(:,5) + datenum('30-Dec-1899')));
% assume each vessel requires only one type of oil
vesselBunker = vesselDetails(:,7);
vesselBunkertype = vesselDetails(:,6);
vesselTransfertime = minutes(vesselDetails(:,8));

scatter(1:10,vesselBerth,'o');
hold on;
scatter(1:10,vesselDepart,'o');

scatter(5,bargeInitialAvailtime(1)+hours(18),'r*');
scatter(5,bargeInitialAvailtime(2)+hours(18),'k*');
scatter(5,bargeInitialAvailtime(3)+hours(18),'b*');
scatter(5,bargeInitialAvailtime(1)+hours(30),'r*');
scatter(5,bargeInitialAvailtime(2)+hours(33)+minutes(144),'k*');
scatter(5,bargeInitialAvailtime(3)+hours(31),'b*');

