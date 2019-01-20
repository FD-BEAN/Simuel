%% initialize features and results
format long

X = zeros(22050,20);
X_T = zeros(2,10);

bargeBunkeri = bargeInitialCapacity(1:3,1:3);
bargeTimei = bargeDetails(1:3,10);
vesselB = vesselDetails(:,4);
vesselD = vesselDetails(:,5);

for as = 1:assignValid
    
    currentSelection = bargeAssign(as,:);
    barge1 = find(currentSelection == 1);
    barge2 = find(currentSelection == 2);
    barge3 = find(currentSelection == 3);
    reindexing = [barge1, barge2,  barge3];
    
    bargeTime = bargeTimei;
    bargeBunker = bargeBunkeri;
    
    for re = reindexing
        currentBarge = currentSelection(1,re);
        bunkerType = vesselBunkertype(re,1);
        
        X_T(1,re) = vesselD(re,1) - bargeTime(currentBarge,1);
        X_T(2,re) = bargeBunker(currentBarge,bunkerType) - vesselBunker(re,1);
        
        if bargeBunker(currentBarge,bunkerType) <= 0
            timeAdded = (vesselBunker(re,1) * 0.15 / 60 + 3) * (0.125 / 3);
            bargeTime(currentBarge,1) = bargeTime(currentBarge,1) + timeAdded;
        else
            timeAdded = (vesselBunker(re,1) * 0.15 / 60 + 6 + (bargeBunkeri(currentBarge,bunkerType) - vesselBunker(re,1))*0.03) *(0.125/3);
            bargeTime(currentBarge,1) = bargeTime(currentBarge,1) + timeAdded;
        end
        bargeBunker(currentBarge,bunkerType) = bargeBunker(currentBarge,bunkerType) - vesselBunker(re,1);
%         timeAdded
    end
    X(as,:) = X_T(:)';
end

y = assignCheckBool;

%% optimize theta

[mm, nn] = size(X);
X = [ones(mm, 1) X];

initial_theta = zeros(nn + 1, 1);

options = optimset('GradObj', 'on', 'MaxIter', 500);
[theta, cost, EXITFLAG] = fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

%% predict using the same data

m = size(X, 1);

p = sigmoid(X * theta)>=0.5 ;

adds = 0;
for f = 1:22050
    if assignCheckBool(f,1) ==1 && assignCheckBool(f,1) == p(f,1)
        adds = adds + 1;
    end
end

disp(adds)
