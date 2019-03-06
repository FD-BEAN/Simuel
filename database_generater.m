tic
clear all; clc;
%%
% base = permn([1,2,3,4],12);
% addon = permn([1,2,3,4],2);
%
% for i = 1:16
%     comb = [base, repmat(addon(i,:),16777216,1)];
%     save(['C:\Users\SF314-51-71UP\Desktop\14\comb' num2str(i) '.mat'],['comb']);
%     clear comb
% end
%
% for s = 1:16
%
%     a = load(['C:\Users\SF314-51-71UP\Desktop\14\comb' num2str(s) '.mat']);
%     f = fieldnames(a);
%     tertiary = a.(f{1});
%
%     assignDiscarded = zeros();
%     counter = 1;
%     l = length(tertiary);
%
%     threshold = 7;
%
%     for j = 1:l
%         if max(histcounts(tertiary(j,:))) >= threshold || sum(diff([0 find(diff(tertiary(j,:))) numel(tertiary(j,:))]) >= 4) >= 1 || length(find(tertiary(j,:) == 1)) <= 3 || length(find(tertiary(j,:) == 2)) <= 3 || length(find(tertiary(j,:) == 3)) <= 3
%             assignDiscarded(1,counter) = j;
%             counter = counter + 1;
%         end
%     end
%
%     % set the discarded rows to null (remove)
%     tertiary(assignDiscarded, :) = [];
%     save(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_' num2str(s) '.mat'],['tertiary']);
%
% end

%%
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_1.mat']);
% s1 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_2.mat']);
% s2 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_3.mat']);
% s3 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_4.mat']);
% s4 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_5.mat']);
% s5 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_6.mat']);
% s6 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_7.mat']);
% s7 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_8.mat']);
% s8 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_9.mat']);
% s9 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_10.mat']);
% s10 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_11.mat']);
% s11 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_12.mat']);
% s12 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_13.mat']);
% s13 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_14.mat']);
% s14 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_15.mat']);
% s15 = a.tertiary;
% a = load(['C:\Users\SF314-51-71UP\Desktop\14\tertiary_16.mat']);
% s16 = a.tertiary;
% data_14 = [s1; s2; s3; s4; s5; s6; s7; s8; s9; s10; s11; s12; s13; s14; s15; s16];

%%
% bargeAssign = data_14;
% assignDiscarded = zeros();
% counter = 1;
% l = length(bargeAssign);
%
% for i = 1:l
%     % threshold set at 5
%     if length(find(bargeAssign(i,:) == 4)) ~= 2
%         assignDiscarded(1,counter) = i;
%         counter = counter + 1;
%     end
% end
%
% % set the discarded rows to null (remove)
% bargeAssign(assignDiscarded, :) = [];
% save(['C:\Users\SF314-51-71UP\Desktop\14\two_dum.mat'],['bargeAssign']);

%%
% base = permn([1,2,3,4],12);
% addon_1 = [base, ones(16777216,1)];
% save(['C:\Users\SF314-51-71UP\Desktop\13\addon_1.mat'],['addon_1'],'-v7.3');
% addon_2 = [base, 2 * ones(16777216,1)];
% save(['C:\Users\SF314-51-71UP\Desktop\13\addon_2.mat'],['addon_2'],'-v7.3');
% addon_3 = [base, 3 * ones(16777216,1)];
% save(['C:\Users\SF314-51-71UP\Desktop\13\addon_3.mat'],['addon_3'],'-v7.3');
% addon_4 = [base, 4 * ones(16777216,1)];
% save(['C:\Users\SF314-51-71UP\Desktop\13\addon_4.mat'],['addon_4'],'-v7.3');

%%
% load C:\Users\SF314-51-71UP\Desktop\13\addon_4.mat;
% assignDiscarded = zeros();
% counter = 1;
% l = length(addon_4);
%
% for i = 1:l
%     % threshold set at 5
%     if length(find(addon_4(i,:) == 4)) ~= 2
%         assignDiscarded(1,counter) = i;
%         counter = counter + 1;
%     end
% end
% % set the discarded rows to null (remove)
% addon_4(assignDiscarded, :) = [];
% save(['C:\Users\SF314-51-71UP\Desktop\13\temp42.mat'],['addon_4']);

% %%
% load(['C:\Users\SF314-51-71UP\Desktop\13\temp10.mat']);
% load(['C:\Users\SF314-51-71UP\Desktop\13\temp20.mat']);
% load(['C:\Users\SF314-51-71UP\Desktop\13\temp30.mat']);
% load(['C:\Users\SF314-51-71UP\Desktop\13\temp40.mat']);
% bargeAssign = [addon_1;addon_2;addon_3;addon_4];
%
% %%
%     assignDiscarded = zeros();
%     counter = 1;
%     l = length(bargeAssign);
%
%
%     for j = 1:l
%         if max(histcounts(bargeAssign(j,:))) >= 6 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 1)) <= 2 || length(find(bargeAssign(j,:) == 2)) <= 2 || length(find(bargeAssign(j,:) == 3)) <= 2
%             assignDiscarded(1,counter) = j;
%             counter = counter + 1;
%         end
%     end
%
%     % set the discarded rows to null (remove)
%     bargeAssign(assignDiscarded, :) = [];
%     save(['C:\Users\SF314-51-71UP\Desktop\13\no_dum.mat'],['bargeAssign']);


%%
% bargeAssign = permn([1,2,3,4],12);
% assignDiscarded = zeros();
% counter = 1;
% l = length(bargeAssign);
% 
% 
% for j = 1:l
%     if max(histcounts(bargeAssign(j,:))) >= 6 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 1)) <= 2 || length(find(bargeAssign(j,:) == 2)) <= 2 || length(find(bargeAssign(j,:) == 3)) <= 2 || length(find(bargeAssign(j,:) == 4)) ~= 0
%         assignDiscarded(1,counter) = j;
%         counter = counter + 1;
%     end
% end
% 
% % set the discarded rows to null (remove)
% bargeAssign(assignDiscarded, :) = [];
% save(['C:\Users\SF314-51-71UP\Desktop\12\no_dum.mat'],['bargeAssign']);
% 
% bargeAssign = permn([1,2,3,4],12);
% assignDiscarded = zeros();
% counter = 1;
% l = length(bargeAssign);
% 
% 
% for j = 1:l
%     if max(histcounts(bargeAssign(j,:))) >= 6 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 1)) <= 2 || length(find(bargeAssign(j,:) == 2)) <= 2 || length(find(bargeAssign(j,:) == 3)) <= 2 || length(find(bargeAssign(j,:) == 4)) ~= 1
%         assignDiscarded(1,counter) = j;
%         counter = counter + 1;
%     end
% end
% 
% % set the discarded rows to null (remove)
% bargeAssign(assignDiscarded, :) = [];
% save(['C:\Users\SF314-51-71UP\Desktop\12\one_dum.mat'],['bargeAssign']);
% 
% bargeAssign = permn([1,2,3,4],12);
% assignDiscarded = zeros();
% counter = 1;
% l = length(bargeAssign);
% 
% 
% for j = 1:l
%     if max(histcounts(bargeAssign(j,:))) >= 6 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 1)) <= 2 || length(find(bargeAssign(j,:) == 2)) <= 2 || length(find(bargeAssign(j,:) == 3)) <= 2 || length(find(bargeAssign(j,:) == 4)) ~= 2
%         assignDiscarded(1,counter) = j;
%         counter = counter + 1;
%     end
% end
% 
% % set the discarded rows to null (remove)
% bargeAssign(assignDiscarded, :) = [];
% save(['C:\Users\SF314-51-71UP\Desktop\12\two_dum.mat'],['bargeAssign']);

%%
bargeAssign = permn([1,2,3,4],11);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 5 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 1)) <= 1 || length(find(bargeAssign(j,:) == 2)) <= 1 || length(find(bargeAssign(j,:) == 3)) <= 1 || length(find(bargeAssign(j,:) == 4)) ~= 0
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\11\no_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],11);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 5 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 1)) <= 1 || length(find(bargeAssign(j,:) == 2)) <= 1 || length(find(bargeAssign(j,:) == 3)) <= 1 || length(find(bargeAssign(j,:) == 4)) ~= 1
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\11\one_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],11);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 5 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 1)) <= 1 || length(find(bargeAssign(j,:) == 2)) <= 1 || length(find(bargeAssign(j,:) == 3)) <= 1 || length(find(bargeAssign(j,:) == 4)) ~= 2
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\11\two_dum.mat'],['bargeAssign']);

%%
bargeAssign = permn([1,2,3,4],10);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 5 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 1)) <= 1 || length(find(bargeAssign(j,:) == 2)) <= 1 || length(find(bargeAssign(j,:) == 3)) <= 1 || length(find(bargeAssign(j,:) == 4)) ~= 0
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\10\no_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],10);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 5 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 1)) <= 1 || length(find(bargeAssign(j,:) == 2)) <= 1 || length(find(bargeAssign(j,:) == 3)) <= 1 || length(find(bargeAssign(j,:) == 4)) ~= 1
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\10\one_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],10);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 5 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 1)) <= 1 || length(find(bargeAssign(j,:) == 2)) <= 1 || length(find(bargeAssign(j,:) == 3)) <= 1 || length(find(bargeAssign(j,:) == 4)) ~= 2
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\10\two_dum.mat'],['bargeAssign']);

%%
bargeAssign = permn([1,2,3,4],9);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 4 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 0
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\9\no_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],9);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 4 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 1
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\9\one_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],9);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 4 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 2
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\9\two_dum.mat'],['bargeAssign']);

%%
bargeAssign = permn([1,2,3,4],8);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 4 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 0
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\8\no_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],8);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 4 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 1
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\8\one_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],8);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 4 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 2
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\8\two_dum.mat'],['bargeAssign']);

%%
bargeAssign = permn([1,2,3,4],7);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 3 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 0
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\7\no_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],7);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 3 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 1
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\7\one_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],7);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 3 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 2
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\7\two_dum.mat'],['bargeAssign']);

%%
bargeAssign = permn([1,2,3,4],6);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 3 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 0
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\6\no_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],6);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 3 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 1
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\6\one_dum.mat'],['bargeAssign']);

bargeAssign = permn([1,2,3,4],6);
assignDiscarded = zeros();
counter = 1;
l = length(bargeAssign);


for j = 1:l
    if max(histcounts(bargeAssign(j,:))) >= 3 || sum(diff([0 find(diff(bargeAssign(j,:))) numel(bargeAssign(j,:))]) >= 4) >= 1 || length(find(bargeAssign(j,:) == 4)) ~= 2
        assignDiscarded(1,counter) = j;
        counter = counter + 1;
    end
end

% set the discarded rows to null (remove)
bargeAssign(assignDiscarded, :) = [];
save(['C:\Users\SF314-51-71UP\Desktop\6\two_dum.mat'],['bargeAssign']);
toc