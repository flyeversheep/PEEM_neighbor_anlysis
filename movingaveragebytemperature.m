function movingaveragebytemperature( filename,spacing)
%This function average the fraction of odd flipping events by temperature
%This function do a moving average of 3 temperature points
filen = sprintf('%s.csv',filename);
averagename = sprintf('%s_movingaverage.csv',filename);
array = csvread(filen);
temperature = unique(array(:,1));

result = zeros(length(temperature),5);
result(:,1) = temperature;
for i=1:length(temperature)
    result(i,2) = mean(array(array(:,1)==temperature(i) |array(:,1)==temperature(i)-spacing|array(:,1)==temperature(i)+spacing,6));
    result(i,3) = std(array(array(:,1)==temperature(i) |array(:,1)==temperature(i)-spacing|array(:,1)==temperature(i)+spacing,6));
    result(i,4) = mean(array(array(:,1)==temperature(i) |array(:,1)==temperature(i)-spacing|array(:,1)==temperature(i)+spacing,7));
    result(i,5) = std(array(array(:,1)==temperature(i) |array(:,1)==temperature(i)-spacing|array(:,1)==temperature(i)+spacing,7));
end
csvwrite(averagename,result);


end

