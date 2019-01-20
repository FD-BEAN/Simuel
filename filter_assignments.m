clear;clc;


tic


% for s = 1:64
%     
%     a = load(['C:\Users\SF314-51-71UP\Desktop\final_set_' num2str(s) '.mat']);
%     f = fieldnames(a);
%     tertiary = a.(f{1});
%     
%     assignDiscarded = zeros();
%     counter = 1;
%     l = length(tertiary);
%     
%     for i = 1:l
%         % threshold set at 5
%         if length(find(tertiary(i,:) == 4)) ~= 2
%             assignDiscarded(1,counter) = i;
%             counter = counter + 1;
%         end
%     end
%     
%     % set the discarded rows to null (remove)
%     tertiary(assignDiscarded, :) = [];
%     save(['C:\Users\SF314-51-71UP\Desktop\data_2_dummy\tertiary_' num2str(s) '.mat'],['tertiary']);
%     
% end


for s = 1:64
    
    a = load(['C:\Users\SF314-51-71UP\Desktop\data_1_dummy\tertiary_' num2str(s) '.mat']);
    f = fieldnames(a);
    tertiary = a.(f{1});
    
    assignDiscarded = zeros();
    counter = 1;
    l = length(tertiary);
    
    threshold = 7;
    
    for i = 1:l
        if max(histcounts(tertiary(i,:))) >= threshold || sum(diff([0 find(diff(tertiary(i,:))) numel(tertiary(i,:))]) >= 4) >= 1 || length(find(tertiary(i,:) == 1)) <= 3 || length(find(tertiary(i,:) == 2)) <= 3 || length(find(tertiary(i,:) == 3)) <= 3

            assignDiscarded(1,counter) = i;
            counter = counter + 1;
        end
    end
    
    % set the discarded rows to null (remove)
    tertiary(assignDiscarded, :) = [];
    save(['C:\Users\SF314-51-71UP\Desktop\data_1_dummy_filter\tertiary_' num2str(s) '.mat'],['tertiary']);
    
end



toc