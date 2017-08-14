function [] = plotMPQueries(data,mp,indices,subLen)
% Plots the k queries found by the mp
figure;
subplot(2,1,1);
plot(data, 'LineWidth',1);
hold on;
for i=1:length(indices)
    queryIndex = indices(i);
    plot(queryIndex:queryIndex+subLen-1,data(queryIndex:queryIndex+subLen-1), 'LineWidth',1);
    hold on;
end

subplot(2,1,2);
plot(mp);


end

