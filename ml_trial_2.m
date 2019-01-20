%% initialize features and results
format long

X = bargeAssign;

y = assignCheckBool;

%% optimize theta

[mm, nn] = size(X);
X = [ones(mm, 1) X];

initial_theta = zeros(nn + 1, 1);
[cost, grad] = costFunction(initial_theta, X, y);

options = optimset('GradObj', 'on', 'MaxIter', 400);
[theta, cost] = fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

%% predict using the same data

m = size(X, 1);
p = sigmoid(X * theta)>=0.5 ;
percentCorrect = mean(double(p == y)) * 100