%%% time and numerical axis cannot exist in one graph
%%
load for_visualize.mat;
%%
figure('Position',[30 150 600 400])
yLabel = datestr(7.370612e+05:0.000002e+05:7.370632e+05);
set(gca,'YTickLabel',yLabel);
set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10]);
axis([0,11,737061.2,737063.2]);
for i = 1:10
    if vis(i,6) == 4
        text(i-0.6,(vis(i,2)+vis(i,3))/2,'Dummy')
        plot([i,i],[vis(i,2),vis(i,3)],'LineWidth',4,'color','b')
    else
        rectangle('Position',[i-0.25,vis(i,1),0.5,vis(i,4)-vis(i,1)],'EdgeColor','k','LineWidth',2)
        text(i-0.1,(vis(i,4)+vis(i,1))/2,num2str(vis(i,6)))
        hold on
        plot([i,i],[vis(i,1),vis(i,3)],'LineWidth',4,'color','b')
        plot([i,i],[vis(i,2),vis(i,4)],'LineWidth',4,'color','b')
    end
end

for j = 1:10
    if vis_terminal(j,1) ~= 0
        rectangle('Position',[j-0.25,vis_terminal(j,1),0.5,vis_terminal(j,2)-vis_terminal(j,1)],'FaceColor','r','LineWidth',2)
    end
end


figure('Position',[650 150 600 400])
candle([zeros(4,4);2 4 1 3]);
rectangle('Position',[4.75,1.5,0.5,0.3],'FaceColor','r','LineWidth',2)
xlim([0 10]);
ylim([0 5]);
set(gca,'ytick',[1 2 3 4 5]);
set(gca,'YTickLabel',yLabel);
text(1.5,4, 'vessel depart time');
text(1.5,1, 'vessel arrival time');
text(1.5,2, 'start transfer time');
text(1.5,3, 'end transfer time');
text(4.5,2.5,'Barge number');